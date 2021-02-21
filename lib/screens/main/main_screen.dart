import 'package:flutter/material.dart';
import 'package:personal_space/screens/main/content_widget/content_widget.dart';
import 'package:personal_space/screens/main/progress_widget.dart';
import 'package:personal_space/utils/screens/main_screen_utils/main_screen_utils.dart';
import 'package:provider/provider.dart';

enum MainScreenFileType {
  BIN_FILES,
  MAIN_FILES,
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext _) => MultiProvider(
        providers: MainScreenUtils.getProviders(),
        builder: (context, _) => Scaffold(
          backgroundColor: Colors.white,
          appBar: MainScreenUtils.buildAppBar(),
          body: Stack(
            children: [
              /* this widget contains the main user files, and is displayed as a grouped list view */
              ContentWidget(),

              /* this widget is shown to the user, when a file is being encrypted / uploaded */
              ProgressWidget(),
            ],
          ),
        ),
      );
}
