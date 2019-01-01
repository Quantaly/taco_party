import 'tools/string_base64.dart';

class Repository {
  String name;
  String headerColor;
  String headerBackgroundColor;
  String bordersColor;
  String bodyBackgroundColor;

  List<RepositorySpriteSetData> spriteSets;

  Repository(
      {this.name,
      this.headerColor,
      this.headerBackgroundColor,
      this.bordersColor,
      this.bodyBackgroundColor,
      this.spriteSets});

  static Repository fromMap(Map source) => Repository(
        name: source["name"],
        headerColor: source["header_color"],
        headerBackgroundColor: source["header_background_color"],
        bordersColor: source["borders_color"],
        bodyBackgroundColor: source["body_background_color"],
        spriteSets: (source["sprite_sets"] as List)
            .cast<Map>()
            .map(RepositorySpriteSetData.fromMap)
            .toList(growable: false),
      );
}

class RepositorySpriteSetData {
  String name;
  String displayName;
  String url;
  String color;

  RepositorySpriteSetData({this.name, this.displayName, this.url, this.color});

  static RepositorySpriteSetData fromMap(Map source) => RepositorySpriteSetData(
        name: source["name"],
        displayName: source["display_name"],
        url: source["url"],
        color: source["color"],
      );
}

const stringBase64Decoder = StringBase64Decoder();
String normalizeRepositoryIdentifier(String identifier) {
  if (identifier.startsWith(RegExp("https?:\\/\\/"))) return identifier;
  try {
    final ret = stringBase64Decoder.decode(identifier);
    if (!ret.startsWith(RegExp("https?:\\/\\/"))) throw FormatException();
    return ret;
  } on FormatException {
    throw FormatException("Malformed repository identifier");
  }
}
