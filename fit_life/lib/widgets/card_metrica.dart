// widgets/card_metrica.dart
// Widget reutilizável para exibir uma métrica no GridView do Dashboard
// RF-007: cards de métricas (atividades realizadas, pendentes, meta, progresso, etc.)
 
import 'package:flutter/material.dart';
 
class CardMetrica extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color? corIcone;
  final Color? corFundo;
 
  const CardMetrica({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
    this.corIcone,
    this.corFundo,
  });
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = corIcone ?? colorScheme.primary;
    final bgColor = corFundo ?? colorScheme.primaryContainer.withOpacity(0.4);
 
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone com fundo circular
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: iconColor, size: 22),
            ),
            const Spacer(),
 
            // Valor em destaque
            Text(
              valor,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
 
            const SizedBox(height: 2),
 
            // Título/rótulo da métrica
            Text(
              titulo,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}