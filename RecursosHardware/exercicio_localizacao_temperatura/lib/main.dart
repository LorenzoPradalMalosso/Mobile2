// Aplicação de exemplo d código

import 'package:exercicio_1/service/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    getAutorizacao();
  }

  Future<void> getAutorizacao() async{
    // Solicitar a geolocalização quando for disparado o handle
    bool enable;
    LocationPermission permission;

    // Verificar se o serviço de localização está habilitado
    enable = await Geolocator.isLocationServiceEnabled();

    // Se não estiver habilitado => preciso pedir permissão
    if(!enable) {
      setState(() {
        mensagem = "Serviço de Localização Desabiltado";
      });
      return;
    }

    // Verificar permissão
    permission = await Geolocator.checkPermission();

    // Pedir permissão caso não tenha sido concedida
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      // Se negar a permissão
      if(permission == LocationPermission.denied){
        setState(() {
          mensagem = "Acesso de Localização não permitido pelo usuário";
        });
        return;
      }
    }

    // Permissão negada permanentemente
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        mensagem = "Permissão de localização negada permanentemente";
      });
      return;
    }
  }

  Future<void> consultarTemperatura() async {
    // Pegar posição atual
    Position position = await Geolocator.getCurrentPosition();

    double lat = position.latitude;
    double lon = position.longitude;

    // Consultar API
    final dados = await ApiService.getOne(lat, lon);

    //Atualizar tela
    setState(() {
      mensagem = "Cidade: ${dados["name"]} | Temperatura: ${dados["main"]["temp"]}°C.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS - Temperatura"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem),
            ElevatedButton(
              onPressed: ()async{
                await consultarTemperatura();
              },
              child: Text("Obter Localização e Temperatura")
            )
          ],
        ),
      ),
    );
  }
}