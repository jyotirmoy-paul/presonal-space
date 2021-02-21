import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/screens/main/content_widget/grouped_list_view.dart';
import 'package:personal_space/screens/main/main_screen.dart';
import 'package:personal_space/services/backend/backend_service.dart';
import 'package:personal_space/services/encryption/encryption_service.dart';
import 'package:personal_space/services/util/search_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Consumer<ValueNotifier<MainScreenFileType>>(
            builder: (_, vnMainScreenFileType, __) =>
                vnMainScreenFileType.value == MainScreenFileType.BIN_FILES
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 30.0,
                              top: 20.0,
                              bottom: 10.0,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                  ),
                                  onPressed: () => vnMainScreenFileType.value =
                                      MainScreenFileType.MAIN_FILES,
                                ),
                                kDividerHor20,
                                Text(
                                  'BIN',
                                  style: kTextStyle25,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: kGray,
                          ),
                        ],
                      )
                    : kEmptyWidget,
          ),
          Expanded(
            child: StreamBuilder<List<RemoteFileModel>>(
              stream: BackendService.get(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                /* this future builder returns the list of remote files after decrypting every file name */
                return Consumer<ValueNotifier<MainScreenFileType>>(
                  builder: (_, vnMainScreenFileType, __) =>
                      FutureBuilder<List<RemoteFileModel>>(
                    future: EncryptionService.preprocessRemoteFiles(
                      snapshot.data,
                      vnMainScreenFileType.value,
                    ),
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
                  ),
                );
              },
            ),
          ),
        ],
      );
}
