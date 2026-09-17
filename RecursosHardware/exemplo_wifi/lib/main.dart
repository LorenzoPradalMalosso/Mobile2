// Exemplo de leitura de sensor de conexão

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Texto da mensagem
  String _mensagem = "Verificando...";

  // Objeto para "ouvir as mudanças de Conexão"
  late StreamSubscription<List<ConnectivityResult>> _wifiObserver;

  // Métodos
  // Método para verificar a conexão
  void _checkConnection() async {
    // Cria uma variável para receber as mudanças
    var _connectivityResult = (await Connectivity().checkConnectivity()) as ConnectivityResult;
    _updateConnectionStatus(_connectivityResult);
  }

  // Método para atualizar as mudanças de conexão
  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
          _mensagem = "Conectado no WIFI";
          break;
        case ConnectivityResult.mobile:
          _mensagem = "Conectado nos Dados Móveis";
          break;
        case ConnectivityResult.none:
          _mensagem = "Sem Conexão com a Internet";
          break;
        default:
          _mensagem = "Procurando Conexão";
          break;
      }
    });
  }

  // Início
  @override
  void initState() {
    super.initState();
    // 1. CheckConexão
    _checkConnection();
    // 2. Habilita o Stream para ouvir a mudança de conexão
    _wifiObserver = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Pega o resultado disponível e transmite para o update
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  // Limpa a memória ao sair da tela
  @override
  void dispose() {
    super.dispose();
    _wifiObserver.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Status da Conexão"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              // Ícone vai mudar de acordo com a conexão
              _mensagem.contains("WIFI") ? Icons.wifi :
              _mensagem.contains("Dados") ? Icons.network_cell :
              Icons.wifi_off,
              size: 80,
              color: _mensagem.contains("Sem") ? Colors.red : Colors.green,
            ),
            SizedBox(height: 10,),
            Text("Status: $_mensagem"),
          ],
        ),
      ),
    );
  }
}