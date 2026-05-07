import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exemplo_shared_preferences/view/home_page.dart';
import 'package:exemplo_shared_preferences/view/exemplo1_page.dart';
import 'package:exemplo_shared_preferences/view/exemplo2_page.dart';
import 'package:exemplo_shared_preferences/view/exemplo3_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _loading = false;
    });
  }

  void _updateThemeMode(bool darkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
    setState(() {
      _darkMode = darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      routes: {
        '/tela1': (context) => Exemplo1Page(),
        '/tela2': (context) => Exemplo2Page(
              darkMode: _darkMode,
              onThemeChanged: _updateThemeMode,
            ),
        '/tela3': (context) => Exemplo3Page(),
      },
      home: const HomePage(),
    );
  }
}