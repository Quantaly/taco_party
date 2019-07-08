import 'dart:math' as math;

import 'package:color/color.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:taco_party/everything.g.dart';

part 'sprite_set.g.dart';

@JsonSerializable()
class SpriteSet {
  num maxHorzVelocity;
  num minVertVelocity;
  num maxVertVelocity;
  @JsonKey(fromJson: toRadians, toJson: toDegrees)
  num maxAngularVelocity;

  String name;

  List<SpriteSetImageData> images;

  @JsonKey(fromJson: _parseColor, toJson: _encodeColor)
  Color textColor;
  @JsonKey(fromJson: _parseColor, toJson: _encodeColor)
  Color backgroundColor;

  int numTacos;

  @JsonKey(includeIfNull: false)
  String soundUrl;

  @JsonKey(includeIfNull: false)
  SpriteSetFontInfo font;

  @JsonKey(ignore: true)
  Bundle bundle;

  SpriteSet({
    this.maxHorzVelocity,
    this.minVertVelocity,
    this.maxVertVelocity,
    this.maxAngularVelocity,
    this.name,
    this.images,
    this.textColor,
    this.backgroundColor,
    this.numTacos,
    this.soundUrl,
    this.font,
    this.bundle,
  });

  factory SpriteSet.fromJson(Map<String, dynamic> map, [Bundle bundle]) =>
      _$SpriteSetFromJson(map["data"] ?? map)..bundle = bundle;

  Map<String, dynamic> toJson() => _$SpriteSetToJson(this);

  static Color _parseColor(thing) {
    if (thing is List) {
      return RgbColor(thing[0], thing[1], thing[2]);
    } else if (thing is String) {
      if (thing.startsWith("#")) {
        return HexColor(thing.substring(1));
      } else {
        return RgbColor.namedColors[thing];
      }
    } else {
      throw ParseException("Bad color format");
    }
  }

  static String _encodeColor(Color color) => color.toHexColor().toCssString();

  static SpriteSet get defaultSpriteSet => SpriteSet(
        maxHorzVelocity: 4,
        minVertVelocity: 5,
        maxVertVelocity: 10.3,
        maxAngularVelocity: toRadians(3),
        images: [
          SpriteSetImageData(
            src: "http://clipart-library.com/image_gallery/406876.png",
            width: 240,
            height: 216,
          ),
        ],
        name: "Tacos!",
        textColor: RgbColor.namedColors["purple"],
        backgroundColor: RgbColor.namedColors["yellow"],
        numTacos: 32,
      );
}

@JsonSerializable()
class SpriteSetImageData {
  String src;
  @JsonKey(includeIfNull: false)
  int width;
  @JsonKey(includeIfNull: false)
  int height;
  @JsonKey(includeIfNull: false)
  int weight;

  SpriteSetImageData({this.src, this.width, this.height, this.weight});

  factory SpriteSetImageData.fromJson(Map<String, dynamic> map) =>
      _$SpriteSetImageDataFromJson(map);

  Map<String, dynamic> toJson() => _$SpriteSetImageDataToJson(this);
}

@JsonSerializable()
class SpriteSetFontInfo {
  String name;
  @JsonKey(defaultValue: false)
  bool googleFontsImport;

  SpriteSetFontInfo({this.name, this.googleFontsImport});

  factory SpriteSetFontInfo.fromJson(Map<String, dynamic> map) =>
      _$SpriteSetFontInfoFromJson(map);

  Map<String, dynamic> toJson() => _$SpriteSetFontInfoToJson(this);
}

num toRadians(num degrees) => degrees / 360 * 2 * math.pi;
num toDegrees(num radians) => radians * 360 / 2 / math.pi;
