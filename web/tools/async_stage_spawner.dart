import 'dart:async';
import 'dart:html';

class AsyncStageSpawner {
  Timer _messageTimer;

  final String name;
  final String pathToStage;
  AsyncStageSpawner(this.name, this.pathToStage) {
    window.onMessage
        .where((m) => m.data == name)
        .listen((_) => _messageTimer?.cancel());
  }

  void spawnStage(String data) {
    _messageTimer?.cancel();
    var newWindow = window.open("$pathToStage?type=async", name);
    _messageTimer = Timer.periodic(const Duration(milliseconds: 100),
        (_) => newWindow.postMessage(data, window.origin));
  }
}
