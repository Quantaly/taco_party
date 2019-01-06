String makeQueryString(Map<String, Object> queryParameters) {
  final entries = queryParameters.entries.toList(growable: false);
  if (entries.isEmpty) return "";
  final retBuffer = StringBuffer("?");
  for (var entry in entries) {
    retBuffer.write("${Uri.encodeQueryComponent(entry.key)}="
        "${Uri.encodeQueryComponent(entry.value.toString())}&");
  }
  final ret = retBuffer.toString();
  return ret.substring(0, ret.length - 1);
}
