import 'package:flutter/material.dart';
import 'package:exemplo_shared_preferences/view/home_page.dart';
import 'package:exemplo_shared_preferences/view/exemplo1_page.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    routes: {
      "/tela1": (context) => Exemplo1Page(),
      // "/tela2": (context) => ExemploPage2(),
      // "/tela3": (context) => ExemploPage3();
    },
    home: HomePage(),
  ));
}