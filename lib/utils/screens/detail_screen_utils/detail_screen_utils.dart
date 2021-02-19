import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_space/screens/detail/audio_detail_widget.dart';
import 'package:personal_space/screens/detail/image_detail_widget.dart';
import 'package:personal_space/screens/detail/pdf_detail_widget.dart';
import 'package:personal_space/screens/detail/unsupported_detail_widget.dart';
import 'package:personal_space/screens/detail/video_detail_widget.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:provider/provider.dart';

enum DetailScreenType {
  IMAGE,
  VIDEO,
  AUDIO,
  PDF,
  NONE,
}

class DetailScreenUtils {
  DetailScreenUtils._();

  static DetailScreenType _getScreenType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return DetailScreenType.PDF;

      case 'mp4':
        return DetailScreenType.VIDEO;

      case 'mp3':
        return DetailScreenType.AUDIO;

      case 'png':
        return DetailScreenType.IMAGE;
      case 'jpg':
        return DetailScreenType.IMAGE;
      case 'jpeg':
        return DetailScreenType.IMAGE;
      case 'svg':
        return DetailScreenType.IMAGE;
    }

    return DetailScreenType.NONE;
  }

  static Widget buildBody(String extension) {
    switch (_getScreenType(extension)) {
      case DetailScreenType.IMAGE:
        return ImageDetailWidget();

      case DetailScreenType.VIDEO:
        return VideoDetailWidget();

      case DetailScreenType.AUDIO:
        return AudioDetailWidget();

      case DetailScreenType.PDF:
        return PdfDetailWidget();

      case DetailScreenType.NONE:
        return UnsupportedDetailWidget();
    }

    return UnsupportedDetailWidget();
  }

  static Widget _buildIconButton(
    IconData iconData,
    Function onPressed,
  ) =>
      IconButton(
        icon: Icon(
          iconData,
          color: Colors.white,
        ),
        onPressed: onPressed,
      );

  static Future<void> _navBarDelay() => Future.delayed(kFastWaitDuration);

  static void _delete() {}

  static void _showInfo() {}

  static void _showMenu() {}

  /* auto hide and appear appbar */
  static Widget buildAppBar() => ListenableProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(true),
        builder: (context, _) {
          ValueNotifier<bool> vnVisibility = Provider.of(
            context,
            listen: false,
          );

          /* hide the nav bar after the delay - for the first time */
          _navBarDelay().then((value) => vnVisibility.value = false);

          return Align(
            alignment: Alignment.topCenter,
            child: FocusableActionDetector(
              onShowHoverHighlight: (bool hovering) {
                if (hovering)
                  /* show the app bar */
                  vnVisibility.value = true;
                else
                  /* hide the app bar after a delay */
                  _navBarDelay().then((_) => vnVisibility.value = false);
              },
              child: Consumer<ValueNotifier<bool>>(
                builder: (_, vnVisibility, child) => AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: kFastAnimationDuration,
                  opacity: vnVisibility.value ? 1.0 : 0.0,
                  child: child,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withOpacity(0.90),
                        Colors.black.withOpacity(0.50),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      /* back button */
                      _buildIconButton(
                        Icons.arrow_back_rounded,
                        () => Navigator.pop(context),
                      ),
                      Spacer(),

                      /* delete button */
                      _buildIconButton(
                        Icons.delete_outline_rounded,
                        () => _delete(),
                      ),

                      /* sep */
                      kDividerHor20,

                      /* info button */
                      _buildIconButton(
                        Icons.info_outline_rounded,
                        () => _showInfo(),
                      ),

                      /* sep */
                      kDividerHor20,

                      /* more options button */
                      _buildIconButton(
                        Icons.menu_rounded,
                        () => _showMenu(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
}
