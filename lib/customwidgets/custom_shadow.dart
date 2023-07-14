import 'package:flutter/material.dart';

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    this.blurStyle = BlurStyle.normal,
  });

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }}