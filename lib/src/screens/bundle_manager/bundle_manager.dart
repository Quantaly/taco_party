import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:stream_transform/stream_transform.dart' show debounce;

import '../../data_repr/bundle.dart';
import '../../services/bundle_mass_loader_service.dart';
import '../../services/bundle_reader_service.dart';
import '../../services/page_meta_service.dart';
import '../../services/subscribed_bundles_service.dart';
import '../../tools/range.dart';

@Component(
  selector: "tp-screens-bundlemanager",
  templateUrl: "bundle_manager.html",
  styleUrls: ["bundle_manager.css"],
  directives: [coreDirectives],
)
class BundleManagerScreenComponent implements OnInit, OnDestroy {
  final PageMetaService _pageMeta;
  final BundleMassLoaderService _bundleLoader;
  final BundleReaderService _bundleReader;
  final SubscribedBundlesService _bundleSubscriptions;
  BundleManagerScreenComponent(this._pageMeta, this._bundleLoader,
      this._bundleReader, this._bundleSubscriptions);

  Bundle subscribeTo;
  bool canSubscribe;

  int _lastFindBundleCall = 0;
  StreamController<String> findBundleController;
  void _findBundle(String identifier) async {
    final thisCall = ++_lastFindBundleCall;
    try {
      identifier = normalizeBundleIdentifier(identifier);
      final bundle = await _bundleReader.getBundle(identifier);
      if (_lastFindBundleCall == thisCall) {
        subscribeTo = bundle;
        canSubscribe = !_bundleSubscriptions.contains(identifier);
      }
    } on FormatException {
      subscribeTo = null;
    }
  }

  void subscribe(InputElement input) {
    _bundleSubscriptions.add(input.value);
    input.value = "";
    subscribeTo = null;
    canSubscribe = false;
    loadSubscriptions();
  }

  void unsubscribe(int index) {
    _bundleSubscriptions.removeAt(index);
    loadSubscriptions();
  }

  List<Bundle> subscriptions = const [];

  @override
  void ngOnInit() {
    _pageMeta
      ..backgroundColor = "yellow"
      ..title = "Taco Party | Bundle Manager";
    findBundleController = StreamController()
      ..stream
          .transform(debounce(const Duration(milliseconds: 300)))
          .listen(_findBundle);
    loadSubscriptions();
  }

  @override
  void ngOnDestroy() {
    findBundleController.close();
  }

  StreamSubscription _lastLoad;
  Future<void> loadSubscriptions() async {
    _lastLoad?.cancel();
    subscriptions = const [];
    _lastLoad =
        _bundleLoader.loadAsync().listen((list) => subscriptions = list);
  }

  void pruneBroken() async {
    if (subscriptions.length < 1) return;
    final broken = <int>[];
    final subUrls = List<String>.from(_bundleSubscriptions);
    for (var i in range(subUrls.length)) {
      if (subscriptions[i] == null) {
        broken.add(i);
      }
    }
    final confirmMsg = StringBuffer(
        "The following URLs have not successfully loaded yet, and are assumed "
        "to be broken:\n\n");
    for (var i in broken) {
      confirmMsg.writeln(subUrls[i]);
    }
    confirmMsg.writeln(
        "\nIf you know one or more of these loads slowly, give it some more "
        "time or make sure you have the URL copied down to resubscribe.");
    confirmMsg.writeln("\nDelete these subscriptions?");
    if (window.confirm(confirmMsg.toString())) {
      for (var i in broken) {
        _bundleSubscriptions.removeAt(i);
      }
      loadSubscriptions();
    }
  }
}
