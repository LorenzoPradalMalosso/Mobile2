// Uso do Shared Preferences para Armazenar o Nome do Usuário

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo1Page extends StatefulWidget {
  const Exemplo1Page({super.key});

  @override
  State<Exemplo1Page> createState() => _Exemplo1PageState();
}

class _Exemplo1PageState extends State<Exemplo1Page> {
  TextEditingController _nomeInput = TextEditingController();
  String _nomeSalvo = "";

  // Uso shared para buscar o nome no inicio do aplicativo 
  // Salvar nome nas preferencias
  _salvarNomeShared() async { // Conexão async => Permite continuar rodando o código enquanto é feito a conexão com a base de dados
    // Conectar com o SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Busca as informações salvas no shared prefs
    await prefs.setString("nome", _nomeInput.text.trim()); // Salvou na chave "nome" => o valor colocado no input
    _nomeInput.clear();
    _carregarNomeShared();
  }

  // Buscar nome nas preferencias
  _carregarNomeShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeSalvo = prefs.getString("nome") ?? ""; // Operador de nulidade
    });
  }

  // Início da página
  @override
  void initState() { // Carrega informações do SharedPreferences antes de buildar a tela pela primeira vez
    super.initState();
    _carregarNomeShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem Vindo $_nomeSalvo"), centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: _nomeInput,
              decoration: InputDecoration(labelText: "Digite seu nome..."),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: _salvarNomeShared, child: Text("Salvar")),
            SizedBox(height: 10,),
            Text("O Nome do Usuário Atual é $_nomeSalvo", style: TextStyle(fontSize: 20),),
            SizedBox(height: 20,),
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Voltar"))
          ],
        ),
      ),
    );
  }
}