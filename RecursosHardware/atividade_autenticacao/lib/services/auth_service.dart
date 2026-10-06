import 'api_service.dart';

class AuthService {
  AuthService({ApiService? api}) : _api = api ?? ApiService();
  final ApiService _api;

  Future<void> createAccount(String email, String password) async {
    if (!_validIdentifier(email)) throw const AuthException('Informe um NIF ou e-mail válido.');
    if (password.length < 6) throw const AuthException('A senha deve ter pelo menos 6 caracteres.');
    try { await _api.register(email.trim().toLowerCase(), password); }
    on ApiException catch (e) { throw AuthException(e.message); }
  }

  Future<void> signIn(String email, String password) async {
    if (!_validIdentifier(email) || password.isEmpty) throw const AuthException('Informe um NIF/e-mail e uma senha válidos.');
    try { await _api.login(email.trim().toLowerCase(), password); }
    on ApiException catch (e) { throw AuthException(e.message); }
  }

  Future<String?> biometricAccount() => _api.rememberedEmail();
  bool _validIdentifier(String identifier) => identifier.trim().isNotEmpty && !identifier.contains(RegExp(r'\s'));
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
