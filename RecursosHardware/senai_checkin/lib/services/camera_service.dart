import 'package:image_picker/image_picker.dart';

import 'permission_service.dart';

class CameraService {
  CameraService({ImagePicker? picker, PermissionService? permissionService})
      : _picker = picker ?? ImagePicker(),
        _permissionService = permissionService ?? PermissionService();

  final ImagePicker _picker;
  final PermissionService _permissionService;

  Future<String?> tirarFoto() async {
    final permitido = await _permissionService.cameraPermitida()
        ? true
        : await _permissionService.solicitarCamera();

    if (!permitido) {
      return null;
    }

    final XFile? imagem = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (imagem == null) {
      return null;
    }

    return imagem.path;
  }
}
