import 'dart:async';

import '../repository.dart';
import 'repository_reader_service.dart';
import 'subscribed_repositories_service.dart';

class RepositoryMassLoaderService {
  final RepositoryReaderService _repoReader;
  final SubscribedRepositoriesService _repoSubscriptions;

  RepositoryMassLoaderService(this._repoReader, this._repoSubscriptions);

  Future<List<Repository>> load() {
    return Future.wait(_repoSubscriptions.map(_repoReader.getRepository));
  }

  Stream<List<Repository>> loadAsync() {
    final ret = StreamController<List<Repository>>();
    final subs = List.from(_repoSubscriptions);
    final list = List<Repository>(subs.length);

    for (var i = 0; i < subs.length; i++) {
      _repoReader.getRepository(subs[i]).then((repo) {
        list[i] = repo;
        ret.add(List.from(list));
      });
    }

    return ret.stream;
  }
}
