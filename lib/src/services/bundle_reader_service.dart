import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import '../data_repr/bundle.dart';
import '../data_repr/sprite_set.dart';
import '../tools/url_json.dart';

export '../data_repr/bundle.dart' show normalizeBundleIdentifier;

class BundleReaderService {
  http.Client _client;

  BundleReaderService(this._client);

  Future<Bundle> getBundle(String url) async {
    try {
      final response = await _client.get(url);
      final parsed = loadYamlDocument(response.body);

      return Bundle.fromJson(flattenYaml(parsed), url);
    } on Bundle {
      // there are so many potential throws in this
      // that it's barely even worth trying to diagnose. TODO maybe someday
      return null;
    }
  }

  Future<SpriteSet> getSpriteSet(String bundle, String name) async {
    switch (bundle) {
      case "internal":
        switch (name) {
          case "async":
            final message =
                await window.onMessage.where((m) => m.data is String).first;
            (message.source as WindowBase).postMessage(
                "taco_party::async::${window.name}", window.origin);
            return SpriteSet.fromJson(jsonDecode(message.data));
          default:
            return SpriteSet.defaultSpriteSet;
        }
        break;
      case "permalink":
        final json = urlJson.decode(name);
        return SpriteSet.fromJson(json);
      default:
        return getSpriteSetForBundle(await getBundle(bundle), name);
    }
  }

  Future<SpriteSet> getSpriteSetForBundle(Bundle bundle, String name) async {
    BundleSpriteSetData data;
    try {
      data = bundle.spriteSets.singleWhere((d) => d.name == name);
    } on StateError {
      return null;
    }
    final response = await _client.get(data.url);
    return SpriteSet.fromJson(jsonDecode(response.body), bundle);
  }
}

// bluuuuh this is what i get for parsing yaml with a json lib...
flattenYaml(node) {
  if (node is YamlDocument) {
    return flattenYaml(node.contents);
  } else if (node is YamlScalar) {
    return node.value;
  } else if (node is YamlList) {
    return node.map(flattenYaml).toList();
  } else if (node is YamlMap) {
    return node
        .map((k, v) => MapEntry(flattenYaml(k), flattenYaml(v)))
        .cast<String, dynamic>();
  }
  return node;
}
