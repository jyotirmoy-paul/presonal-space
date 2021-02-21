import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/screens/detail/audio_detail_widget.dart';
import 'package:personal_space/screens/detail/image_detail_widget.dart';
import 'package:personal_space/screens/detail/doc_detail_widget.dart';
import 'package:personal_space/screens/detail/text_detail_widget.dart';
import 'package:personal_space/screens/detail/unsupported_detail_widget.dart';
import 'package:personal_space/screens/detail/video_detail_widget.dart';
import 'package:personal_space/services/backend/backend_service.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/widgets/auto_hide_widget.dart';
import 'package:provider/provider.dart';

enum DetailScreenType {
  IMAGE,
  TEXT,
  VIDEO,
  AUDIO,
  DOC,
  NONE,
}

class DetailScreenUtils {
  DetailScreenUtils._();

  static DetailScreenType _getScreenType(String extension) {
    switch (extension.toLowerCase()) {
      case 'txt':
        return DetailScreenType.TEXT;

      case 'pdf':
        return DetailScreenType.DOC;
      case 'doc':
        return DetailScreenType.DOC;
      case 'docx':
        return DetailScreenType.DOC;
      case 'xls':
        return DetailScreenType.DOC;

      case 'mp4':
        return DetailScreenType.VIDEO;

      case 'mp3':
        return DetailScreenType.AUDIO;
      case 'ogg':
        return DetailScreenType.AUDIO;

      case 'png':
        return DetailScreenType.IMAGE;
      case 'jpg':
        return DetailScreenType.IMAGE;
      case 'jpeg':
        return DetailScreenType.IMAGE;
      case 'svg':
        return DetailScreenType.IMAGE;
    }

    return DetailScreenType.NONE;
  }

  static Widget buildBody(String extension) {
    switch (_getScreenType(extension)) {
      case DetailScreenType.TEXT:
        return TextDetailWidget();

      case DetailScreenType.IMAGE:
        return ImageDetailWidget();

      case DetailScreenType.VIDEO:
        return VideoDetailWidget();

      case DetailScreenType.AUDIO:
        return AudioDetailWidget();

      case DetailScreenType.DOC:
        return DocDetailWidget();

      case DetailScreenType.NONE:
        return UnsupportedDetailWidget();
    }

    return UnsupportedDetailWidget();
  }

  static Widget _buildIconButton(
    IconData iconData,
    Function onPressed,
  ) =>
      IconButton(
        icon: Icon(
          iconData,
          color: Colors.white,
        ),
        onPressed: onPressed,
      );

  static void _delete() {}

  static void _showInfo() {}

  static void _showMenu() {}

  /* auto hide and appear appbar */
  static Widget buildAppBar() => Align(
        alignment: Alignment.topCenter,
        child: AutoHideWidget(
          child: Builder(
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(0.90),
                    Colors.black.withOpacity(0.50),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  /* back button */
                  _buildIconButton(
                    Icons.arrow_back_rounded,
                    () => Navigator.pop(context),
                  ),
                  Spacer(),

                  /* delete button */
                  _buildIconButton(
                    Icons.delete_outline_rounded,
                    () => _delete(),
                  ),

                  /* sep */
                  kDividerHor20,

                  /* info button */
                  _buildIconButton(
                    Icons.info_outline_rounded,
                    () => _showInfo(),
                  ),

                  /* sep */
                  kDividerHor20,

                  /* more options button */
                  _buildIconButton(
                    Icons.menu_rounded,
                    () => _showMenu(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  static Future<Uint8List> getMedia(RemoteFileModel model) async {
    String encryptedData = await BackendService.download(
      model.fileUrl,
    );

    return EncryptionService.getDecryptedMedia(
      encryptedData,
      model.firestoreRef,
    );
  }
}
