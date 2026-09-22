import 'dart:io';

import 'package:flutter/material.dart';

import '../models/registro_model.dart';

class RegistroCard extends StatelessWidget {
  final Registro registro;
  final VoidCallback onTap;

  const RegistroCard({
    super.key,
    required this.registro,
    required this.onTap,
  });

  String _formatarDataHora(String dataHora) {
    try {
      final dt = DateTime.parse(dataHora);
      final dia = dt.day.toString().padLeft(2, '0');
      final mes = dt.month.toString().padLeft(2, '0');
      final ano = dt.year;
      final hora = dt.hour.toString().padLeft(2, '0');
      final minuto = dt.minute.toString().padLeft(2, '0');
      return '$dia/$mes/$ano às $hora:$minuto';
    } catch (_) {
      return dataHora;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail da foto
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: File(registro.caminhoFoto).existsSync()
                      ? Image.file(
                          File(registro.caminhoFoto),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Informações do registro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarDataHora(registro.dataHora),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      registro.observacao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Ícone de navegação
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF990000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}