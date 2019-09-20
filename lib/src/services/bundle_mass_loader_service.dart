import 'dart:async';

import 'package:taco_party/everything.g.dart';

class BundleMassLoaderService {
  final BundleReaderService _bundleReader;
  final SubscribedBundlesService _bundleSubscriptions;

  BundleMassLoaderService(this._bundleReader, this._bundleSubscriptions);

  // this... isn't actually called anywhere.
  Future<List<Bundle>> loadAll() =>
      loadAsync().last.then((state) => state.loaded);

  Stream<BundleLoadingState> loadAsync() {
    final ret = StreamController<BundleLoadingState>();
    final loaded = <Bundle>[];
    ret.add(BundleLoadingState([], {}));
    _bundleSubscriptions.getSubscriptions().toSet().then((pending) {
      ret.add(BundleLoadingState([], pending));
      for (var url in pending) {
        _bundleReader.getBundle(url).then((bundle) {
          loaded.add(bundle);
          pending.remove(url);
          ret.add(BundleLoadingState(loaded, pending));
          if (pending.isEmpty) {
            ret.close();
          }
        });
      }
    });
    return ret.stream;
  }
}

class BundleLoadingState {
  final List<Bundle> loaded;
  final Set<String> pending;

  BundleLoadingState(this.loaded, this.pending);
}
