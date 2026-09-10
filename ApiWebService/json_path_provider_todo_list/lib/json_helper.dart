// Lógica de persistência de Dados

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
// Importar o path_provider

class JsonHelper {
  // Métodos static => Médotos da Classe e não do OBJ (para usar o método não precisa instanciar OBJ)
  // 1. Método Obter Arquivo Json (static)
  static Future<File> _getArquivo() async{
    final diretorio = await getApplicationDocumentsDirectory(); // Buscando os arquivos do aplicativo
    return File("${diretorio.path}/bd.json"); // Retorna o caminho do arquivo json
    // Se arquivo não existir, ele será criado automaticamente
  }

  // 2. Ler todos os Dados do Json (Converter Json em Map)
  static Future<Map<String, dynamic>> lerDados() async{
    try {
      final arquivo = await _getArquivo();//busco o arquivo
      //verifico se o arquivo existe
      if(await arquivo.exists()){
        String conteudo = await arquivo.readAsString();
        return json.decode(conteudo);
      }
    } catch (e) {
      print("Erro ao ler o arquivo: $e");
    }
    return {}; // Retorna um Map vazio se não existir ou der erro
  }


  // 3. Salvar os Dados no Arquivo Json
  static void salvarDados(Map<String,dynamic> dados) async{
    final arquivo = await _getArquivo();// Pegando o logal do arquivo
    String jsonString = json.encode(dados);// Transformando MAP em Json
    await arquivo.writeAsString(jsonString); // Armazenando os dados no local 
  } 
}