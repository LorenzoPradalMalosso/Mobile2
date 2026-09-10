// Aplicação de exemplo d código

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mensagem = "Localização não obtida";

  void getLocation() async{
    // Solicitar a geolocalização quando for disparado o handle
    bool enable;
    LocationPermission permission;

    enable = await Geolocator.isLocationServiceEnabled(); // Verificar se o serviço de localização está habilitado

    // Se não estiver habilitado => preciso pedir permissão
    if(!enable) {
      mensagem = "Serviço de Localização Desabiltado";
    }
    permission = await Geolocator.checkPermission(); // Verificar permissão
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission(); // Pedir permissão
      // Se negar a permissão
      if(permission == LocationPermission.denied){
        mensagem = "Acesso de Localização não permitido pelo usuário";
      }
    }

    // Permisão liberada
    Position position = await Geolocator.getCurrentPosition(); // Pega a posição atual do dispositivo
    mensagem = "Latitude ${position.latitude}, Longitude ${position.longitude}";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS - Localização"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem),
            ElevatedButton(
              onPressed: ()async{
                setState(() {
                  getLocation();
                });
              },
              child: Text("Obter Localização")
            )
          ],
        ),
      ),
    );
  }
}