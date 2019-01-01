import 'dart:html';

import 'package:angular/angular.dart';

import '../../repository.dart';
import '../../services/background_color_service.dart';
import '../../services/repository_reader_service.dart';
import '../../services/subscribed_repositories_service.dart';

@Component(
  selector: "tp-screens-repomanager",
  templateUrl: "repository_manager.html",
  styleUrls: ["repository_manager.css"],
  directives: [coreDirectives],
)
class RepositoryManagerScreenComponent implements OnInit {
  final BackgroundColorService _bgColor;
  final RepositoryReaderService _repoReader;
  final SubscribedRepositoriesService _repoSubscriptions;
  RepositoryManagerScreenComponent(
      this._bgColor, this._repoReader, this._repoSubscriptions);

  Repository subscribeTo;
  bool canSubscribe;

  int _lastFindRepositoryCall = 0;
  void findRepository(String identifier) async {
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

  List<Repository> subscriptions;

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
    loadSubscriptions();
  }

  Future<void> loadSubscriptions() async {
    subscriptions =
        await Future.wait(_repoSubscriptions.map(_repoReader.getRepository));
  }
}
