import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:personal_space/model/local_file_model.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/database/cache_service.dart';
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
    String base64String,
    String key,
  ) async {
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
  static Future<int> _upload(
    LocalFileModel localFile,
    WriteBatch writeBatch,
  ) async {
    /* first upload then file content */
    Map<String, dynamic> uploadedInfo = await _uploadToStorage(
      localFile.encryptedData,
      localFile.encrypterIV,
    );

    print('Uploaded File Info: $uploadedInfo');

    String fileUrl = uploadedInfo[FILE_URL];
    int totalBytes = uploadedInfo[FILE_SIZE];

    /* create remote file model */
    final remoteFile = RemoteFileModel(
      encryptedFileName: await EncryptionService.getEncryptedString(
        localFile.fileName,
        localFile.encrypterIV,
      ),
      fileExtension: localFile.fileExtension,
      fileUrl: fileUrl,
      firestoreRef: localFile.encrypterIV,
      fileSize: totalBytes,
      uploadedOn: DateTime.fromMicrosecondsSinceEpoch(
        int.parse(localFile.encrypterIV),
      ),
    );

    /* put the file to be written to firestore, when committed */
    writeBatch.set(
      _getCollectionReference().doc(localFile.encrypterIV),
      remoteFile.toJson,
    );

    return totalBytes;
  }

  static Future<String> download(String url) async {
    if (await CacheService.exists(url)) return CacheService.get(url);

    try {
      Uint8List downloadedData = await FirebaseStorage.instance
          .refFromURL(url)
          .getData(kFirebaseDownloadMaxSize);
      return CacheService.put(
        url,
        String.fromCharCodes(downloadedData),
      );
    } catch (e) {
      log('backend_service : download : $e');
      return null;
    }
  }

  /* TODO: AT A LATER POINT, INTRODUCE THE CONCEPT OF BIN -
      FOR KEEPING THE DELETED FILES, UNLESS THEY ARE PERMANENTLY REMOVED */

  /* this method deletes multiple remote files to BIN */
  static Future<void> deleteMultipleToBin(
    List<RemoteFileModel> remoteFiles, {
    void onPercentageDone(double done),
  }) async {
    /* batch update all of the files to have the property "inBin" to be true */
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();

    int totalCount = remoteFiles.length;
    int currentCount = 0;

    for (RemoteFileModel remoteFileModel in remoteFiles) {
      remoteFileModel.inBin = true;
      writeBatch.update(
        _getCollectionReference().doc(remoteFileModel.firestoreRef),
        remoteFileModel.toJson,
      );

      onPercentageDone?.call(currentCount / totalCount);

      currentCount += 1;
    }

    return writeBatch.commit();
  }

  /* this method deletes multiple remote files permanently */
  /* todo: this method can only be invoked from the bin_view */
  static Future<void> deleteMultiplePermanent(
    List<RemoteFileModel> remoteFiles, {
    void onPercentageDone(double done),
  }) async {
    int totalCount = remoteFiles.length;
    int currentCount = 0;

    int totalBytesDeleted = 0;

    WriteBatch writeBatch = FirebaseFirestore.instance.batch();

    for (RemoteFileModel remoteFileModel in remoteFiles) {
      /* delete the storage file */
      await FirebaseStorage.instance
          .refFromURL(remoteFileModel.fileUrl)
          .delete();

      totalBytesDeleted += remoteFileModel.fileSize;

      /* collect for deletion */
      writeBatch.delete(
        _getCollectionReference().doc(remoteFileModel.firestoreRef),
      );

      onPercentageDone?.call(currentCount / totalCount);

      currentCount += 1;
    }

    /* finally delete the collection reference */
    await writeBatch.commit();

    /* finally update the total storage used under that user's ID */
    return _getDocumentReference().set(
      {
        kTotalBytesUsage: FieldValue.increment(
          -totalBytesDeleted,
        ),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  static Future<void> upload(
    List<LocalFileModel> localFiles, {
    void onPercentageDone(double done),
  }) async {
    int totalCount = localFiles.length;
    int currentCount = 0;

    int totalBytesStored = 0;

    WriteBatch writeBatch = FirebaseFirestore.instance.batch();

    for (LocalFileModel localFile in localFiles) {
      totalBytesStored += await _upload(localFile, writeBatch);
      onPercentageDone?.call(currentCount.toDouble() * 100 / totalCount);
      currentCount += 1;
    }

    /* finally commit the changes to firestore -
    actual uploading to Firestore is done here */
    await writeBatch.commit();

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
