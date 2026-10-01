import 'dart:io';

import 'package:flutter/material.dart';

import '../models/punch_record.dart';

class PunchRecordCard extends StatelessWidget {
  const PunchRecordCard({required this.record, required this.onTap, super.key});
  final PunchRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = record.at;
    final photo = record.photoPath;
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: SizedBox.square(
                  dimension: 46,
                  child: photo.isNotEmpty && File(photo).existsSync()
                      ? Image.file(File(photo), fit: BoxFit.cover)
                      : Container(
                          color: const Color(0xFFE1F1E9),
                          child: Icon(
                            record.type == 'Entrada'
                                ? Icons.login
                                : Icons.logout,
                            color: const Color(0xFF176B58),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.type,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} · ${record.distance.round()} m do local',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Color(0xFF176B58)),
            ],
          ),
        ),
      ),
    );
  }
}
