// Widget de navegação inferior

import 'package:flutter/material.dart';

Widget Bnb(BuildContext context){
  List<String> rotas = ["/", "/form", "/contato"];
  int currentIndex = 0;

  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.format_align_center), label: "Form"),
      BottomNavigationBarItem(icon: Icon(Icons.contact_page), label: "Contato"),
    ],
    // Método de Navegação entre Telas
    currentIndex: currentIndex,
    onTap: (index) {
      currentIndex = index;
      // Navegação entre telas

      Navigator.pushNamed(context, rotas[index]);
    },
  );
}