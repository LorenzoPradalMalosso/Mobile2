import 'package:geolocator/geolocator.dart';

class PermissionService {
  Future<void> ensureLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Ative o serviço de localização do aparelho.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permita o acesso à localização nas definições do aparelho.',
      );
    }
  }
}
