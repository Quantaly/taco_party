import 'tools/string_base64.dart';

class Bundle {
  String name;
  String headerColor;
  String headerBackgroundColor;
  String bordersColor;
  String bodyBackgroundColor;

  String url;

  List<BundleSpriteSetData> spriteSets;

  Bundle({
    this.name,
    this.headerColor,
    this.headerBackgroundColor,
    this.bordersColor,
    this.bodyBackgroundColor,
    this.spriteSets,
    this.url,
  });

  static Bundle fromMap(Map source, [String url]) => Bundle(
        name: source["name"],
        headerColor: source["header_color"],
        headerBackgroundColor: source["header_background_color"],
        bordersColor: source["borders_color"],
        bodyBackgroundColor: source["body_background_color"],
        spriteSets: (source["sprite_sets"] as List)
            .cast<Map>()
            .map(BundleSpriteSetData.fromMap)
            .toList(growable: false),
        url: url,
      );
}

class BundleSpriteSetData {
  String name;
  String displayName;
  String url;
  String color;

  BundleSpriteSetData({this.name, this.displayName, this.url, this.color});

  static BundleSpriteSetData fromMap(Map source) => BundleSpriteSetData(
        name: source["name"],
        displayName: source["display_name"],
        url: source["url"],
        color: source["color"],
      );
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
