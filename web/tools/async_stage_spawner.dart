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

  void spawnStage(String data, [String additionalParams = ""]) {
    _messageTimer?.cancel();
    var newWindow =
        window.open("$pathToStage?type=async$additionalParams", name);
    _messageTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      try {
        newWindow.postMessage(data, window.origin);
      } on Error {
        window.alert("Please allow pop-ups, refresh, and try again.");
        t.cancel();
      }
    });
  }
}
