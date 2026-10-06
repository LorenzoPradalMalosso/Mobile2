import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// REST contract: POST /auth/register, POST /auth/login, GET /punches,
/// POST /punches. Set API_BASE_URL with --dart-define for the target server.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );
  static const _tokenKey = 'api_access_token';
  static const _emailKey = 'employee_email';
  static const _userKey = 'employee_id';

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');
  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = (await SharedPreferences.getInstance()).getString(_tokenKey);
      if (token == null || token.isEmpty) throw const ApiException('Sessão expirada. Entre novamente.');
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _request(String method, String path,
      {Map<String, Object?>? body, bool auth = false}) async {
    try {
      final headers = await _headers(auth: auth);
      final response = switch (method) {
        'GET' => await _client.get(_uri(path), headers: headers),
        'POST' => await _client.post(_uri(path), headers: headers, body: jsonEncode(body)),
        _ => throw StateError('Método HTTP não suportado'),
      };
      final decoded = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded is Map ? decoded['message'] ?? decoded['error'] : null;
        throw ApiException(message?.toString() ?? 'Erro da API (${response.statusCode}).');
      }
      if (decoded is! Map<String, dynamic>) throw const ApiException('Resposta inválida da API.');
      return decoded;
    } on ApiException { rethrow; }
    catch (e) { throw ApiException('Não foi possível conectar à API: $e'); }
  }

  Future<Map<String, String>> _authenticate(String endpoint, String identifier, String password) async {
    final isEmail = identifier.contains('@');
    final data = await _request('POST', endpoint, body: {
      'identifier': identifier,
      if (isEmail) 'email': identifier,
      'password': password,
    });
    final user = data['user'] is Map ? Map<String, dynamic>.from(data['user'] as Map) : data;
    final token = (data['token'] ?? data['access_token'])?.toString();
    final account = (user['email'] ?? user['identifier'] ?? identifier).toString();
    final id = (user['id'] ?? user['userId'] ?? account).toString();
    if (token == null || token.isEmpty) throw const ApiException('A API não retornou um token de acesso.');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_emailKey, account);
    await prefs.setString(_userKey, id);
    return {'id': id, 'email': account};
  }

  Future<Map<String, String>> register(String identifier, String password) => _authenticate('/auth/register', identifier, password);
  Future<Map<String, String>> login(String identifier, String password) => _authenticate('/auth/login', identifier, password);
  Future<String?> rememberedEmail() async => (await SharedPreferences.getInstance()).getString(_emailKey);
  Future<String?> rememberedUserId() async => (await SharedPreferences.getInstance()).getString(_userKey);
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_userKey);
  }

  Future<List<Map<String, dynamic>>> listPunches() async {
    final data = await _request('GET', '/punches', auth: true);
    final items = data['records'] ?? data['punches'] ?? data['data'] ?? [];
    if (items is! List) throw const ApiException('A lista de registros retornada pela API é inválida.');
    return items.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<Map<String, dynamic>> createPunch(Map<String, Object?> punch) async {
    final data = await _request('POST', '/punches', body: punch, auth: true);
    final item = data['record'] ?? data['punch'] ?? data['data'] ?? data;
    return Map<String, dynamic>.from(item as Map);
  }
}

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
