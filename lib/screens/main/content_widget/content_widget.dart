import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/screens/main/content_widget/grouped_list_view.dart';
import 'package:personal_space/services/backend/backend_service.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';
import 'package:personal_space/services/util/search_service.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<List<RemoteFileModel>>(
        stream: BackendService.get(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          /* this future builder returns the list of remote files after decrypting every file name */
          return FutureBuilder<List<RemoteFileModel>>(
            future: EncryptionService.preprocessRemoteFiles(snapshot.data),
            builder: (_, decryptedFileNameSnapshot) {
              if (decryptedFileNameSnapshot.connectionState ==
                  ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              return Consumer<ValueNotifier<String>>(
                builder: (_, vnSearchKeyword, __) => GroupedListView(
                  files: SearchService.searchFor(
                    vnSearchKeyword.value,
                    decryptedFileNameSnapshot.data,
                  ),
                ),
              );
            },
          );
        },
      );
}
