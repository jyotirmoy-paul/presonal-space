import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';
import 'package:personal_space/utils/constants.dart';

class BackendService {
  BackendService._();

  static DocumentReference _getDocumentReference() => FirebaseFirestore.instance
      .collection(kUsersCollection)
      .doc(FirebaseAuth.instance.currentUser.uid);

  static CollectionReference _getCollectionReference() =>
      FirebaseFirestore.instance
          .collection(kUsersCollection)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection(kFilesCollection);

  static const FILE_URL = 'FILE_URL';
  static const FILE_SIZE = 'FILE_SIZE';

  static Future<Map<String, dynamic>> _uploadToStorage(
      String base64String, String key) async {
    UploadTask task = FirebaseStorage.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(key)
        .putString(base64String);

    String url;
    int totalBytes;

    await task.whenComplete(() async {
      url = await task.snapshot.ref.getDownloadURL();
      totalBytes = task.snapshot.totalBytes;
    });

    return {
      FILE_URL: url,
      FILE_SIZE: totalBytes,
    };
  }

  /* this method returns back the totalBytes stored in the cloud storage */
  static Future<int> _upload(LocalFileModel localFile) async {
    /* first upload then file content */
    Map<String, dynamic> uploadedInfo =
        await _uploadToStorage(localFile.encryptedData, localFile.encrypterIV);

    print('Uploaded File Info: $uploadedInfo');

    String fileUrl = uploadedInfo[FILE_URL];
    int totalBytes = uploadedInfo[FILE_SIZE];

    /* create remote file model */
    final remoteFile = RemoteFileModel(
      fileName: await EncryptionService.getEncryptedString(
        localFile.fileName,
        localFile.encrypterIV,
      ),
      fileExtension: localFile.fileExtension,
      fileStorageRef: fileUrl,
      firestoreRef: localFile.encrypterIV,
      fileSize: totalBytes,
      uploadedOn: DateTime.fromMicrosecondsSinceEpoch(
        int.parse(localFile.encrypterIV),
      ),
    );

    /* finally put the remote file model */
    await _getCollectionReference().doc(localFile.encrypterIV).set(
          remoteFile.toJson,
        );

    return totalBytes;
  }

  static Future<void> upload(
    List<LocalFileModel> localFiles, {
    void onPercentageDone(double done),
  }) async {
    int totalCount = localFiles.length;
    int currentCount = 0;

    int totalBytesStored = 0;

    for (LocalFileModel localFile in localFiles) {
      totalBytesStored += await _upload(localFile);
      onPercentageDone?.call(currentCount.toDouble() * 100 / totalCount);
      currentCount += 1;
    }

    /* finally update the total storage used under that user's ID */
    return _getDocumentReference().set(
      {
        kTotalBytesUsage: FieldValue.increment(totalBytesStored),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  static Stream<List<RemoteFileModel>> get() => _getCollectionReference()
      .orderBy(kFirestoreRef, descending: true)
      .snapshots()
      .map<List<RemoteFileModel>>(
        (querySnapshots) => querySnapshots.docs
            .map<RemoteFileModel>(
              (queryDocumentSnapshot) => RemoteFileModel.fromJson(
                queryDocumentSnapshot.data(),
              ),
            )
            .toList(),
      );
}
