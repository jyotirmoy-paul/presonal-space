import 'dart:convert';

import 'package:encrypt/encrypt.dart' as enc;

import 'package:flutter/foundation.dart';
import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/services/database/database.dart';

const _FILES = 'FILES';
const _MASTER_PASSWORD = 'MASTER_PASSWORD';

/* _encrypt as a top-level function so that it works with compute */
List<LocalFileModel> _encrypt(
  Map<String, dynamic> data,
) {
  List<LocalFileModel> files = jsonDecode(data[_FILES])
      .map<LocalFileModel>(
        (f) => LocalFileModel.fromJson(f),
      )
      .toList();
  String masterPassword = data[_MASTER_PASSWORD];

  assert(files != null);
  assert(masterPassword != null);

  final key = enc.Key.fromUtf8(masterPassword);
  final encrypter = enc.Encrypter(enc.AES(key));

  List<LocalFileModel> encryptedFiles = <LocalFileModel>[];

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
        encrypterIV: ivString,
        encryptedBase64Data: encrypted.base64,
      ),
    );
  }

  return encryptedFiles;
}

class EncryptionService {
  EncryptionService._();

  static Future<List<LocalFileModel>> encrypt(
    List<LocalFileModel> files,
  ) async {
    String masterPassword = await DatabaseService.getMasterPassword();

    print('started');

    // String _files = jsonEncode(files);

    // print('jsonEncoding done');

    await compute(
      tryy,
      true,
    );

    return [];
  }
}
