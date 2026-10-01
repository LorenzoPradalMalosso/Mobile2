import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;

  Future<String?> captureAndSave() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 80,
      maxWidth: 1600,
    );
    if (image == null) return null;
    final directory = await getApplicationDocumentsDirectory();
    final target =
        '${directory.path}/punch_${DateTime.now().microsecondsSinceEpoch}.jpg';
    await File(image.path).copy(target);
    return target;
  }
}
