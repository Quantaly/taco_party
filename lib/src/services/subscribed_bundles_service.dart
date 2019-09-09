import 'dart:collection';
import 'dart:convert';
import 'dart:html';
import 'dart:indexed_db';

import 'package:angular/di.dart';

const _defaultList = [
  "https://quantaly.github.io/taco_party_official_bundle/bundle.yaml"
];

class SubscribedBundlesService {
  static const subscriptionsStoreName = "subscriptions";

  final Injector _injector;

  SubscribedBundlesService(this._injector);

  Future<_ServiceState> __stateFuture;
  Future<_ServiceState> get _stateFuture =>
      __stateFuture ?? (__stateFuture = _init());

  // within methods of this class, when you have a state, use state.blocked
  Future<bool> get blocked async => (await _stateFuture).blocked;

  Stream<String> getSubscriptions() async* {
    final state = await _stateFuture;
    if (state.blocked) {
      yield* Stream.fromIterable(_defaultList);
    } else {
      await for (var cursor in state.db
          .transaction(subscriptionsStoreName, "readonly")
          .objectStore(subscriptionsStoreName)
          .openCursor()) {
        yield cursor.value["url"];
        cursor.next();
      }
    }
  }

  Future<bool> subscribedTo(String url) async {
    final state = await _stateFuture;
    if (state.blocked) {
      return false;
    } else {
      return await state.db
              .transaction(subscriptionsStoreName, "readonly")
              .objectStore(subscriptionsStoreName)
              .getObject(url) !=
          null;
    }
  }

  Future<void> subscribe(String url) async {
    final state = await _stateFuture;
    if (!state.blocked) {
      if (!await subscribedTo(url)) {
        final subscriptionsStore = state.db
            .transaction(subscriptionsStoreName, "readwrite")
            .objectStore(subscriptionsStoreName);
        await subscriptionsStore.add({"url": url});
      }
    }
  }

  Future<void> unsubscribe(String url) async {
    final state = await _stateFuture;
    if (!state.blocked) {
      final subscriptionsStore = state.db
          .transaction(subscriptionsStoreName, "readwrite")
          .objectStore(subscriptionsStoreName);
      await subscriptionsStore.delete(url);
    }
  }

  static const _dbVersion = 1;
  Future<_ServiceState> _init() async {
    print("_init ran");
    var blocked = false;
    final db = await window.indexedDB.open(
      "taco_party",
      version: _dbVersion,
      onUpgradeNeeded: _upgradeDb,
      onBlocked: (_) {
        blocked = true;
      },
    );
    print("blocked is $blocked");
    return _ServiceState(db, blocked);
  }

  void _upgradeDb(VersionChangeEvent evt) {
    final Database db = evt.target.result;
    for (var currentVersion = evt.oldVersion;
        currentVersion < evt.newVersion;
        currentVersion++) {
      switch (currentVersion) {
        case 0:
          final subscriptionsStore =
              db.createObjectStore(subscriptionsStoreName, keyPath: "url");
          final OldSubscribedBundlesService oldService =
              _injector.get(OldSubscribedBundlesService);
          for (final url in oldService) {
            subscriptionsStore.add({"url": url});
          }
          break;
      }
    }
  }
}

class _ServiceState {
  final Database db;
  final bool blocked;
  _ServiceState(this.db, this.blocked);
}

class OldSubscribedBundlesService with ListMixin<String> {
  static const _storageKey = "taco_party:subscribedBundles";

  List<String> get _storedList {
    if (!window.localStorage.containsKey(_storageKey)) {
      _storedList = _defaultList;
      return _defaultList;
    }
    try {
      return (jsonDecode(window.localStorage[_storageKey]) as List).cast();
    } on FormatException {
      _storedList = _defaultList;
      return _defaultList;
    }
  }

  void set _storedList(List<String> list) {
    window.localStorage[_storageKey] = jsonEncode(list);
  }

  @override
  int get length => _storedList.length;

  @override
  void set length(int newLength) =>
      _storedList = _storedList..length = newLength;

  @override
  String operator [](int index) => _storedList[index];

  @override
  void operator []=(int index, String value) =>
      _storedList = _storedList..[index] = value;

  // ListMixin's docs say to override these too

  @override
  void add(String element) => _storedList = _storedList..add(element);

  @override
  void addAll(Iterable<String> iterable) =>
      _storedList = _storedList..addAll(iterable);
}
