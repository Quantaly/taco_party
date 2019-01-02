import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:stream_transform/stream_transform.dart' show debounce;

import '../../repository.dart';
import '../../services/background_color_service.dart';
import '../../services/repository_mass_loader_service.dart';
import '../../services/repository_reader_service.dart';
import '../../services/subscribed_repositories_service.dart';

@Component(
  selector: "tp-screens-repomanager",
  templateUrl: "repository_manager.html",
  styleUrls: ["repository_manager.css"],
  directives: [coreDirectives],
)
class RepositoryManagerScreenComponent implements OnInit, OnDestroy {
  final BackgroundColorService _bgColor;
  final RepositoryMassLoaderService _repoLoader;
  final RepositoryReaderService _repoReader;
  final SubscribedRepositoriesService _repoSubscriptions;
  RepositoryManagerScreenComponent(this._bgColor, this._repoLoader,
      this._repoReader, this._repoSubscriptions);

  Repository subscribeTo;
  bool canSubscribe;

  int _lastFindRepositoryCall = 0;
  StreamController<String> findRepositoryController;
  void _findRepository(String identifier) async {
    final thisCall = ++_lastFindRepositoryCall;
    try {
      identifier = normalizeRepositoryIdentifier(identifier);
      final repo = await _repoReader.getRepository(identifier);
      if (_lastFindRepositoryCall == thisCall) {
        subscribeTo = repo;
        canSubscribe = !_repoSubscriptions.contains(identifier);
      }
    } on FormatException {
      subscribeTo = null;
    }
  }

  void subscribe(InputElement input) {
    _repoSubscriptions.add(input.value);
    input.value = "";
    subscribeTo = null;
    canSubscribe = false;
    loadSubscriptions();
  }

  void unsubscribe(int index) {
    _repoSubscriptions.removeAt(index);
    loadSubscriptions();
  }

  List<Repository> subscriptions = [];

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
    findRepositoryController = StreamController()
      ..stream
          .transform(debounce(const Duration(milliseconds: 300)))
          .listen(_findRepository);
    loadSubscriptions();
  }

  @override
  void ngOnDestroy() {
    findRepositoryController.close();
  }

  StreamSubscription _lastLoad;
  Future<void> loadSubscriptions() async {
    _lastLoad?.cancel();
    _lastLoad = _repoLoader.loadAsync().listen((list) => subscriptions = list);
  }
}
