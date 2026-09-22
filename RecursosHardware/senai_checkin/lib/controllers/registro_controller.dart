// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';

import '../database/database_helper.dart';
import '../models/registro_model.dart';
import '../services/camera_service.dart';
import '../services/location_service.dart';

class RegistroController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final CameraService _cameraService = CameraService();
  final LocationService _locationService = LocationService();

  // Cria um novo registro
  Future<bool> criarRegistro(String observacao) async {
    try {
      // Obtém a localização
      Position? position = await _locationService.obterLocalizacao();

      if (position == null) {
        return false;
      }

      // Tira a foto
      String? caminhoFoto = await _cameraService.tirarFoto();

      if (caminhoFoto == null) {
        return false;
      }

      // Cria o objeto Registro
      Registro registro = Registro(
        dataHora: DateTime.now().toIso8601String(),
        latitude: position.latitude,
        longitude: position.longitude,
        observacao: observacao,
        caminhoFoto: caminhoFoto,
      );

      // Salva no banco
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