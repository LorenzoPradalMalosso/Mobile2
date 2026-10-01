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

  factory PunchRecord.fromMap(Map<String, Object?> map) => PunchRecord(
    id: map['id'] as int?,
    accountId: map['account_id'] as String? ?? '',
    type: map['type'] as String,
    at: DateTime.parse(map['at'] as String),
    latitude: (map['latitude'] as num).toDouble(),
    longitude: (map['longitude'] as num).toDouble(),
    distance: (map['distance_meters'] as num).toDouble(),
    note: map['note'] as String? ?? '',
    photoPath: map['photo_path'] as String? ?? '',
  );
}
