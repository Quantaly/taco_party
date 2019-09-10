import 'dart:async';

import 'package:taco_party/everything.g.dart';

class BundleMassLoaderService {
  final BundleReaderService _bundleReader;
  final SubscribedBundlesService _bundleSubscriptions;

  BundleMassLoaderService(this._bundleReader, this._bundleSubscriptions);

  // this... isn't actually called anywhere.
  Future<List<Bundle>> loadAll() {
    return loadAsync().last;
  }

  // with the switch to indexedDB, the behavior here changed.
  // before, the list it returned was always the same size
  //   and filled with nulls where bundles had yet to load.
  // it works differently now. it shouldn't cause problems?
  // be on the lookout anyway.
  Stream<List<Bundle>> loadAsync() async* {
    final list = <Bundle>[];
    await for (var url in _bundleSubscriptions.getSubscriptions()) {
      list.add(await _bundleReader.getBundle(url));
      yield list.toList();
    }
  }
}
