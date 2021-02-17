import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_file_model.g.dart';

@JsonSerializable(explicitToJson: true, nullable: true)
class LocalFileModel {
  String fileName;
  String fileExtension;
  int fileSize;
  List<int> fileData;

  String encryptedBase64Data;
  String encryptedIV;

  LocalFileModel({
    @required this.fileName,
    @required this.fileExtension,
    @required this.fileSize,
    @required this.fileData,
    this.encryptedIV,
    this.encryptedBase64Data,
  });

  factory LocalFileModel.fromJson(Map<String, dynamic> json) =>
      _$LocalFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalFileModelToJson(this);

  @override
  String toString() => this.fileName;
}
