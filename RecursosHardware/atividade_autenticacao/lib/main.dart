import 'package:flutter/material.dart';

import 'views/sign_in_view.dart';

void main() => runApp(const PontoSeguroApp());

class PontoSeguroApp extends StatelessWidget {
  const PontoSeguroApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ponto Seguro',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B58)),
      scaffoldBackgroundColor: const Color(0xFFF5F7F5),
      fontFamily: 'Roboto',
    ),
    home: const SignInScreen(),
  );
}
