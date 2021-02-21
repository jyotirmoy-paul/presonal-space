import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/model/selected_remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/date_time_helper.dart';
import 'package:provider/provider.dart';

class GroupedListViewUtils {
  GroupedListViewUtils._();

  static String getBelongsToGroup(RemoteFileModel model) {
    DateTime uploadedOn = model.uploadedOn;

    if (uploadedOn.isToday()) return 'Today';
    if (uploadedOn.isYesterday()) return 'Yesterday';
    if (uploadedOn.isSameWeek()) return DateFormat('EEEE').format(uploadedOn);
    if (uploadedOn.isSameYear())
      return DateFormat('EEE, d MMM').format(uploadedOn);

    return DateFormat('EEE, dd MMM yyyy').format(uploadedOn);
  }

  static Widget _buildCheckbox(
    void onChanged(bool newValue),
    bool value,
  ) =>
      GestureDetector(
        onTap: () => onChanged(!value),
        child: Icon(
          Icons.check_circle,
          size: 30.0,
          color: value ? Colors.blue : kDarkGray,
        ),
      );

  static void _onCheckBoxTap(
    bool newValue,
    List<RemoteFileModel> filesInTheGroup,
    BuildContext context,
  ) {
    SelectedRemoteFileModel selectedRemoteFileModel =
        Provider.of<SelectedRemoteFileModel>(
      context,
      listen: false,
    );

    if (newValue == true)
      /* select all the element of this group */
      selectedRemoteFileModel.addAllFiles(filesInTheGroup);
    else
      /* de-select all the elements from this group */
      selectedRemoteFileModel.removeAllFiles(filesInTheGroup);
  }

  /* check if all the files in the group are added or not */
  static bool _getCheckBoxValue(
    List<RemoteFileModel> filesInTheGroup,
    BuildContext context,
  ) =>
      Provider.of<SelectedRemoteFileModel>(
        context,
        listen: false,
      ).areAllFilesSelected(filesInTheGroup);

  static Widget groupSeparatorBuilder(
    String groupByValue,
    Map<String, List<RemoteFileModel>> groupedFiles,
  ) =>
      ListenableProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(false),
        builder: (context, _) => FocusableActionDetector(
          onShowHoverHighlight: (bool hovering) =>
              Provider.of<ValueNotifier<bool>>(
            context,
            listen: false,
          ).value = hovering,
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Consumer2<ValueNotifier<bool>, SelectedRemoteFileModel>(
              builder: (_, vnHovering, __, ___) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: kFastAnimationDuration,
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) => ScaleTransition(
                      child: child,
                      scale: animation,
                      alignment: Alignment.center,
                    ),
                    child: vnHovering.value ||
                            _getCheckBoxValue(
                              groupedFiles[groupByValue],
                              context,
                            )
                        ? Container(
                            margin: const EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: _buildCheckbox(
                              (bool newValue) => _onCheckBoxTap(
                                newValue,
                                groupedFiles[groupByValue],
                                context,
                              ),
                              _getCheckBoxValue(
                                groupedFiles[groupByValue],
                                context,
                              ),
                            ),
                          )
                        : kEmptyWidget,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      groupByValue,
                      style: kGroupByTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
