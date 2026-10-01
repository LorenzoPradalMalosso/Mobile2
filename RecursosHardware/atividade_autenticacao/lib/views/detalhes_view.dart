import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/punch_record.dart';

class DetalhesView extends StatelessWidget {
  const DetalhesView({required this.registro, super.key});
  final PunchRecord registro;

  @override
  Widget build(BuildContext context) {
    final date = registro.at;
    final photo = registro.photoPath;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do ponto')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (photo.isNotEmpty && File(photo).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.file(File(photo), height: 220, fit: BoxFit.cover),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    registro.type,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF176B58),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _info(
                    Icons.calendar_month,
                    'Data e hora',
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                  ),
                  const Divider(height: 28),
                  _info(
                    Icons.social_distance,
                    'Distância do local',
                    '${registro.distance.round()} m',
                  ),
                  const Divider(height: 28),
                  _info(
                    Icons.notes,
                    'Observação',
                    registro.note.isEmpty ? 'Sem observação' : registro.note,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Localização registrada',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(registro.latitude, registro.longitude),
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.atividade_autenticacao',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(registro.latitude, registro.longitude),
                        width: 46,
                        height: 46,
                        child: const Icon(
                          Icons.location_pin,
                          size: 44,
                          color: Color(0xFF176B58),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lat. ${registro.latitude.toStringAsFixed(6)} · Long. ${registro.longitude.toStringAsFixed(6)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String title, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: const Color(0xFF176B58)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ],
  );
}
