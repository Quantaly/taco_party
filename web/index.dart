import 'dart:html';

final List<AnchorElement> links = [];

InputElement input;

void main() {
  input = querySelector("#msg") as InputElement;
  print(input);
  links.addAll(querySelectorAll(".stagelink"));
  input.onInput.listen((_) => links.forEach(updateHref));
  links.forEach(updateHref);
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
  if (input.value.isNotEmpty)
    builder.write("${sep()}msg=${Uri.encodeComponent(input.value)}");
  element.href = builder.toString();
}
