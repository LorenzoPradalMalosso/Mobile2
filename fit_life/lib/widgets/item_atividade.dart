// widgets/item_atividade.dart
// Widget reutilizável para exibir uma atividade nas listas de pendentes e concluídas
// RF-002, RF-003, RF-005, RF-006

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/atividade.dart';
import '../providers/fitlife_provider.dart';

class ItemAtividade extends StatelessWidget {
  final Atividade atividade;

  const ItemAtividade({super.key, required this.atividade});

  /// Exibe diálogo de confirmação antes de excluir — RF-005
  Future<void> _confirmarExclusao(BuildContext context) async {
    final provider = context.read<FitLifeProvider>();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir atividade?'),
        content: Text('Deseja remover "${atividade.nome}" da lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      provider.excluirAtividade(atividade.id, concluida: atividade.concluida);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.read<FitLifeProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // ── Checkbox / ícone de status ──────────────────────────────────
            if (!atividade.concluida)
              // Botão de concluir — RF-006
              IconButton(
                icon: Icon(
                  Icons.radio_button_unchecked_rounded,
                  color: colorScheme.primary,
                  size: 28,
                ),
                tooltip: 'Marcar como concluída',
                onPressed: () => provider.concluirAtividade(atividade.id),
              )
            else
              const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF00C853),
                  size: 28,
                ),
              ),

            const SizedBox(width: 4),

            // ── Informações da atividade ────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    atividade.nome,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      decoration: atividade.concluida
                          ? TextDecoration.lineThrough
                          : null,
                      color: atividade.concluida
                          ? colorScheme.onSurface.withOpacity(0.5)
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Tempo
                      Icon(Icons.timer_outlined, size: 13,
                          color: colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 3),
                      Text(
                        '${atividade.duracaoMinutos} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Calorias
                      Icon(Icons.local_fire_department_outlined, size: 13,
                          color: colorScheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 3),
                      Text(
                        '${atividade.caloriasEstimadas.toStringAsFixed(0)} kcal',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Botão excluir — RF-005 ──────────────────────────────────────
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  color: colorScheme.onSurface.withOpacity(0.4)),
              tooltip: 'Excluir atividade',
              onPressed: () => _confirmarExclusao(context),
            ),
          ],
        ),
      ),
    );
  }
}