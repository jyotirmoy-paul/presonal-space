import 'package:flutter/cupertino.dart';
import 'package:personal_space/model/remote_file_model.dart';

class SelectedRemoteFileModel extends ChangeNotifier {
  Map<String, RemoteFileModel> _remoteFileModelExistenceMap;

  SelectedRemoteFileModel() {
    _remoteFileModelExistenceMap = Map();
  }

  void addAllFiles(List<RemoteFileModel> files) {
    for (RemoteFileModel model in files)
      _remoteFileModelExistenceMap[model.firestoreRef] = model;

    notifyListeners();
  }

  void removeAllFiles(List<RemoteFileModel> files) {
    for (RemoteFileModel model in files)
      _remoteFileModelExistenceMap.remove(model.firestoreRef);
    notifyListeners();
  }

  void addFile(RemoteFileModel model) {
    _remoteFileModelExistenceMap[model.firestoreRef] = model;
    notifyListeners();
  }

  void removeFile(RemoteFileModel model) {
    _remoteFileModelExistenceMap.remove(model.firestoreRef);
    notifyListeners();
  }

  void clearAllSelections() {
    _remoteFileModelExistenceMap.clear();
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

  bool get isThereAnySelection => _remoteFileModelExistenceMap.length != 0;

  int get selectionCount => _remoteFileModelExistenceMap.length;

  List<RemoteFileModel> get allFiles {
    List<RemoteFileModel> remoteFileModels = [];
    _remoteFileModelExistenceMap.forEach(
      (_, model) => remoteFileModels.add(model),
    );
    return remoteFileModels;
  }
}
