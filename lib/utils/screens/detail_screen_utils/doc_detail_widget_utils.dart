import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

class DocDetailWidgetUtils {
  DocDetailWidgetUtils._();

  static void openDoc(Uint8List data, String extension) {
    final blob = html.Blob(
      [data],
      'application/$extension',
    );
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
    html.Url.revokeObjectUrl(url);
  }
}
