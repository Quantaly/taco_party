import 'dart:async';
import 'dart:html';

class AsyncStageSpawner {
  Timer _messageTimer;

  final String name;
  final String asyncStageLink;
  AsyncStageSpawner(this.name, this.asyncStageLink);

  _Status _status = _Status.initial;

  StreamSubscription<Event> _messageListener;

  void init() {
    switch (_status) {
      case _Status.initial:
        break;
      case _Status.started:
        throw StateError("init() has already been called.");
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    _status = _Status.started;
    _messageListener = window.onMessage
        .where((m) => m.data == "taco_party::async::$name")
        .listen((_) => _messageTimer?.cancel());
  }

  void spawnStage(FutureOr<String> data, [String queryString = ""]) {
    switch (_status) {
      case _Status.initial:
        throw StateError("Call init() first.");
      case _Status.started:
        break;
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    _messageTimer?.cancel();
    // this has to be done synchronously to still be inside of a user input event
    // actually maybe not, as of Dart 2
    // but I'm too lazy to rewrite it with async/await
    final newWindow = window.open("$asyncStageLink$queryString", name);
    Future.value(data).then((data) {
      if (data == null) {
        newWindow.close();
        return;
      }
      _messageTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
        newWindow.postMessage(data, window.origin);
      });
    });
  }

  void stop() {
    if (_status == _Status.stopped) {
      throw StateError("stop() has already been called.");
    }
    _status == _Status.stopped;
    _messageTimer?.cancel();
    _messageListener.cancel();
  }
}

enum _Status {
  initial,
  started,
  stopped,
}
