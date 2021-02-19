import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/screens/remote_file_item_widget_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

class RemoteFileItemWidget extends StatelessWidget {
  final RemoteFileModel remoteFileModel;

  RemoteFileItemWidget({
    @required this.remoteFileModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ValueNotifier<String>>(
      create: (_) => ValueNotifier<String>(null),
      builder: (context, _) => InkWell(
        onTap: () => RemoteFileItemWidgetService.toggleFileNameVisibility(
          context,
          remoteFileModel.fileName,
          remoteFileModel.firestoreRef,
        ),
        onDoubleTap: () => RemoteFileItemWidgetService.openFile(
          context,
          remoteFileModel,
        ),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(10.0),
          width: 150.0,
          height: 150.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                RemoteFileItemWidgetService.getAsset(
                  remoteFileModel.fileExtension,
                ),
                height: 80.0,
                width: 80.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Consumer<ValueNotifier<String>>(
                builder: (_, vnFileName, __) {
                  bool showFileName = vnFileName.value != null;
                  return Text(
                    showFileName ? vnFileName.value : 'ENCRYPTED',
                    textAlign: TextAlign.center,
                    style: kRemoteFileItemWidgetFileNameTextStyle.copyWith(
                      fontWeight:
                          showFileName ? FontWeight.w800 : FontWeight.w400,
                      color: showFileName ? Colors.black : Colors.redAccent,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
