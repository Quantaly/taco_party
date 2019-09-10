import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:taco_party/everything.g.dart';

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
  final FontLoaderService _fontLoader;
  StageScreenComponent(this._pageMeta, this._bundleReader,
      this._subscribedBundles, this._fontLoader);

  String textContent = "Loading...";
  String textColor = "purple";
  String textFontFamily;
  String controlPanelColor = "#ffff80";

  WebRenderController _renderController;
  String bundleUrl, spriteSetName, bundleName;
  Map<String, String> queryParameters;
  Filters filters = const Filters({});

  bool displaySubscribeControl = false;

  bool soundControlDismissed = false;
  bool get displaySoundControl =>
      !soundControlDismissed && (_renderController?.soundReady ?? false);

  bool fontLoading = false;
  bool fontError = false;
  bool fontNoticeDismissed = false;
  bool get displayFontLoading => fontLoading && !fontNoticeDismissed;
  bool get displayFontError => fontError && !fontNoticeDismissed;

  bool get displayControls =>
      displaySubscribeControl ||
      displaySoundControl ||
      displayFontLoading ||
      displayFontError;

  @override
  void onActivate(_, RouterState current) async {
    // idk how angular_router works, but i do see a distinct possibility of
    // being activated twice.
    ngOnDestroy();

    try {
      bundleUrl = Routes.getStageBundle(current.parameters);
      spriteSetName = Routes.getStageSpriteSet(current.parameters);
    } on Error {
      // the parameters weren't there
      // it *says* it's a TypeError, but I don't catch it when I specify
      bundleUrl = "internal";
      spriteSetName = "default";
    }
    queryParameters = current.queryParameters;

    final spriteSet = await _bundleReader.getSpriteSet(bundleUrl, spriteSetName);
    if (spriteSet.bundle != null) {
      bundleName = spriteSet.bundle.name;
    }
    textColor = spriteSet.textColor.toHexColor().toCssString();
    controlPanelColor = augmentColor(spriteSet.backgroundColor).toCssString();
    _pageMeta
      ..backgroundColor = spriteSet.backgroundColor.toHexColor().toCssString()
      ..title = "Taco Party | ${spriteSet.name}";

    var backgroundOpacity = 1.0;
    try {
      backgroundOpacity = num.parse(queryParameters["bgOpacity"]);
    } on Object {}

    _renderController = WebRenderController(
        spriteSet, imageContainer, stage, backgroundOpacity);
    await _renderController.load();

    textContent = queryParameters["msg"] ?? "";
    if (textContent.isNotEmpty) {
      if (spriteSet.font != null) {
        textFontFamily = "${spriteSet.font.name}, Sarabun, sans-serif";
        if (spriteSet.font.googleFontsImport) {
          fontLoading = true;
          _fontLoader.loadFont(spriteSet.font.name).then((_) {
            fontLoading = false;
          }).catchError((_) {
            fontLoading = false;
            fontError = true;
          });
        }
      }
    }

    try {
      filters = Filters(queryParameters["filter"].split(",").toSet());
    } on Error {}

    Future(() async {
      if (spriteSet.bundle != null &&
          !await _subscribedBundles.subscribedTo(bundleUrl) &&
          (spriteSet.bundle.promptSubscribe ?? true)) {
        displaySubscribeControl = true;
      }

      _renderController.start();
    });
  }

  void subscribeToCurrentBundle() {
    displaySubscribeControl = false;
    if (bundleUrl == null || specialBundleNames.contains(bundleUrl)) return;
    _subscribedBundles.subscribe(bundleUrl);
  }

  void startSound() => _renderController.startSound();

  @override
  void ngOnDestroy() {
    _renderController?.stop();
  }
}

class Filters {
  final Set<String> filters;
  const Filters(this.filters);

  bool operator [](String name) => filters.contains(name);
}
