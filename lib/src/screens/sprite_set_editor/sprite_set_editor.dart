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

  SpriteSet spriteSet = SpriteSet.defaultSpriteSet;

  @override
  void ngOnInit() {
    _pageMeta
      ..backgroundColor = "yellow"
      ..title = "Taco Party | Sprite Set Editor";
  }
}
