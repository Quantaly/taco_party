import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

import '../repository.dart';
import '../sprite_set.dart';
import '../tools/url_json.dart';

class RepositoryReaderService {
  http.Client _client;

  RepositoryReaderService(this._client);

  Future<Repository> getRepository(String url) async {
    try {
      final response = await _client.get(url);
      final parsed = loadYamlDocument(response.body);

      return Repository.fromMap(parsed.contents as YamlMap);
    } on Object {
      // there are so many potential throws in this
      // that it's barely even worth trying to diagnose. TODO maybe someday
      return null;
    }
  }

  Future<SpriteSet> getSpriteSet(String repository, String name) async {
    switch (repository) {
      case "default":
        switch (name) {
          // a little bit unnecessary, but communicates the intent here well
          case "tacos":
          default:
            return SpriteSet.defaultSpriteSet;
        }
        break;
      case "permalink":
        final json = urlJson.decode(name);
        return SpriteSet.fromMap(json);
      default:
        return getSpriteSetForRepository(await getRepository(repository), name);
    }
  }

  Future<SpriteSet> getSpriteSetForRepository(
      Repository repository, String name) async {
    RepositorySpriteSetData data;
    try {
      data = repository.spriteSets.singleWhere((d) => d.name == name);
    } on StateError {
      return null;
    }
    final response = await _client.get(data.url);
    return SpriteSet.fromMap(jsonDecode(response.body));
  }
}
