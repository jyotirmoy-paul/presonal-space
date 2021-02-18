import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';

class MainScreenService {
  MainScreenService._();

  static void onUploadButtonPress() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    List<LocalFileModel> files = result.files
        .map<LocalFileModel>(
          (f) => LocalFileModel(
            fileName: f.name,
            fileExtension: f.extension,
            fileSize: f.size,
            fileData: f.bytes,
          ),
        )
        .toList();

    print('encryption STARTED');

    /* apply encryption */
    await EncryptionService.applyEncryption(files);

    print('encryption DONE');
  }

  static void onSearchTextChange(BuildContext context, String text) {}

  static void onProfileButtonPress() {}
}
