import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/screens/remote_file_item_widget_service.dart';
import 'package:personal_space/utils/constants.dart';

class RemoteFileItemWidget extends StatelessWidget {
  final RemoteFileModel remoteFileModel;

  RemoteFileItemWidget({
    @required this.remoteFileModel,
  });

  @override
  Widget build(BuildContext context) {
    double containerSize = 120;

    return InkWell(
      onTap: () {},
      onDoubleTap: () => RemoteFileItemWidgetService.openFile(
        context,
        remoteFileModel,
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        width: containerSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              RemoteFileItemWidgetService.getAsset(
                remoteFileModel.fileExtension,
              ),
              height: containerSize / 2,
              width: containerSize / 2,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              remoteFileModel.fileName,
              textAlign: TextAlign.center,
              style: kRemoteFileItemWidgetFileNameTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
