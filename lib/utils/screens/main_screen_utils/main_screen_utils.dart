import 'package:flutter/material.dart';
import 'package:personal_space/model/progress_model.dart';
import 'package:personal_space/model/selected_remote_file_model.dart';
import 'package:personal_space/screens/main/main_screen.dart';
import 'package:personal_space/services/screens/main_screen_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MainScreenUtils {
  MainScreenUtils._();

  /* following contains all the util methods used in the main_screen */
  static List<SingleChildWidget> getProviders() => [
        /* allow shifting between main and bin files - default is MAIN_FILES*/
        ListenableProvider<ValueNotifier<MainScreenFileType>>(
          create: (_) => ValueNotifier<MainScreenFileType>(
            MainScreenFileType.MAIN_FILES,
          ),
        ),

        /* allow selection of remote files for mass deletion / mass marking */
        ListenableProvider<SelectedRemoteFileModel>(
          create: (_) => SelectedRemoteFileModel(),
        ),

        /* to facilitate search functionality */
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(''),
        ),

        /* for the uploading progress model build for the progress widget */
        ListenableProvider<ProgressModel>(
          create: (_) => ProgressModel(percentageDone: 0.0),
        ),
      ];

  /* following contains all the widgets build in the main_screen */

  static Widget _buildLogoWidget() => Center(
        child: Container(
          padding: const EdgeInsets.only(
            left: 18.0,
          ),
          width: 100.0,
          child: Text(
            'PS',
            style: kTextStyle25.copyWith(
              color: kDarkGray,
            ),
          ),
        ),
      );

  static Widget _buildSearchBar() => Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: kLightGray,
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: TextField(
            onChanged: (v) => MainScreenService.onSearchTextChange(
              context,
              v,
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: kDarkGray,
                size: 28.0,
              ),
              hintStyle: TextStyle(
                color: kGray,
              ),
              border: InputBorder.none,
              hintText: 'Search your files',
            ),
          ),
        ),
      );

  /* show actions for the selected files */
  static Widget _buildActionWidgetForSelectedFiles(
    SelectedRemoteFileModel selectedFiles,
  ) =>
      Row(
        children: [
          /* clear All selections button */
          IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.black,
            ),
            onPressed: selectedFiles.clearAllSelections,
          ),

          /* no of files selected indicator */
          kDividerHor20,
          Text(
            '${selectedFiles.selectionCount} Selected',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),

          /* spacer */
          Spacer(),

          /* delete button */
          IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.black,
            ),
            onPressed: () => MainScreenService.deleteRemoteFilesToBin(
              selectedFiles.allFiles,
              selectedFiles,
            ),
          ),
        ],
      );

  static Widget _buildMenu() => Builder(
        builder: (context) => PopupMenuButton<String>(
          offset: kMenuPopupOffset,
          onSelected: (String choice) => MainScreenService.onMenuChoiceTap(
            choice,
            context,
          ),
          icon: Icon(
            Icons.more_vert_rounded,
            size: 28.0,
            color: kDarkGray,
          ),
          itemBuilder: (_) => kMainScreenMenuItemChoices
              .map<PopupMenuItem<String>>(
                (c) => PopupMenuItem<String>(
                  value: c,
                  child: Text(c),
                ),
              )
              .toList(),
        ),
      );

  static Widget _buildUploadButton() => Builder(
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          child: InkWell(
            splashColor: kLightGray,
            onTap: () => MainScreenService.onUploadButtonPress(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_circle_up,
                    size: 28.0,
                    color: kDarkGray,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Upload',
                    style: TextStyle(
                      color: kDarkGray,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  static List<Widget> _buildOtherActions() => <Widget>[
        _buildUploadButton(),
        kDividerHor20,
        _buildMenu(),
        kDividerHor20,
      ];

  static Widget _buildTitle(SelectedRemoteFileModel selectedRemoteFileModel) =>
      selectedRemoteFileModel.isThereAnySelection
          ? _buildActionWidgetForSelectedFiles(
              selectedRemoteFileModel,
            )
          : _buildSearchBar();

  static Widget buildAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Consumer<SelectedRemoteFileModel>(
          builder: (_, selectedRemoteFileModel, __) => AppBar(
            backgroundColor: Colors.white,
            elevation: 5.0,
            leading: _buildLogoWidget(),
            title: _buildTitle(selectedRemoteFileModel),
            actions: selectedRemoteFileModel.isThereAnySelection
                ? []
                : _buildOtherActions(),
          ),
        ),
      );
}
