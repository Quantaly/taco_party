import 'package:json_annotation/json_annotation.dart';

import '../tools/string_base64.dart';

part 'bundle.g.dart';

@JsonSerializable(createToJson: false)
class Bundle {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "header_color")
  String headerColor;
  @JsonKey(name: "header_background_color")
  String headerBackgroundColor;
  @JsonKey(name: "borders_color")
  String bordersColor;
  @JsonKey(name: "body_background_color")
  String bodyBackgroundColor;

  @JsonKey(name: "sprite_sets")
  List<BundleSpriteSetData> spriteSets;

  @JsonKey(name: "prompt_subscribe", defaultValue: false)
  bool promptSubscribe;

  @JsonKey(ignore: true)
  String url;

  Bundle({
    this.name,
    this.headerColor,
    this.headerBackgroundColor,
    this.bordersColor,
    this.bodyBackgroundColor,
    this.spriteSets,
    this.promptSubscribe,
    this.url,
  });

  // sigh... would have called it fromMap
  // but this is what I get for using a JSON package to parse YAML
  factory Bundle.fromJson(Map<String, dynamic> map, [String url]) =>
      _$BundleFromJson(map)..url = url;
}

@JsonSerializable(createToJson: false)
class BundleSpriteSetData {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "display_name")
  String displayName;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "color")
  String color;

  BundleSpriteSetData({this.name, this.displayName, this.url, this.color});

  factory BundleSpriteSetData.fromJson(Map<String, dynamic> map) =>
      _$BundleSpriteSetDataFromJson(map);
}

const _specialBundleNames = ["internal", "permalink"];
const _stringBase64Decoder = StringBase64Decoder();
String normalizeBundleIdentifier(String identifier) {
  if (_specialBundleNames.contains(identifier)) return identifier;
  if (identifier.startsWith(RegExp("https?:\\/\\/"))) return identifier;
  try {
    final ret = _stringBase64Decoder.decode(identifier);
    if (!ret.startsWith(RegExp("https?:\\/\\/"))) throw FormatException();
    return ret;
  } on FormatException {
    throw FormatException("Malformed bundle identifier");
  }
}
