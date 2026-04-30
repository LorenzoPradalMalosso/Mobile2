// screens/tela_atividades.dart
// RF-002: Listagem de atividades pendentes
// RF-003: Listagem de atividades concluídas
// RF-004: Adição de nova atividade (via FAB → BottomSheet)
// RF-005: Exclusão de atividade
// RF-006: Marcar atividade como concluída

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitlife_provider.dart';
import '../widgets/item_atividade.dart';
import '../widgets/form_atividade.dart';

class TelaAtividades extends StatelessWidget {
  const TelaAtividades({super.key});

  /// Abre o BottomSheet do formulário para adicionar atividade — RF-004
  void _abrirFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // permite crescer com o teclado
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const FormAtividade(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // ── AppBar com TabBar ───────────────────────────────────────────────
        appBar: AppBar(
          title: const Text(
            'FitLife',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart_rounded),
              tooltip: 'Ver estatísticas',
              onPressed: () {
                // Navega para o dashboard via Provider
                context.read<FitLifeProvider>().setIndexNavegacao(1);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              // Aba de pendentes com contador
              Consumer<FitLifeProvider>(
                builder: (_, p, __) => Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Pendentes'),
                      if (p.pendentes.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        _Badge(count: p.pendentes.length),
                      ],
                    ],
                  ),
                ),
              ),
              // Aba de concluídas com contador
              Consumer<FitLifeProvider>(
                builder: (_, p, __) => Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Concluídas'),
                      if (p.concluidas.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        _Badge(count: p.concluidas.length, color: const Color(0xFF00C853)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Corpo: TabBarView com listas ────────────────────────────────────
        body: const TabBarView(
          children: [
            _ListaPendentes(),   // RF-002
            _ListaConcluidas(),  // RF-003
          ],
        ),

        // ── FAB para adicionar atividade — RF-004 ───────────────────────────
        floatingActionButton: FloatingActionButton(
          onPressed: () => _abrirFormulario(context),
          tooltip: 'Adicionar atividade',
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }
}

// ── Lista de Pendentes — RF-002 ─────────────────────────────────────────────
class _ListaPendentes extends StatelessWidget {
  const _ListaPendentes();

  @override
  Widget build(BuildContext context) {
    final pendentes = context.watch<FitLifeProvider>().pendentes;

    if (pendentes.isEmpty) {
      return _EstadoVazio(
        icone: Icons.check_circle_outline_rounded,
        mensagem: 'Nenhuma atividade pendente.\nAdicione uma com o botão +',
        cor: Colors.green,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: pendentes.length,
      itemBuilder: (_, i) => ItemAtividade(atividade: pendentes[i]),
    );
  }
}

// ── Lista de Concluídas — RF-003 ─────────────────────────────────────────────
class _ListaConcluidas extends StatelessWidget {
  const _ListaConcluidas();

  @override
  Widget build(BuildContext context) {
    final concluidas = context.watch<FitLifeProvider>().concluidas;

    if (concluidas.isEmpty) {
      return _EstadoVazio(
        icone: Icons.directions_run_rounded,
        mensagem: 'Nenhuma atividade concluída ainda.\nVamos lá!',
        cor: Colors.grey,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: concluidas.length,
      itemBuilder: (_, i) => ItemAtividade(atividade: concluidas[i]),
    );
  }
}

// ── Estado vazio (lista vazia) ───────────────────────────────────────────────
class _EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String mensagem;
  final Color cor;

  const _EstadoVazio({
    required this.icone,
    required this.mensagem,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 72, color: cor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge de contagem ────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final int count;
  final Color color;

  const _Badge({required this.count, this.color = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}