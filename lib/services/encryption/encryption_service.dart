import 'package:encrypt/encrypt.dart' as enc;

import 'package:flutter/foundation.dart';
import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/services/database/database.dart';

class EncryptionService {
  EncryptionService._();

  static Future<List<LocalFileModel>> encrypt(
          List<LocalFileModel> localFileModels) =>
      compute(
        (List<Map<String, dynamic>> jsonFiles) {
          List<LocalFileModel> files =
              jsonFiles.map((m) => LocalFileModel.fromJson(m)).toList();

          List<LocalFileModel> encryptedFiles = <LocalFileModel>[];

          String masterPassword = 'my 32 length key................';
          final key = enc.Key.fromUtf8(masterPassword);
          final encrypter = enc.Encrypter(enc.AES(key));

          for (LocalFileModel model in files) {
            String ivString = DateTime.now().microsecondsSinceEpoch.toString();
            final iv = enc.IV.fromUtf8(ivString);

            final encrypted = encrypter.encryptBytes(
              model.fileData,
              iv: iv,
            );

            encryptedFiles.add(
              LocalFileModel(
                fileName: model.fileName,
                fileExtension: model.fileExtension,
                fileSize: model.fileSize,
                fileData: null,
                encryptedIV: ivString,
                encryptedBase64Data: encrypted.base64,
              ),
            );
          }

          return encryptedFiles;
        },
        localFileModels.map((f) => f.toJson()).toList(),
      );
}
