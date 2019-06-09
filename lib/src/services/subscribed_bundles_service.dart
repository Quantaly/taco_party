import 'dart:collection';
import 'dart:convert';
import 'dart:html';

class SubscribedBundlesService with ListMixin<String> {
  static const _storageKey = "taco_party:subscribedBundles";
  static const _defaultList = [
    "https://quantaly.github.io/taco_party_official_bundle/bundle.yaml"
  ];

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
