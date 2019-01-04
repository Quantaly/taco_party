import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../animation/web/web_render_controller.dart';
import '../../routing.dart';
import '../../services/bundle_reader_service.dart';
import '../../services/page_meta_service.dart';
import '../../services/subscribed_bundles_service.dart';

@Component(
  selector: "tp-screens-stage",
  templateUrl: "stage.html",
  styleUrls: ["stage.css", "filters.css"],
  directives: [coreDirectives],
)
class StageScreenComponent implements OnActivate, OnDestroy {
  @ViewChild("imageContainer")
  DivElement imageContainer;
  @ViewChild("stage")
  CanvasElement stage;

  final PageMetaService _pageMeta;
  final BundleReaderService _bundleReader;
  final SubscribedBundlesService _subscribedBundles;
  StageScreenComponent(
      this._pageMeta, this._bundleReader, this._subscribedBundles);

  String textContent = "Loading...";
  String textColor = "purple";

  WebRenderController _renderController;
  String bundle, spriteSetName;
  Map<String, String> queryParameters;

  bool get displaySubscribeControl =>
      bundle != null &&
      bundle != "internal" &&
      !_subscribedBundles.contains(bundle);

  @override
  void onActivate(_, RouterState current) async {
    // idk how angular_router works, but i do see a distinct possibility of
    // being activated twice.
    ngOnDestroy();

    bundle = Routes.getStageBundle(current.parameters) ?? "internal";
    spriteSetName = Routes.getStageSpriteSet(current.parameters) ?? "default";
    queryParameters = current.queryParameters;

    final spriteSet = await _bundleReader.getSpriteSet(bundle, spriteSetName);
    _pageMeta
      ..backgroundColor = _listToColor(spriteSet.backgroundColor)
      ..title = "Taco Party | ${spriteSet.name}";
    textColor = _listToColor(spriteSet.textColor);
    _renderController = WebRenderController(spriteSet, imageContainer, stage);
    await _renderController.load();

    print('StageScreenComponent.onActivate');
    textContent = queryParameters["msg"] ?? "";
    _renderController.start();
  }

  @override
  void ngOnDestroy() {
    _renderController?.stop();
  }

  static String _listToColor(List<int> list) =>
      "rgb(${list[0]}, ${list[1]}, ${list[2]})";
}
