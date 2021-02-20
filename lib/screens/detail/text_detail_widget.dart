import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_space/model/text_settings.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/widgets/media_builder.dart';
import 'package:personal_space/widgets/auto_hide_widget.dart';
import 'package:provider/provider.dart';

class TextDetailWidget extends StatelessWidget {
  Widget _buildDarkThemeToggleWidget(BuildContext context) => Column(
        children: [
          Text(
            'Dark Theme',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
          Spacer(),
          Consumer<TextSettings>(
            builder: (_, textSettings, __) => CupertinoSwitch(
              trackColor: kLightGray,
              value: textSettings.darkTheme,
              onChanged: (_) =>
                  textSettings.darkTheme = !textSettings.darkTheme,
            ),
          ),
        ],
      );

  Widget _buildFontSizeChangeWidget(BuildContext context) {
    TextSettings textSettings = Provider.of<TextSettings>(
      context,
      listen: false,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.white,
          ),
          onPressed: () => textSettings.fontSize -= TextSettings.CHANGE_VALUE,
        ),
        Container(
          width: 50.0,
          child: Center(
            child: Consumer<TextSettings>(
              builder: (_, textSettings, __) => Text(
                textSettings.fontSize.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => textSettings.fontSize += TextSettings.CHANGE_VALUE,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext _) => MediaBuilder(
        builder: (Uint8List data, _) => ListenableProvider<TextSettings>(
          create: (_) => TextSettings(),
          builder: (context, __) => Consumer<TextSettings>(
            builder: (_, textSettings, child) => Container(
              color: textSettings.darkTheme ? Colors.black : Colors.white,
              child: child,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /* display main text */
                Consumer<TextSettings>(
                  builder: (_, textSettings, __) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: SelectableText(
                      String.fromCharCodes(data),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: textSettings.fontSize,
                        color: textSettings.darkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),

                /* text settings */
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AutoHideWidget(
                    disappearOpacityValue: 0.10,
                    child: Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: kDarkestGray,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      margin: const EdgeInsets.all(
                        20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDarkThemeToggleWidget(context),
                          kDividerHor20,
                          _buildFontSizeChangeWidget(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
