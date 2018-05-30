import 'dart:html';
import 'package:taco_party/taco_party.dart';

void main() {
  print("${window.innerWidth} x ${window.innerHeight}");
  querySelector("#text").text = Uri.base.queryParameters["msg"];
  new AnimationHandler().start();
}