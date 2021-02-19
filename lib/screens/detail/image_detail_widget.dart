import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/detail_screen_utils/image_detail_widget_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ImageDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
        future: ImageDetailWidgetUtils.getMedia(
          Provider.of<RemoteFileModel>(
            context,
            listen: false,
          ),
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (!snapshot.hasData)
            return Center(
              child: Text(
                'CORRUPTED FILE',
                style: kErrorTextStyle,
              ),
            );

          return PhotoView(
            imageProvider: MemoryImage(snapshot.data),
          );
        },
      );
}
