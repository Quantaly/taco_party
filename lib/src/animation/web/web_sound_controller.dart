import 'dart:typed_data';
import 'dart:web_audio';

import 'package:http/http.dart' as http;

import 'package:taco_party/everything.g.dart';

class WebSoundController implements SoundController {
  String _url;

  WebSoundController(this._url);

  _Status _status = _Status.initial;

  AudioContext _audioContext;
  Uint8List _bufferBytes;
  AudioBuffer _buffer;

  @override
  Future<bool> load() async {
    switch (_status) {
      case _Status.initial:
        break;
      case _Status.loading:
      case _Status.loaded:
      case _Status.started:
        throw StateError("load() has already been called.");
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    _status = _Status.loading;
    final response = await http.get(_url);
    if (!response.headers["content-type"].startsWith("audio")) {
      _status = _Status.stopped;
      return false;
    }
    _bufferBytes = response.bodyBytes;
    _status = _Status.loaded;
    return true;
  }

  @override
  void playSound([_]) {
    switch (_status) {
      case _Status.initial:
      case _Status.loading:
      case _Status.loaded:
        throw StateError("start() has not yet been called.");
      case _Status.started:
        break;
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    if (_buffer == null) return;
    _audioContext.createBufferSource()
      ..buffer = _buffer
      ..connectNode(_audioContext.destination)
      ..start();
  }

  @override
  void start() {
    switch (_status) {
      case _Status.initial:
        throw StateError("Call load() and wait for it to complete first.");
      case _Status.loading:
        throw StateError("Wait for load() to complete first.");
      case _Status.loaded:
        break;
      case _Status.started:
        throw StateError("start() has already been called.");
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    _status = _Status.started;
    _audioContext = AudioContext()
      ..decodeAudioData(_bufferBytes.buffer).then((b) => _buffer = b);
  }

  @override
  void stop() {
    if (_status == _Status.stopped) throw StateError("Already stopped.");
    _status = _Status.stopped;
    _audioContext?.close();
  }
}

enum _Status {
  initial,
  loading,
  loaded,
  started,
  stopped,
}
