import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

class VideoDetailWidgetUtils {
  VideoDetailWidgetUtils._();

  static void playVideo(Uint8List data, String extension) {
    final blob = html.Blob(
      [data],
      'video/$extension',
    );
    final String atUrl = html.Url.createObjectUrlFromBlob(blob);
    final v = html.window.document.getElementById('videoPlayer');
    if (v != null) {
      v.setInnerHtml(
        '<source type="video/mp4" src="$atUrl">',
        validator: html.NodeValidatorBuilder()
          ..allowElement(
            'source',
            attributes: ['src', 'type'],
          ),
      );
      final a = html.window.document.getElementById('triggerVideoPlayer');
      if (a != null) a.dispatchEvent(html.MouseEvent('click'));
    }
  }
}
