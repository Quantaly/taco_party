import 'package:color/color.dart';

HslColor augmentColor(Color inputColor) {
  final hsl = inputColor.toHslColor();
  if (hsl.l > 70) {
    return HslColor(hsl.h, hsl.s, hsl.l - 10);
  } else {
    return HslColor(hsl.h, hsl.s, hsl.l + 25);
  }
}
