import 'dart:io';

import 'package:flutter/material.dart';

import '../models/registro_model.dart';

class DetalhesView extends StatelessWidget {
  final Registro registro;

  const DetalhesView({super.key, required this.registro});

  String _formatarDataHora(String dataHora) {
    try {
      final dt = DateTime.parse(dataHora);
      final dia = dt.day.toString().padLeft(2, '0');
      final mes = dt.month.toString().padLeft(2, '0');
      final ano = dt.year;
      final hora = dt.hour.toString().padLeft(2, '0');
      final minuto = dt.minute.toString().padLeft(2, '0');
      final segundo = dt.second.toString().padLeft(2, '0');
      return '$dia/$mes/$ano às $hora:$minuto:$segundo';
    } catch (_) {
      return dataHora;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detalhes do Registro',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto do registro
            Container(
              height: 260,
              color: const Color(0xFF0F172A),
              child: File(registro.caminhoFoto).existsSync()
                  ? Image.file(
                      File(registro.caminhoFoto),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Foto não disponível',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Informações
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data e Hora
                  _buildInfoItem(
                    icon: Icons.access_time,
                    label: 'Data e Hora',
                    valor: _formatarDataHora(registro.dataHora),
                  ),
                  const Divider(height: 32),

                  // Localização
                  _buildInfoItem(
                    icon: Icons.location_on_outlined,
                    label: 'Localização',
                    valor:
                        'Lat: ${registro.latitude.toStringAsFixed(6)}\nLng: ${registro.longitude.toStringAsFixed(6)}',
                  ),
                  const Divider(height: 32),

                  // Observação
                  _buildInfoItem(
                    icon: Icons.notes,
                    label: 'Observação',
                    valor: registro.observacao,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String valor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}