import 'package:image_picker/image_picker.dart';

import 'permission_service.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();

  Future<String?> tirarFoto() async {
    // Verifica se a permissão já foi concedida
    bool permitido = await _permissionService.cameraPermitida();

    // Caso não tenha sido concedida, solicita
    if (!permitido) {
      permitido = await _permissionService.solicitarCamera();
    }

    // Se o usuário negar a permissão
    if (!permitido) {
      return null;
    }

    // Abre a câmera
    XFile? imagem = await _picker.pickImage(
      source: ImageSource.camera,
    );

    // Usuário cancelou a câmera
    if (imagem == null) {
      return null;
    }

    // Retorna o caminho da imagem
    return imagem.path;
  }
  
}