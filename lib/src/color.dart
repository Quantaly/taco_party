class Color {
  final int r;
  final int g;
  final int b;

  const Color(this.r, this.g, this.b);

  /* https://en.wikipedia.org/wiki/HSL_and_HSV#From_HSL */
  factory Color.hsl(num h, num s, num l) {
    var c = (1 - (2 * l - 1).abs()) * s;
    var h2 = h / 60;
    var x = c * (1 - (h2 % 2 - 1).abs());
    num r2, g2, b2;
    switch (h2.floor()) {
      case 0:
        r2 = c;
        g2 = x;
        b2 = 0;
        break;
      case 1:
        r2 = x;
        g2 = c;
        b2 = 0;
        break;
      case 2:
        r2 = 0;
        g2 = c;
        b2 = x;
        break;
      case 3:
        r2 = 0;
        g2 = c;
        b2 = x;
        break;
      case 4:
        r2 = x;
        g2 = 0;
        b2 = c;
        break;
      case 5:
      case 6:
        r2 = c;
        g2 = 0;
        b2 = x;
        break;
      default:
        r2 = g2 = b2 = 0;
    }
    var m = l - (c / 2);
    return Color(((r2 + m) * 255).round(), ((g2 + m) * 255).round(),
        ((b2 + m) * 255).round());
  }

  /* https://en.wikipedia.org/wiki/HSL_and_HSV#Conversion_RGB_to_HSV_used_commonly_in_software_programming */
  num get h {
    if (r == g && g == b) return 0;
    var dR = r / 255, dG = g / 255, dB = b / 255;
    num ret;
    if (r > g && r > b) {
      // max is R
      if (g < b) {
        // min is G
        ret = 60 * (dG - dB) / (dR - dG);
      } else {
        // min is B
        ret = 60 * (dG - dB) / (dR - dB);
      }
    } else if (g > b) {
      // max is G
      if (r < b) {
        // min is R
        ret = 60 * (2 + (dB - dR) / (dG - dR));
      } else {
        // min is B
        ret = 60 * (2 + (dB - dR) / (dG - dB));
      }
    } else {
      // max is B
      if (r < g) {
        // min is R
        ret = 60 * (4 + (dR - dG) / (dB - dR));
      } else {
        // min is G
        ret = 60 * (4 + (dR - dG) / (dB - dG));
      }
    }
    while (ret < 0) ret += 360;
    return ret;
  }

  num get s {
    if (r == g && g == b && (b == 0 || b == 255)) return 0;
    num max, min;
    if (r > g && r > b) {
      max = r / 255;
      if (g < b) {
        min = g / 255;
      } else {
        min = b / 255;
      }
    } else if (g > b) {
      max = g / 255;
      if (r < b) {
        min = r / 255;
      } else {
        min = b / 255;
      }
    } else {
      max = b / 255;
      if (r < g) {
        min = r / 255;
      } else {
        min = g / 255;
      }
    }
    return (max - min) / (1 - (max + min - 1).abs());
  }

  num get l {
    const f = 2 * 255;
    if (r > g && r > b) {
      if (g < b) {
        return (r + g) / f;
      } else {
        return (r + b) / f;
      }
    } else if (g > b) {
      if (r < b) {
        return (g + r) / f;
      } else {
        return (g + b) / f;
      }
    } else {
      if (r < g) {
        return (b + r) / f;
      } else {
        return (b + g) / f;
      }
    }
  }

  @override
  String toString() => "rgb($r, $g, $b)";
}
