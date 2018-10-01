import 'dart:html';

final List<AnchorElement> links = [];

InputElement msg;
SelectElement filter;

void main() {
  links.addAll(querySelectorAll(".stagelink"));

  msg = querySelector("#msg")..onInput.listen(go);
  filter = querySelector("#filter")..onInput.listen(go);

  go();
}

void updateHref(AnchorElement element) {
  var first = true;
  String sep() {
    if (first) {
      first = false;
      return "?";
    }
    return "&";
  }

  var builder = StringBuffer("stage.html");
  if (element.id != "default") builder.write("${sep()}type=${element.id}");
  if (msg.value.isNotEmpty)
    builder.write("${sep()}msg=${Uri.encodeComponent(msg.value)}");
  if (filter.value.isNotEmpty)
    builder.write("${sep()}filter=${Uri.encodeComponent(filter.value)}");
  element.href = builder.toString();
}

void go([_]) => links.forEach(updateHref);
