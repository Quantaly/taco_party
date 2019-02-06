import 'dart:html' hide Location;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../components/bundle_display/bundle_display.dart';
import '../../data_repr/bundle.dart';
import '../../routing.dart';
import '../../services/bundle_mass_loader_service.dart';
import '../../services/page_meta_service.dart';
import '../../tools/async_stage_spawner.dart';
import '../../tools/query_string.dart';

@Component(
  selector: "tp-screens-home",
  templateUrl: "home.html",
  styleUrls: ["home.css"],
  directives: [
    coreDirectives,
    formDirectives,
    routerDirectives,
    BundleDisplayComponent,
  ],
)
class HomeScreenComponent implements OnInit, OnDestroy {
  final PageMetaService _pageMeta;
  final BundleMassLoaderService _bundleLoader;
  final Location _location;

  HomeScreenComponent(this._pageMeta, this._bundleLoader, this._location);

  List<Bundle> bundles = const [];

  AsyncStageSpawner _stageSpawner;

  @override
  void ngOnInit() {
    _pageMeta
      ..backgroundColor = "yellow"
      ..title = "Taco Party";
    _bundleLoader.loadAsync().listen((list) => bundles = list);
    _stageSpawner = AsyncStageSpawner("_blank",
        _location.prepareExternalUrl(Routes.stageLink("internal", "async")))
      ..init();
  }

  String get defaultSpriteSetLink => Routes.stageNoArgs.toUrl() + queryString;
  final String spriteSetEditorLink = Routes.spriteSetEditor.toUrl();
  final String bundleManagerLink = Routes.bundleManager.toUrl();

  String message;
  String filter;
  String backgroundOpacity;
  String get queryString => makeQueryString({
        "msg": message,
        "filter": filter,
        "bgOpacity": backgroundOpacity,
      }..removeWhere((k, v) => v == "" || v == null));

  String fileData;
  void processJsonImport(File inputFile) async {
    final reader = FileReader();
    reader.readAsText(inputFile);
    await reader.onLoadEnd.first;
    fileData = reader.result;
  }

  void openFile() {
    if (fileData == null) return;
    _stageSpawner.spawnStage(fileData, queryString);
  }

  @override
  void ngOnDestroy() {
    _stageSpawner.stop();
  }
}
