import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/screens/main/content_widget/grouped_list_view.dart';
import 'package:personal_space/services/backend/backend_service.dart';

class ContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<List<RemoteFileModel>>(
        stream: BackendService.get(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          List<RemoteFileModel> remoteFiles = snapshot.data;

          if (remoteFiles == null || remoteFiles.isEmpty) return Container();

          /* TODO: IMPLEMENT SEARCHING */

          return GroupedListView(
            files: remoteFiles,
          );
        },
      );
}
