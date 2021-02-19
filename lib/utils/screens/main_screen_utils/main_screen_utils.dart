import 'package:flutter/material.dart';
import 'package:personal_space/model/progress_model.dart';
import 'package:personal_space/screens/main/progress_widget.dart';
import 'package:personal_space/services/screens/main_screen_service.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MainScreenUtils {
  MainScreenUtils._();

  /* following contains all the util methods used in the main_screen */
  static List<SingleChildWidget> getProviders() => [
        /* to facilitate search functionality */
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(''),
        ),

        /* for the uploading progress model build for the progress widget */
        ListenableProvider<ProgressModel>(
          create: (_) => ProgressModel(percentageDone: 35.0),
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

  static Widget _buildProfileButton() => IconButton(
        icon: Icon(
          Icons.people,
          size: 28.0,
          color: kDarkGray,
        ),
        onPressed: MainScreenService.onProfileButtonPress,
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
        _buildProfileButton(),
        kDividerHor20,
      ];

  static AppBar buildAppBar() => AppBar(
        backgroundColor: Colors.white,
        elevation: 5.0,
        leading: _buildLogoWidget(),
        title: _buildSearchBar(),
        actions: _buildOtherActions(),
      );
}