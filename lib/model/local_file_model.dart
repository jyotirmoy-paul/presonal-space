import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class LocalFileModel {
  String fileName;
  String fileExtension;
  int fileSize;
  Uint8List fileData;

  String encryptedData;
  String encrypterIV;

  LocalFileModel({
    @required this.fileName,
    @required this.fileExtension,
    @required this.fileSize,
    @required this.fileData,
    this.encrypterIV,
    this.encryptedData,
  });
}
