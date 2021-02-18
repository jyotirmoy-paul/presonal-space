import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:personal_space/model/progress_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

class ProgressWidget extends StatelessWidget {
  BoxDecoration _getDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 5.0,
            spreadRadius: 5.0,
          )
        ],
      );

  Widget _buildTitle(ProgressStatus status) {
    if (status == ProgressStatus.UPLOADING)
      return Text(
        'Uploading',
        style: kUploadingWidgetTitleTextTextStyle,
      );

    return Text(
      'Encrypting',
      style: kUploadingWidgetTitleTextTextStyle,
    );
  }

  Widget _buildFileStatus(ProgressModel model) {
    if (model.files == null || model.files.isEmpty)
      return Text(
        'radha-krishna.txt',
        textAlign: TextAlign.center,
        style: kUploadingWidgetFileNameTextStyle,
      );

    int n = model.files.length;
    int idx = (n * model.percentageDone / 100).floor();

    return Text(
      model.files[idx].fileName,
      textAlign: TextAlign.center,
      style: kUploadingWidgetFileNameTextStyle,
    );
  }

  Widget _buildPercentageDone(double percentageDone) => Text(
        '${percentageDone.toStringAsFixed(2)}% done',
        style: kUploadingWidgetPercentageDoneTextStyle,
      );

  Widget _buildProgressIndicator(double percentageDone) =>
      LinearProgressIndicator(
        backgroundColor: kLightGray,
        value: percentageDone / 100,
      );

  Widget _buildMainProgressView(
    BuildContext context,
    ProgressModel model,
  ) =>
      AnimatedContainer(
        duration: kAnimationDuration,
        curve: Curves.elasticInOut,
        width: MediaQuery.of(context).size.width * 0.25,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: _getDecoration(),
        child: model.progressStatus == ProgressStatus.DONE
            /* TODO: INSTEAD OF ICON, SHOW A DONE ANIMATION */
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80.0,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(model.progressStatus),
                  kDividerVert20,
                  _buildFileStatus(model),
                  kDividerVert20,
                  _buildPercentageDone(model.percentageDone),
                  kDividerVert20,
                  _buildProgressIndicator(model.percentageDone),
                ],
              ),
      );

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomLeft,
        child: Consumer<ProgressModel>(
          builder: (_, model, __) => AnimatedSwitcher(
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
              alignment: Alignment.bottomCenter,
            ),
            switchInCurve: Curves.elasticInOut,
            switchOutCurve: Curves.elasticInOut,
            duration: kAnimationDuration,
            reverseDuration: kAnimationDuration,
            child: model.progressStatus == ProgressStatus.NONE
                ? kEmptyWidget
                : _buildMainProgressView(
                    context,
                    model,
                  ),
          ),
        ),
      );
}
