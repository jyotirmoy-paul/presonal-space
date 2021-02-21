// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteFileModel _$RemoteFileModelFromJson(Map<String, dynamic> json) {
  return RemoteFileModel(
    encryptedFileName: json['encryptedFileName'] as String,
    fileExtension: json['fileExtension'] as String,
    fileUrl: json['fileUrl'] as String,
    firestoreRef: json['firestoreRef'] as String,
    fileSize: json['fileSize'] as int,
    inBin: json['inBin'] as bool,
    uploadedOn: json['uploadedOn'] == null
        ? null
        : DateTime.parse(json['uploadedOn'] as String),
  );
}

Map<String, dynamic> _$RemoteFileModelToJson(RemoteFileModel instance) =>
    <String, dynamic>{
      'encryptedFileName': instance.encryptedFileName,
      'fileExtension': instance.fileExtension,
      'fileUrl': instance.fileUrl,
      'firestoreRef': instance.firestoreRef,
      'fileSize': instance.fileSize,
      'inBin': instance.inBin,
      'uploadedOn': instance.uploadedOn?.toIso8601String(),
    };
