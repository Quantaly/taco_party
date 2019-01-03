class ParseException implements Exception {
  String message;
  ParseException([String message]);

  @override
  String toString() => "ParseException: $message";
}
