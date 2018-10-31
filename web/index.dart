import 'dart:convert';
import 'dart:html';

import 'tools/async_stage_spawner.dart';

final List<AnchorElement> links = [];

InputElement msg;
SelectElement filter;

InputElement upload;
InputElement uploadBtn;

void main() {
  links.addAll(querySelectorAll(".stagelink"));

  msg = querySelector("#msg")..onInput.listen(updateHrefs);
  filter = querySelector("#filter")..onInput.listen(updateHrefs);

  updateHrefs();

  var stageSpawner = AsyncStageSpawner("uploaded", "stage.html");
  upload = querySelector("#upload")
    ..onInput.listen((_) => uploadBtn.disabled = false);
  uploadBtn = querySelector("#uploadBtn")
    ..onClick.listen((_) {
      var reader = FileReader();
      reader.readAsText(upload.files.first);
      stageSpawner.spawnStage(reader.onLoadEnd.first.then((_) {
        Map<String, dynamic> fileData;
        try {
          fileData = jsonDecode(reader.result);
        } on FormatException {
          window.alert("Invalid file.");
          return null;
        }
        if (fileData["class"] != "general") {
          window.alert("Invalid file.");
          return null;
        }
        return jsonEncode(fileData["data"]);
      }), buildParameters());
    });
}

String buildParameters() {
  var builder = StringBuffer();
  if (msg.value.isNotEmpty)
    builder.write("&msg=${Uri.encodeComponent(msg.value)}");
  if (filter.value.isNotEmpty)
    builder.write(
        "&filter=${Uri.encodeComponent(filter.selectedOptions.map((o) => o.value).join(","))}");
  return builder.toString();
}

void updateHrefs([_]) {
  for (var a in links) {
    if (a.id == "default") {
      var params = buildParameters();
      if (params.isEmpty) {
        a.href = "stage.html";
      } else {
        a.href = "stage.html?${params.substring(1)}";
      }
    } else {
      a.href = "stage.html?type=${a.id}${buildParameters()}";
    }
  }
}
