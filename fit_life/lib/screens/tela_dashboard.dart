// screens/tela_dashboard.dart
// RF-007: Painel de métricas e indicadores de desempenho do usuário
// Atualização automática via Provider (notifyListeners)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitlife_provider.dart';
import '../widgets/card_metrica.dart';

class TelaDashboard extends StatelessWidget {
  const TelaDashboard({super.key});

  /// Formata minutos em horas e minutos: ex. 205 → "3h25min"
  String _formatarTempo(int minutos) {
    if (minutos == 0) return '0 min';
    final h = minutos ~/ 60;
    final m = minutos % 60;
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}min';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitLifeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Semana atual',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cabeçalho da semana ─────────────────────────────────────────
            Text(
              'Semana Atual',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // ── Card de Progresso Semanal (destaque) ────────────────────────
            _CardProgresso(provider: provider),
            const SizedBox(height: 16),

            // ── GridView com 4 métricas — RF-007 ───────────────────────────
            Text(
              'Métricas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                // RF-007: Realizadas
                CardMetrica(
                  titulo: 'Realizadas',
                  valor: '${provider.concluidas.length}',
                  icone: Icons.check_circle_rounded,
                  corIcone: const Color(0xFF00C853),
                  corFundo: const Color(0xFF00C853).withOpacity(0.15),
                ),
                // RF-007: Pendentes
                CardMetrica(
                  titulo: 'Pendentes',
                  valor: '${provider.pendentes.length}',
                  icone: Icons.pending_actions_rounded,
                  corIcone: Colors.orange,
                  corFundo: Colors.orange.withOpacity(0.15),
                ),
                // RF-007: Meta Semanal
                CardMetrica(
                  titulo: 'Meta Semanal',
                  valor: '${provider.metaSemanal}',
                  icone: Icons.flag_rounded,
                  corIcone: Colors.blue,
                  corFundo: Colors.blue.withOpacity(0.15),
                ),
                // RF-007: Calorias
                CardMetrica(
                  titulo: 'Calorias (kcal)',
                  valor: provider.totalCalorias.toStringAsFixed(0),
                  icone: Icons.local_fire_department_rounded,
                  corIcone: Colors.deepOrange,
                  corFundo: Colors.deepOrange.withOpacity(0.15),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Card de Tempo Total — RF-007 ────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.access_time_filled_rounded,
                          color: colorScheme.secondary, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatarTempo(provider.tempoTotalMinutos),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          'Tempo total de treino',
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Lembrete motivacional ───────────────────────────────────────
            if (provider.progressoSemanal >= 1.0)
              _CardMotivacional(
                mensagem: 'Meta da semana atingida! Parabéns, ${provider.nomeUsuario.split(' ').first}!',
                cor: const Color(0xFF00C853),
              )
            else if (provider.concluidas.isEmpty)
              _CardMotivacional(
                mensagem: 'Vamos começar! Conclua sua primeira atividade.',
                cor: Colors.blue,
              )
            else
              _CardMotivacional(
                mensagem: 'Continue! Faltam ${provider.metaSemanal - provider.concluidas.length} atividades para a meta.',
                cor: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Card de Progresso com barra visual ──────────────────────────────────────
class _CardProgresso extends StatelessWidget {
  final FitLifeProvider provider;

  const _CardProgresso({required this.provider});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progresso = provider.progressoSemanal;
    final percentual = provider.progressoPercentual;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progresso Semanal',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(
                  '$percentual%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Barra de progresso
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 12,
                backgroundColor: colorScheme.primaryContainer.withOpacity(0.4),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progresso >= 1.0 ? const Color(0xFF00C853) : colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Legenda
            Text(
              'Meta Semanal: ${provider.concluidas.length} de ${provider.metaSemanal} atividades concluídas',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card motivacional ────────────────────────────────────────────────────────
class _CardMotivacional extends StatelessWidget {
  final String mensagem;
  final Color cor;

  const _CardMotivacional({required this.mensagem, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Text(
        mensagem,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: cor.withOpacity(0.9),
        ),
      ),
    );
  }
}