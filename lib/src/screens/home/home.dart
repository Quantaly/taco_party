import 'dart:html' hide Location;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:taco_party/everything.g.dart';

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
    _bundleLoader.loadAsync().listen((state) => bundles = state.loaded);
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

  void onFilterInput(SelectElement filterInput) {
    filter = filterInput.selectedOptions.map((sel) => sel.value).join(",");
  }

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
