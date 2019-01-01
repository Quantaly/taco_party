import 'dart:convert';

import 'package:archive/archive.dart';

const _zLibAddendum = [194, 224, 128, 148]; // ascii: ┬αÇö

class StringBase64Encoder extends Converter<String, String> {
  final bool compress;
  final bool urlSafe;
  const StringBase64Encoder({this.compress = false, this.urlSafe = true});

  static final zLib = ZLibEncoder();

  @override
  String convert(String input) {
    var bytes = utf8.encode(input);
    if (compress) {
      bytes = zLib.encode(bytes)..addAll(_zLibAddendum);
    }
    if (urlSafe) {
      return base64UrlEncode(bytes);
    }
    return base64Encode(bytes);
  }

  String encode(String input) => convert(input);
}

class StringBase64Decoder extends Converter<String, String> {
  const StringBase64Decoder();

  static final zLib = ZLibDecoder();

  @override
  String convert(String input) {
    var bytes = base64Decode(input);
    if (_checkAddendum(bytes)) {
      try {
        bytes = zLib.decodeBytes(bytes);
      } on ArchiveException {}
    }
    return utf8.decode(bytes);
  }

  String decode(String input) => convert(input);
}

bool _checkAddendum(List<int> bytes) {
  if (bytes.length < 5) return false;
  final end = bytes.sublist(bytes.length - 4);
  return end[0] == _zLibAddendum[0] &&
      end[1] == _zLibAddendum[1] &&
      end[2] == _zLibAddendum[2] &&
      end[3] == _zLibAddendum[3];
}
