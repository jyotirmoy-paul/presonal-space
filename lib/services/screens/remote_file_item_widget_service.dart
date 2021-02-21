import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/model/selected_remote_file_model.dart';
import 'package:personal_space/screens/detail/detail_screen.dart';
import 'package:personal_space/services/database/database_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class RemoteFileItemWidgetService {
  RemoteFileItemWidgetService._();

  static Dialog _buildDialog(BuildContext context) => Dialog(
        elevation: 10.0,
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.50,
          padding: EdgeInsets.all(20.0),
          child: ListenableProvider<ValueNotifier<String>>(
            // todo: remove password from here
            create: (_) =>
                ValueNotifier<String>('my 32 length key................'),
            builder: (context, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /* master password input */
                TextField(
                  obscureText: true,
                  onChanged: (String s) => Provider.of<ValueNotifier<String>>(
                    context,
                    listen: false,
                  ).value = s,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Master Password',
                  ),
                ),

                /* divider */
                const SizedBox(
                  height: 10.0,
                ),

                /* confirm button */
                CustomTextButton(
                  onPressed: () async {
                    String masterPasswordOriginal =
                        await DatabaseService.getMasterPassword();
                    String inputMasterPassword =
                        Provider.of<ValueNotifier<String>>(context,
                                listen: false)
                            .value;

                    Navigator.pop(
                      context,
                      masterPasswordOriginal == inputMasterPassword,
                    );
                  },
                  text: 'Confirm',
                ),
              ],
            ),
          ),
        ),
      );

  /* select file */
  static void selectOrDeselectFile(
    BuildContext context,
    RemoteFileModel model,
  ) {
    SelectedRemoteFileModel selectedRemoteFileModel =
        Provider.of<SelectedRemoteFileModel>(
      context,
      listen: false,
    );

    if (selectedRemoteFileModel.isFileSelected(model))
      selectedRemoteFileModel.removeFile(model);
    else
      selectedRemoteFileModel.addFile(model);
  }

  /* open file */
  static void openFile(
    BuildContext context,
    RemoteFileModel remoteFileModel,
  ) async {
    /* verify the user's authenticity */
    bool status = await showDialog<bool>(
      context: context,
      builder: _buildDialog,
    );

    /* incorrect master password - message */
    if (status == null || status == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect master password',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          remoteFileModel: remoteFileModel,
        ),
      ),
    );
  }

  static String getAsset(String extension) {
    switch (extension.toLowerCase()) {
      case FILE:
        return kIconFile;
      case PDF:
        return kIconPdf;
      case MP3:
        return kIconMp3;
      // todo: add ogg icon
      case OGG:
        return kIconMp3;
      case MP4:
        return kIconMp4;
      case PNG:
        return kIconPng;
      case JPG:
        return kIconJpg;
      case SVG:
        return kIconSvg;
      case ZIP:
        return kIconZip;
      case RAR:
        return kIconCompressed;
      case TXT:
        return kIconTxt;
      case CSV:
        return kIconCsv;
      case DOC:
        return kIconDoc;
      case DOCX:
        return kIconDoc;
      case PPT:
        return kIconPpt;
      case XLS:
        return kIconXls;
    }

    return kIconFile;
  }
}
