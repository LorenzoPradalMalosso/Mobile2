import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> solicitarPermissoesIniciais() async {
    if (!await cameraPermitida()) {
      await solicitarCamera();
    }

    if (!await localizacaoPermitida()) {
      await solicitarLocalizacao();
    }
  }

  // Solicita permissão da câmera
  Future<bool> solicitarCamera() async {
    final PermissionStatus status = await Permission.camera.request();
    return status.isGranted || status.isLimited;
  }

  // Solicita permissão da localização
  Future<bool> solicitarLocalizacao() async {
    final PermissionStatus status = await Permission.locationWhenInUse.request();
    return status.isGranted || status.isLimited;
  }

  // Verifica se a câmera já possui permissão
  Future<bool> cameraPermitida() async {
    return await Permission.camera.isGranted;
  }

  // Verifica se a localização já possui permissão
  Future<bool> localizacaoPermitida() async {
    return await Permission.locationWhenInUse.isGranted;
  }
  
}
