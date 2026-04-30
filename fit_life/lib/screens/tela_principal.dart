// screens/tela_principal.dart
// RF-009: Scaffold + BottomNavigationBar
// Navegação principal entre as 3 abas: Atividades, Dashboard, Configurações

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitlife_provider.dart';
import 'tela_atividades.dart';
import 'tela_dashboard.dart';
import 'tela_configuracoes.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FitLifeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: IndexedStack(
            index: provider.indexNavegacao,
            children: const [
              TelaAtividades(),    // Aba 0
              TelaDashboard(),     // Aba 1
              TelaConfiguracoes(), // Aba 2
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: provider.indexNavegacao,
            onDestinationSelected: (index) {
              provider.setIndexNavegacao(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center_rounded),
                label: 'Atividades',
              ),
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Configurações',
              ),
            ],
          ),
        );
      },
    );
  }
}