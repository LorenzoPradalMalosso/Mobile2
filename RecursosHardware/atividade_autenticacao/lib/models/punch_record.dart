class PunchRecord {
  const PunchRecord({
    this.id,
    required this.type,
    required this.at,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.note = '',
    this.photoPath = '',
    this.accountId = '',
  });
  final int? id;
  final String type;
  final DateTime at;
  final double latitude, longitude, distance;
  final String note, photoPath, accountId;

  Map<String, Object?> toMap() => {
    'id': id,
    'account_id': accountId,
    'type': type,
    'at': at.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'distance_meters': distance,
    'note': note,
    'photo_path': photoPath,
  };

  factory PunchRecord.fromMap(Map<String, Object?> map) {
    final rawAt = map['at'] ?? map['timestamp'] ?? map['created_at'];
    return PunchRecord(
      id: int.tryParse('${map['id']}'),
      accountId: '${map['account_id'] ?? map['user_id'] ?? ''}',
      type: '${map['type'] ?? 'Entrada'}',
      at: DateTime.parse('$rawAt').toLocal(),
      latitude: ((map['latitude'] ?? map['lat']) as num).toDouble(),
      longitude: ((map['longitude'] ?? map['lng'] ?? map['lon']) as num).toDouble(),
      distance: ((map['distance_meters'] ?? map['distance'] ?? 0) as num).toDouble(),
      note: '${map['note'] ?? ''}',
      photoPath: '${map['photo_path'] ?? ''}',
    );
  }
}
