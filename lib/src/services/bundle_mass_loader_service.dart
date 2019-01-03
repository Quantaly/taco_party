import 'dart:async';

import '../bundle.dart';
import 'bundle_reader_service.dart';
import 'subscribed_bundles_service.dart';

class BundleMassLoaderService {
  final BundleReaderService _bundleReader;
  final SubscribedBundlesService _bundleSubscriptions;

  BundleMassLoaderService(this._bundleReader, this._bundleSubscriptions);

  Future<List<Bundle>> loadAll() {
    return Future.wait(_bundleSubscriptions.map(_bundleReader.getBundle));
  }

  Stream<List<Bundle>> loadAsync() {
    final ret = StreamController<List<Bundle>>();
    final subs = List.from(_bundleSubscriptions);
    final list = List<Bundle>(subs.length);
    final futures = List<Future>(subs.length);
    for (var i = 0; i < subs.length; i++) {
      futures[i] = _bundleReader.getBundle(subs[i])
        ..then((bundle) {
          list[i] = bundle;
          ret.add(List.from(list));
        });
    }
    Future.wait(futures).then((_) => ret.close());
    return ret.stream;
  }
}
