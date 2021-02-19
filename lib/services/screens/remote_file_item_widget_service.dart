import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

class RemoteFileItemWidgetService {
  RemoteFileItemWidgetService._();

  /* open file */
  static void openFile(BuildContext context, RemoteFileModel remoteFileModel) {}

  /* this method decrypts the filename - hide / show file name*/
  static void toggleFileNameVisibility(
    BuildContext context,
    String fn,
    String firestoreRef,
  ) async {
    ValueNotifier<String> vnFileName = Provider.of(
      context,
      listen: false,
    );

    if (vnFileName.value != null) return vnFileName.value = null;

    String fileName = await EncryptionService.getDecryptedString(
      fn,
      firestoreRef,
    );
    vnFileName.value = fileName;
  }

  static String getAsset(String extension) {
    switch (extension.toLowerCase()) {
      case FILE:
        return kIconFile;
      case PDF:
        return kIconPdf;
      case MP3:
        return kIconMp3;
      case MP4:
        return kIconMp4;
      case PNG:
        return kIconPng;
      case JPG:
        return kIconJpg;
      case SVG:
        return kIconSvg;
      case ZIP:
        return kIconZip;
      case TXT:
        return kIconTxt;
      case CSV:
        return kIconCsv;
      case DOC:
        return kIconDoc;
      case DOCX:
        return kIconDoc;
      case PPT:
        return kIconPpt;
      case XLS:
        return XLS;
    }

    return kIconFile;
  }
}
