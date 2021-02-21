import 'package:flutter/cupertino.dart';
import 'package:personal_space/model/remote_file_model.dart';

class SelectedRemoteFileModel extends ChangeNotifier {
  List<RemoteFileModel> _remoteFileModels;
  Map<String, bool> _remoteFileModelExistenceMap;

  SelectedRemoteFileModel() {
    _remoteFileModels = [];
    _remoteFileModelExistenceMap = Map();
  }

  void addAllFiles(List<RemoteFileModel> files) {
    for (RemoteFileModel model in files) {
      _remoteFileModels.add(model);
      _remoteFileModelExistenceMap[model.firestoreRef] = true;
    }
    notifyListeners();
  }

  void removeAllFiles(List<RemoteFileModel> files) {
    for (RemoteFileModel model in files) {
      _remoteFileModels.remove(model);
      _remoteFileModelExistenceMap.remove(model.firestoreRef);
    }
    notifyListeners();
  }

  void addFile(RemoteFileModel model) {
    _remoteFileModels.add(model);
    _remoteFileModelExistenceMap[model.firestoreRef] = true;
    notifyListeners();
  }

  void removeFile(RemoteFileModel model) {
    _remoteFileModels.remove(model);
    _remoteFileModelExistenceMap.remove(model.firestoreRef);
    notifyListeners();
  }

  bool isFileSelected(RemoteFileModel model) =>
      _remoteFileModelExistenceMap.containsKey(model.firestoreRef);

  bool areAllFilesSelected(List<RemoteFileModel> files) {
    for (RemoteFileModel model in files) {
      bool exists = _remoteFileModelExistenceMap.containsKey(
        model.firestoreRef,
      );
      if (!exists) return false;
    }
    return true;
  }

  List<RemoteFileModel> get remoteFileModel => _remoteFileModels;
}
