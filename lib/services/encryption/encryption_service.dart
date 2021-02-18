import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/services/database/database.dart';
import 'package:personal_space/services/encryption/core_encryption_service.dart';
import 'package:encrypt/encrypt.dart' as enc;

class EncryptionService {
  EncryptionService._();

  // todo: implement this method
  static String _getModifiedMasterPassword(String password) {
    return password;
  }

  /* this method encrypts the file name or description */
  static Future<String> getEncryptedString(
    String string,
    String ivString,
  ) async {
    String masterPassword = await DatabaseService.getMasterPassword();
    assert(masterPassword != null);

    final key = enc.Key.fromUtf8(
      _getModifiedMasterPassword(masterPassword),
    );
    final iv = enc.IV.fromUtf8(ivString);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    return encrypter.encrypt(string, iv: iv).base64;
  }

  /* this method encrypts the fileData content and store in the encryptedData,
  * and the fileData content is set to null */
  static Future<void> applyEncryption(
    List<LocalFileModel> files, {
    void onPercentageDone(double done),
  }) async {
    String masterPassword = await DatabaseService.getMasterPassword();
    assert(masterPassword != null);

    String modifiedMasterPassword = _getModifiedMasterPassword(
      masterPassword,
    );

    int totalFileCount = files.length;
    int currentFileCount = 0;

    for (LocalFileModel model in files) {
      String encrypterIV = DateTime.now().microsecondsSinceEpoch.toString();

      String encryptedData = await CoreEncryptionService.encrypt(
        model.fileData,
        modifiedMasterPassword,
        encrypterIV,

        /* notify progress */
        onPercentageDone: (double subPertDone) {
          double mainPertDone = (currentFileCount.toDouble() / totalFileCount);
          onPercentageDone?.call(100 * mainPertDone + subPertDone);
        },
      );

      model.fileData = null;
      model.encryptedData = encryptedData;
      model.encrypterIV = encrypterIV;

      currentFileCount += 1;
    }
  }
}
