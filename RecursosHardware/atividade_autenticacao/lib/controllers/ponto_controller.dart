import 'package:geolocator/geolocator.dart';

import '../models/punch_record.dart';
import '../models/workplace.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class PontoController {
  PontoController({ApiService? api, LocationService? location})
    : _api = api ?? ApiService(), _location = location ?? LocationService();
  final ApiService _api;
  final LocationService _location;

  Future<Position> currentPosition() => _location.currentPosition();

  Future<List<PunchRecord>> list(String accountId) async =>
      (await _api.listPunches()).map(PunchRecord.fromMap).toList();

  Future<PunchRecord> register(String accountId, {String note = '', String photoPath = ''}) async {
    final position = await _location.currentPosition();
    final distance = Geolocator.distanceBetween(position.latitude, position.longitude,
        workplace.latitude, workplace.longitude);
    if (distance > radiusMeters) {
      throw Exception('Você está a ${distance.round()} m do local. O limite permitido é ${radiusMeters.round()} m.');
    }
    final records = await list(accountId);
    final type = records.isNotEmpty && records.first.type == 'Entrada' ? 'Saída' : 'Entrada';
    final record = await _api.createPunch({
      'type': type,
      'at': DateTime.now().toUtc().toIso8601String(),
      'latitude': position.latitude,
      'longitude': position.longitude,
      'distance_meters': distance,
      'note': note.trim(),
      'workplace': workplace.name,
    });
    return PunchRecord.fromMap(record.isEmpty ? {
      'type': type, 'at': DateTime.now().toIso8601String(),
      'latitude': position.latitude, 'longitude': position.longitude,
      'distance_meters': distance, 'note': note.trim(),
    } : record);
  }
}
