import 'package:json_annotation/json_annotation.dart';

part 'remote_file_model.g.dart';

@JsonSerializable(explicitToJson: true, nullable: true)
class RemoteFileModel {
  String fileName;
  String fileExtension;
  String fileStorageRef;
  String firestoreRef;
  int fileSize;
  DateTime uploadedOn;

  RemoteFileModel({
    this.fileName,
    this.fileExtension,
    this.fileStorageRef,
    this.firestoreRef,
    this.fileSize,
    this.uploadedOn,
  });

  factory RemoteFileModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteFileModelFromJson(json);

  Map<String, dynamic> get toJson => _$RemoteFileModelToJson(this);
}
