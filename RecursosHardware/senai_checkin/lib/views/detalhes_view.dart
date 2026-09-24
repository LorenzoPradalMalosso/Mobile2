import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../database/database_helper.dart';
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

  Future<void> _excluirRegistro(BuildContext context) async {
    if (registro.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível identificar este registro para excluir.'),
          backgroundColor: Color(0xFF990000),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir ponto?'),
        content: const Text(
          'Deseja realmente remover este registro e a foto associada?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFCC0000),
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      return;
    }

    try {
      final arquivoFoto = File(registro.caminhoFoto);
      if (arquivoFoto.existsSync()) {
        arquivoFoto.deleteSync();
      }

      await DatabaseHelper().delete(registro.id!);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ponto excluído com sucesso!'),
            backgroundColor: Color(0xFF0284C7),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao excluir o ponto.'),
            backgroundColor: Color(0xFF990000),
          ),
        );
      }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir registro',
            onPressed: () => _excluirRegistro(context),
          ),
        ],
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
                  _buildInfoItem(
                    icon: Icons.location_city,
                    label: 'Cidade',
                    valor: registro.cidade.isNotEmpty
                        ? registro.cidade
                        : 'Cidade não identificada',
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            registro.latitude,
                            registro.longitude,
                          ),
                          initialZoom: 15,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'senai_checkin',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(registro.latitude, registro.longitude),
                                width: 42,
                                height: 42,
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 42,
                                  color: Color(0xFFCC0000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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