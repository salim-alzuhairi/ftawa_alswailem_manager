import 'dart:typed_data';
import 'package:ftawa_alswailem_manager/UI/add.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ftawa_alswailem_manager/code/ImageEdit.dart';
import 'package:image_editor/image_editor.dart';

class CropImage extends StatefulWidget {
  String file;

  CropImage(this.file, {Key? key}) : super(key: key);

  @override
  State<CropImage> createState() => _CropImageState(file);
}

class _CropImageState extends State<CropImage> {
  String file;
  int rotate = 0;
  Uint8List? b;
  GlobalKey<ExtendedImageEditorState> key =
  GlobalKey<ExtendedImageEditorState>();

  _CropImageState(this.file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الصورة'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                final Future<Uint8List?> result = ImageEdit(rotate, key.currentState).ImageEditng();
                Navigator.pop(context, result);
              },
              icon: const Icon(Icons.done_outline))
        ],
      ),
      persistentFooterButtons: [
        Container(
          padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    rotate < 3 ? rotate += 1 : rotate = 0;
                  });
                },
                icon: const Icon(Icons.rotate_right),
                splashColor: Colors.amber,
              ),
              IconButton(
                onPressed: () {
                  key.currentState!.flip();
                },
                icon: const Icon(Icons.flip),
                splashColor: Colors.amber,
              ),
              IconButton(
                onPressed: () {
                  key.currentState!.reset();
                  setState(() {
                    rotate = 0;
                  });
                },
                icon: const Icon(Icons.restore),
                splashColor: Colors.amber,
              )
            ],
          ),
        )
      ],
      body: RotatedBox(
        quarterTurns: rotate,
        child: ExtendedImage.file(
          File(file),
          fit: BoxFit.contain,
          cacheRawData: true,
          clearMemoryCacheWhenDispose: true,
          mode: ExtendedImageMode.editor,
          extendedImageEditorKey: key,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              cropAspectRatio: rotate == 0 || rotate == 2 ? 2.5 : 0.4,
              cornerColor: Colors.amber,
              lineHeight: 0.00001,
            );
          },
        ),
      ),
    );
  }
}
