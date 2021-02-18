import 'package:flutter/material.dart';
import 'package:personal_space/screens/main/progress_widget.dart';
import 'package:personal_space/utils/screens/main_screen_utils.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext _) => MultiProvider(
        providers: MainScreenUtils.getProviders(),
        builder: (context, _) => Scaffold(
          appBar: MainScreenUtils.buildAppBar(),
          body: Stack(
            children: [
              ProgressWidget(),
            ],
          ),
        ),
      );
}
