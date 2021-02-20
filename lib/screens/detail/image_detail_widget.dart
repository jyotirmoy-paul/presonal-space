import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:personal_space/widgets/media_builder.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MediaBuilder(
        builder: (Uint8List data, _) => PhotoView(
          imageProvider: MemoryImage(data),
        ),
      );
}
