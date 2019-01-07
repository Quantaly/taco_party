import 'dart:math' as math;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../services/page_meta_service.dart';
import '../../sprite_set.dart';

@Component(
  selector: "tp-screens-spriteseteditor",
  templateUrl: "sprite_set_editor.html",
  styleUrls: ["sprite_set_editor.css"],
  directives: [formDirectives],
)
class SpriteSetEditorScreenComponent implements OnInit {
  final PageMetaService _pageMeta;
  SpriteSetEditorScreenComponent(this._pageMeta);

  num maxHorzVelocity;
  num minVertVelocity;
  num maxVertVelocity;
  num maxAngularVelocity;

  String name;

  List<ImageData> images;

  String textColor;
  String backgroundColor;

  int numTacos;

  bool soundEnabled;
  String soundUrl;

  @override
  void ngOnInit() {
    _pageMeta
      ..backgroundColor = "yellow"
      ..title = "Taco Party | Sprite Set Editor";

    final defValues = SpriteSet.defaultSpriteSet;

    maxHorzVelocity = defValues.maxHorzVelocity;
    minVertVelocity = defValues.minVertVelocity;
    maxVertVelocity = defValues.maxVertVelocity;
    maxAngularVelocity = defValues.maxAngularVelocity / 2 / math.pi * 360;
    name = defValues.name;
    images = defValues.images;
    textColor = defValues.textColor.toHexColor().toCssString();
    backgroundColor = defValues.backgroundColor.toHexColor().toCssString();
    numTacos = defValues.numTacos;
    soundEnabled = false;
    soundUrl = "";
  }
}
