import 'package:geolocator/geolocator.dart';

import 'permission_service.dart';

class LocationService {
  final PermissionService _permissionService = PermissionService();

  Future<Position?> obterLocalizacao() async {
    // Verifica se a permissão já foi concedida
    bool permitido = await _permissionService.localizacaoPermitida();

    // Caso não tenha sido concedida, solicita
    if (!permitido) {
      permitido = await _permissionService.solicitarLocalizacao();
    }

    // Se o usuário negar a permissão
    if (!permitido) {
      return null;
    }

    // Verifica se o serviço de localização está ativado
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      return null;
    }

    // Obtém a localização atual
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return position;
  }
  
}