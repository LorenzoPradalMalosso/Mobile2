// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';

import '../database/database_helper.dart';
import '../models/registro_model.dart';
import '../services/location_api_service.dart';
import '../services/location_service.dart';

class RegistroController {
  RegistroController({
    DatabaseHelper? databaseHelper,
    LocationService? locationService,
  })  : _databaseHelper = databaseHelper ?? DatabaseHelper(),
        _locationService = locationService ?? LocationService();

  final DatabaseHelper _databaseHelper;
  final LocationService _locationService;

  Future<bool> criarRegistro(
    String observacao, {
    required String caminhoFoto,
    double? latitude,
    double? longitude,
  }) async {
    try {
      if (observacao.trim().isEmpty || caminhoFoto.trim().isEmpty) {
        return false;
      }

      double latitudeFinal = latitude ?? 0;
      double longitudeFinal = longitude ?? 0;

      if (latitude == null || longitude == null) {
        final Position? position = await _locationService.obterLocalizacao();

        if (position == null) {
          return false;
        }

        latitudeFinal = position.latitude;
        longitudeFinal = position.longitude;
      }

      final String cidade = await LocationApiService.buscarNomeCidade(
        latitudeFinal,
        longitudeFinal,
      );

      final Registro registro = Registro(
        dataHora: DateTime.now().toIso8601String(),
        latitude: latitudeFinal,
        longitude: longitudeFinal,
        observacao: observacao,
        caminhoFoto: caminhoFoto,
        cidade: cidade,
      );

      await _databaseHelper.create(registro);

      return true;
    } catch (e) {
      print('Erro ao criar registro: $e');
      return false;
    }
  }

  Future<List<Registro>> listarRegistros() async {
    try {
      return await _databaseHelper.read();
    } catch (e) {
      print('Erro ao listar registros: $e');
      return [];
    }
  }
}