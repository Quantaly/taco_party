import 'dart:html';
import 'dart:math' as math;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:color/color.dart';

import '../../services/page_meta_service.dart';
import '../../sprite_set.dart';
import '../../tools/color_utils.dart';

@Component(
  selector: "tp-screens-spriteseteditor",
  templateUrl: "sprite_set_editor.html",
  styleUrls: ["sprite_set_editor.css"],
  directives: [coreDirectives, formDirectives,],
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
  String _backgroundColor;
  String get backgroundColor => _backgroundColor;

  String _foregroundColor;
  String get foregroundColor => _foregroundColor;
  set backgroundColor(String color) {
    _backgroundColor = color;
    _pageMeta.backgroundColor = color;
    _foregroundColor = augmentColor(HexColor(color.substring(1))).toCssString();
  }

  int numTacos;

  bool _soundEnabled;
  bool get soundEnabled => _soundEnabled;
  set soundEnabled(bool isEnabled) {
    _soundEnabled = isEnabled;
    if (!isEnabled) {
      soundUrl = "";
    }
  }

  String soundUrl;

  @override
  void ngOnInit() {
    _pageMeta.title = "Taco Party | Sprite Set Editor";
    copySpriteSet(SpriteSet.defaultSpriteSet);
  }
  
  void copySpriteSet(SpriteSet values) {
    maxHorzVelocity = values.maxHorzVelocity;
    minVertVelocity = values.minVertVelocity;
    maxVertVelocity = values.maxVertVelocity;
    maxAngularVelocity = values.maxAngularVelocity / 2 / math.pi * 360;
    name = values.name;
    images = values.images;
    textColor = values.textColor.toHexColor().toCssString();
    backgroundColor = values.backgroundColor.toHexColor().toCssString();
    numTacos = values.numTacos;
    soundEnabled = values.soundUrl != "" && values.soundUrl != null;
    soundUrl = values.soundUrl ?? "";
  }

  void addImage() {
    images.add(ImageData());
  }

  // necessary because Angular expressions don't like casts
  static ImageElement castToImage(Element e) => e as ImageElement;
}
