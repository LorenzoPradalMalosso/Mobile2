import 'package:geolocator/geolocator.dart';

import '../database/database_helper.dart';
import '../models/punch_record.dart';
import '../models/workplace.dart';
import '../services/location_service.dart';

class PontoController {
  PontoController({DatabaseHelper? database, LocationService? location})
    : _database = database ?? DatabaseHelper.instance,
      _location = location ?? LocationService();
  final DatabaseHelper _database;
  final LocationService _location;

  Future<Position> currentPosition() => _location.currentPosition();

  Future<List<PunchRecord>> list(String accountId) => _database.list(accountId);

  Future<PunchRecord> register(
    String accountId, {
    String note = '',
    String photoPath = '',
  }) async {
    final position = await _location.currentPosition();
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      workplace.latitude,
      workplace.longitude,
    );
    if (distance > radiusMeters) {
      throw Exception(
        'Você está a ${distance.round()} m do local. O limite permitido é ${radiusMeters.round()} m.',
      );
    }
    final records = await list(accountId);
    final type = records.isNotEmpty && records.first.type == 'Entrada'
        ? 'Saída'
        : 'Entrada';
    final record = PunchRecord(
      type: type,
      at: DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      distance: distance,
      note: note.trim(),
      photoPath: photoPath,
      accountId: accountId,
    );
    await _database.insert(record);
    return record;
  }
}
