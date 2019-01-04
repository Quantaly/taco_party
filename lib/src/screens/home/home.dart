import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../bundle.dart';
import '../../components/bundle_display/bundle_display.dart';
import '../../routing.dart';
import '../../services/bundle_mass_loader_service.dart';
import '../../services/page_meta_service.dart';

@Component(
  selector: "tp-screens-home",
  templateUrl: "home.html",
  styleUrls: ["home.css"],
  directives: [
    coreDirectives,
    routerDirectives,
    BundleDisplayComponent,
  ],
)
class HomeScreenComponent implements OnInit {
  final PageMetaService _pageMeta;
  final BundleMassLoaderService _bundleLoader;

  HomeScreenComponent(this._pageMeta, this._bundleLoader);

  List<Bundle> bundles = const [];

  @override
  void ngOnInit() {
    _pageMeta
      ..backgroundColor = "yellow"
      ..title = "Taco Party";
    _bundleLoader.loadAsync().listen((list) => bundles = list);
  }

  String get defaultSpriteSetLink => Routes.stageNoArgs.toUrl();
  String get bundleManagerLink => Routes.bundleManager.toUrl();
}
