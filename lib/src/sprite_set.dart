import 'dart:math' as math;

import 'errors.dart';

class SpriteSet {
  num maxHorzVelocity;
  num minVertVelocity;
  num maxVertVelocity;
  num maxAngularVelocity;

  String title;

  List<ImageData> images;

  List<int> textColor;
  List<int> backgroundColor;

  int get maxWidth => images.fold(0, (a, b) => math.max(a, b.width));
  int get maxHeight => images.fold(0, (a, b) => math.max(a, b.height));
  num get maxHalfDiagonal {
    final x = maxWidth, y = maxHeight;
    return math.sqrt(x * x + y * y) / 2;
  }

  int numTacos;

  String soundUrl;

  SpriteSet(
      {this.maxHorzVelocity,
      this.minVertVelocity,
      this.maxVertVelocity,
      this.maxAngularVelocity,
      this.title,
      this.images,
      this.textColor,
      this.backgroundColor,
      this.numTacos,
      this.soundUrl});

  static SpriteSet fromMap(Map source) =>
      _checkLegacy(source) ??
      SpriteSet(
        maxHorzVelocity: source["max_horz_velocity"],
        minVertVelocity: source["min_vert_velocity"],
        maxVertVelocity: source["max_vert_velocity"],
        maxAngularVelocity: toRadians(source["max_angular_velocity"]),
        title: source["title"],
        images: (source["images"] as List)
            .cast<Map>()
            .map(ImageData.fromMap)
            .toList(growable: false),
        textColor: source["textColor"],
        backgroundColor: source["backgroundColor"],
        numTacos: source["numTacos"],
        soundUrl: source["soundUrl"],
      );

  // not sure what i'll do with this, but could be good to know.
  bool _isLegacy;
  bool get isLegacy => _isLegacy;
  static SpriteSet _checkLegacy(Map source) {
    if (source["class"] == "general") {
      return fromMap(source["data"]).._isLegacy = true;
    } else if (source["class"] != null) {
      throw ParseException("Inconvertible legacy format");
    }
    return null;
  }

  static SpriteSet get defaultSpriteSet => SpriteSet(
        maxHorzVelocity: 4,
        minVertVelocity: 5,
        maxVertVelocity: 10.3,
        maxAngularVelocity: toRadians(3),
        images: [
          ImageData(
            url:
                "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png",
            width: 240,
            height: 216,
          ),
        ],
        title: "Tacos!",
        textColor: const [0x80, 0x00, 0x80], // purple
        backgroundColor: const [0xff, 0xff, 0x00], // yellow
        numTacos: 32,
      );
}

class ImageData {
  String url;
  int width;
  int height;
  int weight;

  ImageData({this.url, this.width, this.height, this.weight});

  static ImageData fromMap(Map source) => ImageData(
        url: source["url"],
        width: source["width"],
        height: source["height"],
        weight: source["weight"],
      );
}

num toRadians(num degrees) => degrees / 360 * 2 * math.pi;
