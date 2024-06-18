
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../constants.dart';
class LoaderX {
  static show(BuildContext context) {
    return Loader.show(context,
        progressIndicator: CircularProgressIndicator(color: mainColor,), overlayColor: Colors.white30);
  }

  static hide() {
    return Loader.hide();
  }
}