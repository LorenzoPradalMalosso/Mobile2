// Exemplo de Uso do Bluetooth => com uso do Stream no corpo da Aplicação

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Método

  // Iniciar o Escaneamento do Bluetooth
  void _startSacan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
  }

  @override
  void initState() {
    super.initState();
    _startSacan();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dispositivos BlueTooh"),
      actions: [
        IconButton(onPressed: _startSacan, icon: Icon(Icons.refresh))
      ],),
      // 1° Stream para Verificar a Conexão
      body: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (context, snapshot) {
          final isScanning = snapshot.data ?? false; // Verifica se o resultado é null e caso null transforma em false (Coalescência Nula)
          // 2º Stream: Monitorar os Dispositivos Encontrados
          return StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.scanResults,
            initialData: [],
            builder: (context, snapshotResult) {
              final dispositivos = snapshotResult.data ?? [];
              // Montar a lista de dispositivos
              if (isScanning && dispositivos.isEmpty) {
                return Center(child: CircularProgressIndicator(),);
              } else if (dispositivos.isEmpty) {
                return Center(child: Text("Lista Vazia"),);
              } else {
                return ListView.builder(
                  itemCount: dispositivos.length,
                  itemBuilder: (context, index) {
                    final item = dispositivos[index];
                    final name = item.device.platformName.isNotEmpty ? item.device.platformName : "Dispositivo Genério";
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(item.device.remoteId.str),
                      trailing: Text("${item.rssi} dBm"),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}