import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/detail_screen_utils/video_detail_widget_utils.dart';
import 'package:personal_space/widgets/media_builder.dart';

class VideoDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MediaBuilder(
        builder: (Uint8List data, RemoteFileModel file) {
          VideoDetailWidgetUtils.playVideo(
            data,
            file.fileExtension,
          );
          return Center(
            child: Text(
              'Video is played on a different screen',
              style: kTextStyle30,
            ),
          );
        },
      );
}
