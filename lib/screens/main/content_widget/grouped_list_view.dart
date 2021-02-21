import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/screens/main/content_widget/remote_file_item_widget.dart';
import 'package:personal_space/utils/screens/main_screen_utils/grouped_list_view_utils.dart';

class GroupedListView extends StatelessWidget {
  final List<RemoteFileModel> files;

  GroupedListView({
    @required this.files,
  });

  @override
  Widget build(BuildContext context) {
    /* TODO: BUILD EMPTY FILES WIDGET */
    if (files == null || files.isEmpty) return Container();

    Map<String, List<RemoteFileModel>> groupedFiles = Map();

    /* group files as per belongsToGroup value */
    for (RemoteFileModel fileModel in files) {
      String belongsToGroup = GroupedListViewUtils.getBelongsToGroup(fileModel);

      if (groupedFiles.containsKey(belongsToGroup))
        groupedFiles[belongsToGroup].add(fileModel);
      else
        groupedFiles[belongsToGroup] = <RemoteFileModel>[fileModel];
    }

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 20.0,
      ),
      children: groupedFiles.entries.map((entries) {
        String groupName = entries.key;
        List<RemoteFileModel> groupFiles = entries.value;

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              GroupedListViewUtils.groupSeparatorBuilder(
                groupName,
                groupedFiles,
              ),
              Wrap(
                children: groupFiles
                    .map((RemoteFileModel remoteFileModel) =>
                        RemoteFileItemWidget(
                          remoteFileModel: remoteFileModel,
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
