import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp()
  ));
}

// Importando as características da página StateFull
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Método para identificar as mudanças de estado e chamar a reconstrução da janela
  @override // Reescrita de um método existente
  State<MyApp> createState() => _MyAppState();
  // Arrow Function
}

// Class para construção da lógica e da estrutura da janela
class _MyAppState extends State<MyApp> {
  // A classe normal da aplicação
  // Atributos
  int contador = 0;

  // Método build da tela (método obrigatório)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar - Título do app
      appBar: AppBar(title:Text("Aplicativo com StateFull - Contador")),
      // body
      // Container para espaçamento interno
      body: Padding(
        padding: EdgeInsets.all(8), // Espaçamento interno de 8px em todas as bordas
        // Container para centralizar os Elementos no meio da tela (Esquerda e Direita)
        child: Center( //|->elemento<-|)
          // Column => Permite adicionar mais de um elemento
          child: Column(
            // Centraliza os elemenos no Eixo Principal da Column (Y)
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nº de Click: $contador", style: TextStyle(fontSize: 20)),
              // Adicionar um botão => Toda vez que for pressionado vai criar uma ação (uma mudança de Estado)
              ElevatedButton(
                onPressed: (){
                  // Adicionar setState (Mudança de Estado)
                  setState(() {
                    // Colocar uma modificação na tele
                    contador ++; // Adiciona 1 ao contador 
                  });
                },
                child: Text("Adicionar + 1"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}