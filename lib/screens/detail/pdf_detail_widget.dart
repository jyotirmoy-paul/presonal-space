import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:personal_space/utils/constants.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:personal_space/widgets/media_builder.dart';

class PdfDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MediaBuilder(
        builder: (Uint8List data) {
          final blob = html.Blob(
            [data],
            'application/pdf',
          );
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(url, "_blank");
          html.Url.revokeObjectUrl(url);
          return Center(
            child: Text(
              'Opened PDF in a new tab',
              style: kTextStyle30,
            ),
          );
        },
      );
}
