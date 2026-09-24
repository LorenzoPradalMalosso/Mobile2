import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'permission_service.dart';

class LocationService {
  LocationService({PermissionService? permissionService})
      : _permissionService = permissionService ?? PermissionService();

  final PermissionService _permissionService;

  Future<Position?> obterLocalizacao() async {
    final permitido = await _permissionService.localizacaoPermitida()
        ? true
        : await _permissionService.solicitarLocalizacao();

    if (!permitido) {
      return null;
    }

    final bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      return null;
    }

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
