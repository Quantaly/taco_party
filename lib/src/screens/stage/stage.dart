import 'dart:html';

import 'package:angular/angular.dart';

import '../../animation/web/web_render_controller.dart';
import '../../services/background_color_service.dart';
import '../../services/bundle_reader_service.dart';
import '../../services/subscribed_bundles_service.dart';
import '../../sprite_set.dart';

@Component(
  selector: "tp-screens-stage",
  templateUrl: "stage.html",
  styleUrls: ["stage.css", "filters.css"],
)
class StageScreenComponent implements AfterViewInit, OnDestroy {
  @ViewChild("imageContainer")
  DivElement imageContainer;
  @ViewChild("stage")
  CanvasElement stage;

  final BackgroundColorService _bgColor;
  final BundleReaderService _bundleReader;
  final SubscribedBundlesService _subscribedBundles;
  StageScreenComponent(
      this._bgColor, this._bundleReader, this._subscribedBundles);

  String textContent = "Loading...";
  WebRenderController _renderController;

  @override
  void ngAfterViewInit() {
    _bgColor.backgroundColor = "yellow";
    _renderController =
        WebRenderController(SpriteSet.defaultSpriteSet, imageContainer, stage);
    _renderController.load().then(onReady);
  }

  void onReady([_]) {
    textContent = "";
    _renderController.start();
  }

  @override
  void ngOnDestroy() {
    _renderController?.stop();
  }
}
