/// This is a separate script because it turns out package:build doesn't
/// like having to figure out for itself what files other files are importing.
///
/// Run with `pub run tools/generate_exports.dart` before invoking any webdev
/// commands. Or while webdev is running and you notice errors from not having
/// the right imports. Really just run it whenever.
library generate_exports;

import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;

// TODO: a "watch" mode for active development
void main() async {
  final lib = Directory("lib").absolute;
  if (!await lib.exists()) {
    print("plz run from package root :)");
  }

  final files = <String>[];
  await for (var fse in lib.list(recursive: true)) {
    if (fse is File &&
        fse.path.endsWith(".dart") &&
        !fse.path.endsWith(".g.dart")) {
      // assume for now that only generated files are parts-of
      // and start crying if that ever becomes not the case
      // because package:analyzer sucks
      files.add(path
          .relative(fse.path, from: lib.path)
          // sup windows
          .replaceAll("\\", "/"));
    }
  }
  files.sort();

  final output = StringBuffer();
  for (var file in files) {
    output.writeln("export '$file';");
  }

  final outputFile = File(path.join(lib.path, "everything.g.dart"));
  await outputFile.writeAsString(
      DartFormatter(fixes: StyleFix.all).format(output.toString()));
}
