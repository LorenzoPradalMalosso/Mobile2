import 'package:flutter/material.dart';

import 'services/permission_service.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final PermissionService _permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    _solicitarPermissoesIniciais();
  }

  Future<void> _solicitarPermissoesIniciais() async {
    await _permissionService.solicitarPermissoesIniciais();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENAI Check-in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFCC0000),
          primary: const Color(0xFFCC0000),
          secondary: const Color(0xFF990000),
          tertiary: const Color(0xFF0284C7),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
