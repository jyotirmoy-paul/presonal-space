// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalFileModel _$LocalFileModelFromJson(Map<String, dynamic> json) {
  return LocalFileModel(
    fileName: json['fileName'] as String,
    fileExtension: json['fileExtension'] as String,
    fileSize: json['fileSize'] as int,
    fileData: (json['fileData'] as List)?.map((e) => e as int)?.toList(),
    encryptedIV: json['encryptedIV'] as String,
    encryptedBase64Data: json['encryptedBase64Data'] as String,
  );
}

Map<String, dynamic> _$LocalFileModelToJson(LocalFileModel instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'fileExtension': instance.fileExtension,
      'fileSize': instance.fileSize,
      'fileData': instance.fileData,
      'encryptedBase64Data': instance.encryptedBase64Data,
      'encryptedIV': instance.encryptedIV,
    };
