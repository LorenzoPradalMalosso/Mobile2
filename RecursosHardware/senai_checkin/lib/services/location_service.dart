import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'permission_service.dart';

class LocationService {
  final PermissionService _permissionService = PermissionService();

  Future<Position?> obterLocalizacao() async {
    // Verifica se a permissão já foi concedida
    bool permitido = await _permissionService.localizacaoPermitida();

    // Caso não tenha sido concedida, solicita
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
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      return null;
    }
  }
  
}
