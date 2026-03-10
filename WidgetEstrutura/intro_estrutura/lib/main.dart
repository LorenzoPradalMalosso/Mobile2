// Criar o void main
// Responsável por rodar o elemento principal da aplicação

import 'package:flutter/material.dart';

void main(){
  //runApp => chama o elemento com o materialApp
  runApp(MainApp());
}

// Criar a classe MainApp
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Montar a estrutura do MaterialApp
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Tela de Login"),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ // Permite mais de 1, abre colchetes
              // Elementos de input de texto
              Text("Email"),
              TextField(textAlign: TextAlign.center,),
              Text("Senha"),
              TextField(textAlign: TextAlign.center,obscureText: true,),
              TextButton(onPressed: (){}, child: Text("Enviar"))
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: // Permite mais de 1, abre colchetes
          [
            BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "back"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.arrow_forward), label: "forward"),
          ]
         ),
      ),
    );
  }
}