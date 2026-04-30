// main.dart
// Ponto de entrada da aplicação FitLife
// Configura o ChangeNotifierProvider e o tema global (claro/escuro)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fitlife_provider.dart';
import 'screens/tela_inicial.dart';

void main() {
  runApp(
    // Registra o FitLifeProvider na raiz da árvore de widgets
    ChangeNotifierProvider(
      create: (_) => FitLifeProvider()..carregarDadosExemplo(),
      child: const FitLifeApp(),
    ),
  );
}

class FitLifeApp extends StatelessWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consome apenas o modoEscuro para reconstruir o MaterialApp quando mudar
    final modoEscuro = context.select<FitLifeProvider, bool>((p) => p.modoEscuro);

    return MaterialApp(
      title: 'FitLife',
      debugShowCheckedModeBanner: false,
      themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

      // ── Tema Claro ─────────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853), // verde vibrante
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1A1A2E),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00C853),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C853),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),

      // ── Tema Escuro ────────────────────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF161B22),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C2128),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00C853),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C853),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),

      home: const TelaInicial(),
    );
  }
}