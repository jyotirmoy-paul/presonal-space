import 'dart:developer';
import 'dart:typed_data';

import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/backend/backend_service.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';

class ImageDetailWidgetUtils {
  ImageDetailWidgetUtils._();

  static Future<Uint8List> getMedia(RemoteFileModel model) async {
    String encryptedData = await BackendService.download(
      model.fileStorageRef,
    );

    return EncryptionService.getDecryptedMedia(
      encryptedData,
      model.firestoreRef,
    );
  }
}
