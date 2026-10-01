import 'package:geolocator/geolocator.dart';

import 'permission_service.dart';

class LocationService {
  LocationService({PermissionService? permissionService})
    : _permissionService = permissionService ?? PermissionService();
  final PermissionService _permissionService;
  Future<Position> currentPosition() async {
    await _permissionService.ensureLocation();
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }
}
