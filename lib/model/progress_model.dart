import 'package:flutter/material.dart';
import 'package:personal_space/model/local_file_model.dart';

enum ProgressStatus {
  NONE,
  ERROR,
  DONE,
  UPLOADING,
  ENCRYPTING,
}

class ProgressModel extends ChangeNotifier {
  List<LocalFileModel> _files;
  double _percentageDone;
  ProgressStatus _progressStatus;

  // fixme: remove the percentageDone from construction - used only for debugging purpose
  ProgressModel({double percentageDone}) {
    _progressStatus = ProgressStatus.NONE;
    _percentageDone = percentageDone;
  }

  List<LocalFileModel> get files => _files;

  double get percentageDone => _percentageDone;

  ProgressStatus get progressStatus => _progressStatus;

  set progressStatus(ProgressStatus status) {
    if (_progressStatus == status) return;

    _progressStatus = status;
    notifyListeners();
  }

  set percentageDone(double done) {
    if (_percentageDone == done) return;

    _percentageDone = done;
    notifyListeners();
  }

  set files(List<LocalFileModel> files) {
    _files = files;
    notifyListeners();
  }
}
