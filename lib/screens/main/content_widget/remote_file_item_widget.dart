import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/model/selected_remote_file_model.dart';
import 'package:personal_space/services/screens/remote_file_item_widget_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

const double containerSize = 120;

class RemoteFileItemWidget extends StatelessWidget {
  final RemoteFileModel remoteFileModel;

  RemoteFileItemWidget({
    @required this.remoteFileModel,
  });

  Widget _buildMainBody(BuildContext context) => InkWell(
        hoverColor: Colors.white,
        highlightColor: Colors.white,
        onTap: () => RemoteFileItemWidgetService.openFile(
          context,
          remoteFileModel,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                remoteFileModel.decryptedFileName ?? 'xxx',
                textAlign: TextAlign.center,
                style: kRemoteFileItemWidgetFileNameTextStyle,
              ),
            ],
          ),
        ),
      );

  Widget _buildSelectionActionWidget(
    SelectedRemoteFileModel selectedRemoteFileModel,
    BuildContext context,
  ) =>
      Consumer<ValueNotifier<bool>>(
        builder: (_, vnHovering, child) => AnimatedOpacity(
          duration: kFastAnimationDuration,
          opacity: vnHovering.value ||
                  selectedRemoteFileModel.isFileSelected(
                    remoteFileModel,
                  )
              ? 1.0
              : 0.0,
          child: child,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: containerSize,
            height: containerSize * 0.40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.20),
                  Colors.black.withOpacity(0.10),
                  Colors.transparent,
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () => RemoteFileItemWidgetService.selectOrDeselectFile(
                    context,
                    remoteFileModel,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: selectedRemoteFileModel.isFileSelected(
                      remoteFileModel,
                    )
                        ? Colors.blue
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext _) => ListenableProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(false),
        builder: (context, _) => FocusableActionDetector(
          onShowHoverHighlight: (bool onHover) =>
              Provider.of<ValueNotifier<bool>>(
            context,
            listen: false,
          ).value = onHover,
          child: Consumer<SelectedRemoteFileModel>(
            builder: (_, selectedRemoteFileModel, mainBodyWidget) => Container(
              color: selectedRemoteFileModel.isFileSelected(remoteFileModel)
                  ? Colors.blue.withOpacity(0.05)
                  : Colors.white,
              margin: const EdgeInsets.all(8.0),
              width: containerSize,
              child: Stack(
                children: [
                  mainBodyWidget,
                  _buildSelectionActionWidget(
                    selectedRemoteFileModel,
                    context,
                  ),
                ],
              ),
            ),
            child: _buildMainBody(context),
          ),
        ),
      );
}
