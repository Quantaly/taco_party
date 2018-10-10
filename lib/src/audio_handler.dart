import 'dart:async';
import 'dart:html';
import 'dart:web_audio';

class AudioHandler {
  final AudioContext context;

  AudioBuffer _buffer;
  Future<void> _readyFuture;
  Future<void> get readyFuture => _readyFuture;

  AudioHandler(String url, int numTacos) : context = AudioContext() {
    var request = HttpRequest()
      ..open("GET", url, async: true)
      ..responseType = "arraybuffer";
    _readyFuture = request.onLoad.first.then(
        (_) async => _buffer = await context.decodeAudioData(request.response));
    request.send();
  }

  void play() {
    context.createBufferSource()
      ..buffer = _buffer
      ..connectNode(context.destination)
      ..start();
  }
}
