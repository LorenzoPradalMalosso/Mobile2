// Uso de Elementos de Interação (TextField, ElevatedButton, CehckBox, Slider)
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/form_page.dart';
import 'pages/contato_page.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // Sistema de rotas para navegação entre telas
    // Home (Tela Inicial), Form (Tela com formulário), Contato (Formulário de contato)
    routes: {
      "/":(context) => HomePage(),
      "/form":(context) => FormPage(),
      "/contato":(context) => ContatoPage(),
    },
    // Direcionar o aplicativo quando iniciar para a home
    initialRoute: "/",
  ));
}

// Página main finalizada