import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../animation/web/web_render_controller.dart';
import '../../routing.dart';
import '../../services/bundle_reader_service.dart';
import '../../services/page_meta_service.dart';
import '../../services/subscribed_bundles_service.dart';
import '../../tools/color_utils.dart';

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
  String controlPanelColor = "#ffff80";

  WebRenderController _renderController;
  String bundle, spriteSetName, bundleName;
  Map<String, String> queryParameters;
  Filters filters = const Filters([]);

  bool displaySubscribeControl = false;

  bool soundControlDismissed = false;
  bool get displaySoundControl =>
      !soundControlDismissed && (_renderController?.soundReady ?? false);

  bool get displayControls => displaySubscribeControl || displaySoundControl;

  @override
  void onActivate(_, RouterState current) async {
    // idk how angular_router works, but i do see a distinct possibility of
    // being activated twice.
    ngOnDestroy();

    try {
      bundle = Routes.getStageBundle(current.parameters);
      spriteSetName = Routes.getStageSpriteSet(current.parameters);
    } on Error {
      // the parameters weren't there
      // it *says* it's a TypeError, but I don't catch it when I specify
      bundle = "internal";
      spriteSetName = "default";
    }
    queryParameters = current.queryParameters;

    final spriteSet = await _bundleReader.getSpriteSet(bundle, spriteSetName);
    if (spriteSet.bundle != null) {
      bundleName = spriteSet.bundle.name;
    }
    textColor = _listToColor(spriteSet.textColor);
    controlPanelColor = augmentColor(spriteSet.backgroundColor);
    _pageMeta
      ..backgroundColor = _listToColor(spriteSet.backgroundColor)
      ..title = "Taco Party | ${spriteSet.name}";
    _renderController = WebRenderController(spriteSet, imageContainer, stage);
    await _renderController.load();

    textContent = queryParameters["msg"] ?? "";
    try {
      filters = Filters(queryParameters["filter"].split(","));
    } on Error {}

    if (bundle != "internal" &&
        bundle != "permalink" &&
        !_subscribedBundles.contains(bundle)) {
      displaySubscribeControl = true;
    }

    _renderController.start();
  }

  void subscribeToCurrentBundle() {
    displaySubscribeControl = false;
    if (bundle == null ||
        bundle == "internal" ||
        bundle == "permalink" ||
        _subscribedBundles.contains(bundle)) return;
    _subscribedBundles.add(bundle);
  }

  void startSound() => _renderController.startSound();

  @override
  void ngOnDestroy() {
    _renderController?.stop();
  }

  static String _listToColor(List<int> list) =>
      "rgb(${list[0]}, ${list[1]}, ${list[2]})";
}

class Filters {
  final List<String> filters;
  const Filters(this.filters);

  bool operator [](String name) => filters.contains(name);
}
