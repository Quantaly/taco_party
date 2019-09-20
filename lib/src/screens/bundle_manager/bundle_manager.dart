import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:stream_transform/stream_transform.dart' show debounce;

import 'package:taco_party/everything.g.dart';

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
  bool loading = false;
  bool working = false;

  int _lastFindBundleCall = 0;
  StreamController<String> findBundleController;
  void _findBundle(String identifier) async {
    final thisCall = ++_lastFindBundleCall;
    try {
      identifier = normalizeBundleIdentifier(identifier);
      final bundle = await _bundleReader.getBundle(identifier);
      final subscribed = await _bundleSubscriptions.subscribedTo(identifier);
      if (_lastFindBundleCall == thisCall &&
          !specialBundleNames.contains(identifier)) {
        subscribeTo = bundle;
        canSubscribe = !subscribed;
      }
    } on FormatException {
      subscribeTo = null;
    }
  }

  Future<void> subscribe(InputElement input) async {
    working = true;
    await _bundleSubscriptions.subscribe(input.value);
    input.value = "";
    subscribeTo = null;
    canSubscribe = false;
    working = false;
    loadSubscriptions();
  }

  void unsubscribe(String url) async {
    _bundleSubscriptions.unsubscribe(url);
    loadSubscriptions();
  }

  BundleLoadingState bundleState = BundleLoadingState([], {});

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

  StreamSubscription<BundleLoadingState> _lastLoad;
  Future<void> loadSubscriptions() async {
    _lastLoad?.cancel();
    _lastLoad =
        _bundleLoader.loadAsync().listen((state) => bundleState = state);
  }

  void pruneBroken() async {
    if (bundleState.pending.isEmpty) return;
    final confirmMsg = StringBuffer(
        "The following URLs have not successfully loaded yet, and are assumed "
        "to be broken:\n\n");
    for (var sub in bundleState.pending) {
      confirmMsg.writeln(sub);
    }
    confirmMsg.writeln(
        "\nIf you know one or more of these loads slowly, give it some more "
        "time or make sure you have the URL copied down to resubscribe.");
    confirmMsg.writeln("\nDelete these subscriptions?");
    if (window.confirm(confirmMsg.toString())) {
      final futures = <Future<void>>[];
      for (var sub in bundleState.pending) {
        futures.add(_bundleSubscriptions.unsubscribe(sub));
      }
      await Future.wait(futures);
      loadSubscriptions();
    }
  }
}
