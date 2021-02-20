import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/detail_screen_utils/detail_screen_utils.dart';
import 'package:provider/provider.dart';

class MediaBuilder extends StatelessWidget {
  final Widget Function(Uint8List data, RemoteFileModel remoteFileModel)
      builder;

  MediaBuilder({
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final RemoteFileModel remoteFileModel = Provider.of<RemoteFileModel>(
      context,
      listen: false,
    );
    return FutureBuilder<Uint8List>(
      future: DetailScreenUtils.getMedia(
        remoteFileModel,
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

        return builder(snapshot.data, remoteFileModel);
      },
    );
  }
}
