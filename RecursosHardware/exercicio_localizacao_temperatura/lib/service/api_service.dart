import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather"; // URL da API

  static String apiKey = "90290436d34bb91b4d852afe49197129"; // Chave da API

  // GET(One)
  static Future<Map<String,dynamic>> getOne(double lat, double lon) async {
    final resposta = await http.get(Uri.parse("$baseUrl?lat=$lat&lon=$lon&appid=$apiKey"));
    if(resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    }
    throw Exception("Falha de conexão com a api");
  }

}