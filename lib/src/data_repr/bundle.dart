import 'package:json_annotation/json_annotation.dart';

import '../tools/string_base64.dart';

part 'bundle.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Bundle {
  String name;
  String headerColor;
  String headerBackgroundColor;
  String bordersColor;
  String bodyBackgroundColor;

  List<BundleSpriteSetData> spriteSets;

  @JsonKey(defaultValue: false)
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

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class BundleSpriteSetData {
  String name;
  String displayName;
  String url;
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
