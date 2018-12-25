import 'dart:convert';

import 'package:archive/archive.dart';

const urlJson = UrlJsonCodec();

class UrlJsonCodec extends Codec<Object, String> {
  @override
  final encoder = const _UrlJsonEncoder();

  @override
  final decoder = const _UrlJsonDecoder();

  const UrlJsonCodec();
}

class _UrlJsonEncoder extends Converter<Object, String> {
  const _UrlJsonEncoder();

  static final zLib = ZLibEncoder();

  @override
  String convert(Object input) =>
      base64UrlEncode(zLib.encode(utf8.encode(jsonEncode(input))));
}

class _UrlJsonDecoder extends Converter<String, Object> {
  const _UrlJsonDecoder();

  static final zLib = ZLibDecoder();

  @override
  Object convert(String input) =>
      jsonDecode(utf8.decode(zLib.decodeBytes(base64Decode(input))));
}
