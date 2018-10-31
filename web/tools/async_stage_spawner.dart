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

  void spawnStage(FutureOr<String> data, [String additionalParams = ""]) {
    _messageTimer?.cancel();
    // this has to be done synchronously to still be inside of a user input event
    var newWindow =
        window.open("$pathToStage?type=async$additionalParams", name);
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

  void cancelMessage() => _messageTimer.cancel();
}
