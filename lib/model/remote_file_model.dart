import 'package:json_annotation/json_annotation.dart';

part 'remote_file_model.g.dart';

@JsonSerializable(explicitToJson: true, nullable: true)
class RemoteFileModel {
  @JsonKey(ignore: true)
  String decryptedFileName;

  String encryptedFileName;
  String fileExtension;
  String fileUrl;
  String firestoreRef;
  int fileSize;
  bool inBin;
  DateTime uploadedOn;

  RemoteFileModel({
    this.encryptedFileName,
    this.fileExtension,
    this.fileUrl,
    this.firestoreRef,
    this.fileSize,
    this.inBin = false,
    this.uploadedOn,
  });

  factory RemoteFileModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteFileModelFromJson(json);

  Map<String, dynamic> get toJson => _$RemoteFileModelToJson(this);
}
