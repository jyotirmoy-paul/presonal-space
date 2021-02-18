import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/services/database/database.dart';
import 'package:personal_space/services/encryption/core_encryption_service.dart';

class EncryptionService {
  EncryptionService._();

  // todo: implement this method
  static String _getModifiedMasterPassword(String password) {
    return password;
  }

  /* todo: add a callback to report progress: % left */
  /* this method encrypts the fileData content and store in the encryptedData,
  * and the fileData content is set to null */
  static Future<void> applyEncryption(
    List<LocalFileModel> files,
  ) async {
    String masterPassword = await DatabaseService.getMasterPassword();
    assert(masterPassword != null);

    String modifiedMasterPassword = _getModifiedMasterPassword(
      masterPassword,
    );

    for (LocalFileModel model in files) {
      String encrypterIV = DateTime.now().microsecondsSinceEpoch.toString();

      String encryptedData = await CoreEncryptionService.encrypt(
        model.fileData,
        modifiedMasterPassword,
        encrypterIV,
      );

      model.fileData = null;
      model.encryptedData = encryptedData;
      model.encrypterIV = encrypterIV;
    }
  }
}
