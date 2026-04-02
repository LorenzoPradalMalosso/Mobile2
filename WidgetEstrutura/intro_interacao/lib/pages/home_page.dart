// Tela inicial
// Vai ter botões de navegação para outras telas

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meu Aplicativo Interativo"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          // Centraliza elementos na horizontal
          child: Column(
            // Alinhamento do eixo vertical
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo do aplicatvo
              Image.network("https://img.olympics.com/images/image/private/t_s_16_9_g_auto/t_s_w1460/f_auto/primary/yxlx1l4edgnyfr4kew6q",
              width: 300,
              height: 300,),
              // Bloco de espaçamento
              SizedBox(height: 20,),
              // Botões de navegação
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/form"), 
                child: Text("Responder Formulário")
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/contato"), 
                child: Text("Entre em Contato")
              )
            ],
          ),
        ),
      ),
    );
  }
}