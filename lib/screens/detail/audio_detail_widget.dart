import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:personal_space/model/remote_file_model.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:personal_space/utils/screens/detail_screen_utils/audio_detail_widget_utils.dart';
import 'package:personal_space/widgets/media_builder.dart';
import 'package:universal_html/html.dart';

class AudioDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: kDarkGray,
        child: MediaBuilder(
          builder: (
            Uint8List data,
            RemoteFileModel remoteFileModel,
          ) =>
              FutureBuilder<AudioPlayer>(
            future: AudioDetailWidgetUtils.initPlayer(
              data,
              remoteFileModel.fileExtension,
            ),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );

              if (!snapshot.hasData)
                return Center(
                  child: Text(
                    'Something went wrong',
                    style: kErrorTextStyle,
                  ),
                );

              final AudioPlayer audioPlayer = snapshot.data;

              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 30.0,
                  ),
                  decoration: BoxDecoration(
                    color: kDarkestGray,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* control buttons - play/pause, skip ahead, skip back, stop, replay */
                      AudioDetailWidgetUtils.buildTopControlView(
                        audioPlayer,
                      ),

                      /* slider */
                      kDividerVert20,
                      AudioDetailWidgetUtils.buildSlider(
                        audioPlayer,
                      ),

                      /* volume control buttons - volume mute, volume increment & decrement */
                      kDividerVert20,
                      AudioDetailWidgetUtils.buildBottomControlView(
                        audioPlayer,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
