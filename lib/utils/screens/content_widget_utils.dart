import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/date_helper.dart';

class ContentWidgetUtils {
  ContentWidgetUtils._();

  static String groupBy(RemoteFileModel model) {
    DateTime uploadedOn = model.uploadedOn;
    if (uploadedOn.isToday()) return 'Today';
    if (uploadedOn.isYesterday()) return 'Yesterday';
    if (uploadedOn.isSameWeek()) return DateFormat('E').format(uploadedOn);
    if (uploadedOn.isSameYear())
      return DateFormat('EEE, d MMM').format(uploadedOn);

    return DateFormat('EEE, dd MMM yyyy').format(uploadedOn);
  }

  static Widget groupSeparatorBuilder(String groupByValue) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Text(
        groupByValue,
        style: kGroupByTextStyle,
      ),
    );
  }

  static Widget itemBuilder(
    BuildContext context,
    RemoteFileModel model,
  ) {
    return Container();
  }

  static int itemComparator(RemoteFileModel m1, RemoteFileModel m2) =>
      m1.uploadedOn.microsecondsSinceEpoch.compareTo(
        m2.uploadedOn.microsecondsSinceEpoch,
      );
}
