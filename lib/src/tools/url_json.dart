import 'dart:convert';

import 'string_base64.dart';

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

  static const stringBase64 = StringBase64Encoder(compress: true);

  @override
  String convert(Object input) => stringBase64.encode(jsonEncode(input));
}

class _UrlJsonDecoder extends Converter<String, Object> {
  const _UrlJsonDecoder();

  static const stringBase64 = StringBase64Decoder();

  @override
  Object convert(String input) => jsonDecode(stringBase64.decode(input));
}
