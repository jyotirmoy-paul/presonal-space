import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/detail_screen_utils/doc_detail_widget_utils.dart';

import 'package:flutter/material.dart';
import 'package:personal_space/widgets/media_builder.dart';

class DocDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MediaBuilder(
        builder: (Uint8List data, RemoteFileModel remoteFileModel) {
          DocDetailWidgetUtils.openDoc(
            data,
            remoteFileModel.fileExtension,
          );
          return Center(
            child: Text(
              'Opened ${remoteFileModel.fileExtension.toUpperCase()} file in a new tab',
              style: kTextStyle30,
            ),
          );
        },
      );
}
