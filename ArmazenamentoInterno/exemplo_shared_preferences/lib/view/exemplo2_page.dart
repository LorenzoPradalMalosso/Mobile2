import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Exemplo2Page extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const Exemplo2Page({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<Exemplo2Page> createState() => _Exemplo2PageState();
}

class _Exemplo2PageState extends State<Exemplo2Page> {
  late SharedPreferences _prefs;
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.darkMode;
    _loadPreferences();
  }

  void _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = _prefs.getBool('darkMode') ?? widget.darkMode;
    });
  }

  void _toggleTheme() async {
    setState(() {
      _darkMode = !_darkMode;
    });
    await _prefs.setBool('darkMode', _darkMode);
    widget.onThemeChanged(_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Escuro com Shared Preferences'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tema Atual: ${_darkMode ? 'Escuro' : 'Claro'}'),
            const SizedBox(height: 16),
            Switch(
              value: _darkMode,
              onChanged: (_) => _toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
