import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:personal_space/utils/constants.dart';

class AudioDetailWidgetUtils {
  AudioDetailWidgetUtils._();

  static const double VOLUME_CHANGE_AMOUNT = 0.05;
  static const int SEEK_AMOUNT_IN_MILLISECOND = 3000;

  static String _formatDuration(Duration duration) {
    if (duration == null) return '';

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static Widget _buildRoundButton({
    @required Function onTap,
    @required IconData iconData,
    bool isLarge = false,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
              width: 1.0,
            ),
          ),
          child: Icon(
            iconData,
            color: Colors.green,
            size: isLarge ? 48.0 : 24.0,
          ),
        ),
      );

  static Widget buildTopControlView(AudioPlayer audioPlayer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /* stop button */
        _buildRoundButton(
          onTap: () => audioPlayer.stop(),
          iconData: Icons.stop,
        ),

        /* seek back button */
        _buildRoundButton(
          onTap: () => audioPlayer.seek(
            Duration(
              milliseconds: max(
                0,
                audioPlayer.position.inMilliseconds -
                    SEEK_AMOUNT_IN_MILLISECOND,
              ),
            ),
          ),
          iconData: Icons.fast_rewind_rounded,
        ),

        /* play / pause button */
        StreamBuilder<bool>(
          stream: audioPlayer.playingStream,
          builder: (_, snapshot) => _buildRoundButton(
            isLarge: true,
            onTap: () {
              if (snapshot.data ?? false)
                audioPlayer.pause();
              else
                audioPlayer.play();
            },
            iconData: (snapshot.data ?? false)
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
          ),
        ),

        /* seek front button */
        _buildRoundButton(
          onTap: () => audioPlayer.seek(
            Duration(
              milliseconds: min(
                audioPlayer.position.inMilliseconds +
                    SEEK_AMOUNT_IN_MILLISECOND,
                audioPlayer.duration.inMilliseconds,
              ),
            ),
          ),
          iconData: Icons.fast_forward_rounded,
        ),

        /* replay  */
        _buildRoundButton(
          onTap: () async {
            await audioPlayer.stop();
            audioPlayer.play();
          },
          iconData: Icons.replay_rounded,
        ),
      ],
    );
  }

  static Widget _buildTimeView(String time) => Text(
        time,
        style: TextStyle(
          color: Colors.green,
          fontSize: 15.0,
        ),
      );

  static Widget buildBottomControlView(AudioPlayer audioPlayer) {
    return Row(
      children: [
        /* timer streaming the current position */
        StreamBuilder<Duration>(
          stream: audioPlayer.positionStream,
          builder: (_, snapshot) => _buildTimeView(
            _formatDuration(
              snapshot.data,
            ),
          ),
        ),

        /* spacer */
        Spacer(),

        /* volume control buttons */

        /* volume low button */
        kDividerHor20,
        _buildRoundButton(
          onTap: () => audioPlayer.setVolume(
            max(0, audioPlayer.volume - VOLUME_CHANGE_AMOUNT),
          ),
          iconData: Icons.volume_down_rounded,
        ),

        /* volume mute button */
        kDividerHor20,
        StreamBuilder<double>(
          stream: audioPlayer.volumeStream,
          builder: (_, snapshot) => _buildRoundButton(
            onTap: () => audioPlayer.setVolume(
              snapshot.data == 0.0 ? 1.0 : 0.0,
            ),
            iconData: snapshot.data == 0.0
                ? Icons.volume_mute_rounded
                : Icons.volume_off_rounded,
          ),
        ),

        /* volume up button */
        kDividerHor20,
        _buildRoundButton(
          onTap: () => audioPlayer.setVolume(
            min(audioPlayer.volume + VOLUME_CHANGE_AMOUNT, 1),
          ),
          iconData: Icons.volume_up_rounded,
        ),

        /* spacer */
        Spacer(),

        /* showing the end time */
        _buildTimeView(
          _formatDuration(
            audioPlayer.duration,
          ),
        ),
      ],
    );
  }

  static Widget buildSlider(AudioPlayer audioPlayer) {
    double totalDuration = audioPlayer.duration.inMilliseconds.toDouble();
    return StreamBuilder<Duration>(
      initialData: Duration(seconds: 0),
      stream: audioPlayer.positionStream,
      builder: (_, snapshot) {
        double currentDuration = snapshot.data.inMilliseconds.toDouble();
        return Slider(
          onChangeEnd: (_) => audioPlayer.play(),
          onChangeStart: (_) => audioPlayer.pause(),
          min: 0.0,
          max: totalDuration,
          value: currentDuration,
          onChanged: (double value) => audioPlayer.seek(
            Duration(milliseconds: value.toInt()),
          ),
        );
      },
    );
  }

  static Future<AudioPlayer> initPlayer(
    Uint8List data,
    String extension,
  ) async {
    final AudioPlayer player = AudioPlayer();

    await player.setAudioSource(
      AudioSource.uri(
        Uri.dataFromBytes(
          data,
          mimeType: 'audio/${extension.toLowerCase()}',
        ),
      ),
    );

    await player.load();

    return player;
  }
}
