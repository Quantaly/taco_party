import 'dart:convert';

import 'package:archive/archive.dart';

const urlJson = UrlJsonCodec();

class UrlJsonCodec extends Codec<Object, String> {
  final encoder = const _UrlJsonEncoder();
  final decoder = const _UrlJsonDecoder();
  const UrlJsonCodec();
}

class _UrlJsonEncoder extends Converter<Object, String> {
  const _UrlJsonEncoder();

  static final zlib = ZLibEncoder();
  String convert(Object input) =>
      base64UrlEncode(zlib.encode(utf8.encode(jsonEncode(input))));
}

class _UrlJsonDecoder extends Converter<String, Object> {
  const _UrlJsonDecoder();

  static final zlib = ZLibDecoder();
  Object convert(String input) =>
      jsonDecode(utf8.decode(zlib.decodeBytes(base64Decode(input))));
}
