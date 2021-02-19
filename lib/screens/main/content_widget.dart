import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/services/backend/backend_service.dart';
import 'package:personal_space/utils/screens/content_widget_utils.dart';

class ContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        child: StreamBuilder<List<RemoteFileModel>>(
          stream: BackendService.get(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            List<RemoteFileModel> remoteFiles = snapshot.data;

            if (remoteFiles == null || remoteFiles.isEmpty) return Container();

            /* TODO: IMPLEMENT SEARCHING */

            return GroupedListView<RemoteFileModel, String>(
              elements: remoteFiles,
              groupBy: ContentWidgetUtils.groupBy,
              groupSeparatorBuilder: ContentWidgetUtils.groupSeparatorBuilder,
              itemBuilder: ContentWidgetUtils.itemBuilder,
              itemComparator: ContentWidgetUtils.itemComparator,
              order: GroupedListOrder.ASC,
              useStickyGroupSeparators: false,
              floatingHeader: true,
            );
          },
        ),
      );
}
