import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/screens/detail_screen_utils/detail_screen_utils.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final RemoteFileModel remoteFileModel;

  DetailScreen({
    @required this.remoteFileModel,
  });

  @override
  Widget build(BuildContext context) => Provider<RemoteFileModel>(
        create: (_) => remoteFileModel,
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              DetailScreenUtils.buildBody(
                remoteFileModel.fileExtension,
              ),
              DetailScreenUtils.buildAppBar(),
            ],
          ),
        ),
      );
}
