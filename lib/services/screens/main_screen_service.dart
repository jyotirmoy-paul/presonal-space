import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/model/progress_model.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/model/selected_remote_file_model.dart';
import 'package:personal_space/screens/main/main_screen.dart';
import 'package:personal_space/services/backend/backend_service.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';
import 'package:personal_space/utils/constants.dart';

import 'package:provider/provider.dart';

class MainScreenService {
  MainScreenService._();

  static void _setMainScreenFileTypeToBinFiles(BuildContext context) =>
      Provider.of<ValueNotifier<MainScreenFileType>>(
        context,
        listen: false,
      ).value = MainScreenFileType.BIN_FILES;

  static Future<void> onMenuChoiceTap(
    String choice,
    BuildContext context,
  ) async {
    switch (choice) {
      case kSettings:
        break;

      case kBin:
        return _setMainScreenFileTypeToBinFiles(
          context,
        );

      case kLogout:
        return FirebaseAuth.instance.signOut();
    }
  }

  static void deleteRemoteFilesToBin(
    List<RemoteFileModel> files,
    SelectedRemoteFileModel selectedRemoteFileModel,
  ) async {
    await BackendService.deleteMultipleToBin(files,
        onPercentageDone: (double done) {
      print('% permanent deleted: $done');
    });

    selectedRemoteFileModel.clearAllSelections();
  }

  static void onUploadButtonPress(
    BuildContext context,
  ) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    /* TODO: ONLY ALLOW FILES UPTO 50 MiB IN SIZE */

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

    final ProgressModel progressModel = Provider.of<ProgressModel>(
      context,
      listen: false,
    );

    progressModel.files = files;
    progressModel.progressStatus = ProgressStatus.ENCRYPTING;

    /* TODO: HANDLE ERROR CASES */

    /* apply encryption */
    await EncryptionService.applyEncryption(
      files,
      onPercentageDone: (double done) {
        progressModel.percentageDone = done;
      },
    );

    /* finally start uploading, thus reset the percentageDone */
    progressModel.progressStatus = ProgressStatus.UPLOADING;
    progressModel.percentageDone = 0;

    await BackendService.upload(
      files,
      onPercentageDone: (double done) {
        progressModel.percentageDone = done;
      },
    );

    /* done */
    progressModel.progressStatus = ProgressStatus.DONE;

    /* finally hide the progress widget after a certain period */
    await Future.delayed(kWaitDuration);
    progressModel.progressStatus = ProgressStatus.NONE;
  }

  static void onSearchTextChange(BuildContext context, String text) =>
      Provider.of<ValueNotifier<String>>(
        context,
        listen: false,
      ).value = text;

  static void onProfileButtonPress() {}
}
