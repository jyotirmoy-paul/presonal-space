// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteFileModel _$RemoteFileModelFromJson(Map<String, dynamic> json) {
  return RemoteFileModel(
    fileName: json['fileName'] as String,
    fileExtension: json['fileExtension'] as String,
    fileStorageRef: json['fileStorageRef'] as String,
    firestoreRef: json['firestoreRef'] as String,
    fileSize: json['fileSize'] as int,
    uploadedOn: json['uploadedOn'] == null
        ? null
        : DateTime.parse(json['uploadedOn'] as String),
  );
}

Map<String, dynamic> _$RemoteFileModelToJson(RemoteFileModel instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'fileExtension': instance.fileExtension,
      'fileStorageRef': instance.fileStorageRef,
      'firestoreRef': instance.firestoreRef,
      'fileSize': instance.fileSize,
      'uploadedOn': instance.uploadedOn?.toIso8601String(),
    };
