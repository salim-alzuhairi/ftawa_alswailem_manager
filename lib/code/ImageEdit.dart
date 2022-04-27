
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class ImageEdit {

  final int rotate;
  final state;

  ImageEdit(this.rotate, this.state);

  Future<Uint8List?> ImageEditng () async {

    int r = 0;
    if (rotate == 1) {
      r = 90;
    } else if (rotate == 2) {
      r = 180;
    } else if (rotate == 3) {
      r = 270;
    }
    final Rect? rect = state.getCropRect();
    final img = state.rawImageData;
    final action = state.editAction;
    final edit = ImageEditorOption();
    edit.addOptions([
      ClipOption.fromRect(rect!),
      FlipOption(vertical: action!.flipX, horizontal: action.flipY),
      RotateOption(r)
    ]);
    edit.outputFormat = const OutputFormat.png();
    final result = await ImageEditor.editImage(
        image: img, imageEditorOption: edit);

    return result;

  }

}