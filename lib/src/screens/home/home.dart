import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../components/bundle_display/bundle_display.dart';
import '../../bundle.dart';
import '../../routing.dart';
import '../../services/background_color_service.dart';
import '../../services/bundle_mass_loader_service.dart';

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
  final BackgroundColorService _bgColor;
  final BundleMassLoaderService _bundleLoader;

  HomeScreenComponent(this._bgColor, this._bundleLoader);

  List<Bundle> bundles = [];

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
    _bundleLoader.loadAsync().listen((list) => bundles = list);
  }

  String get bundleManagerLink => Routes.bundleManager.toUrl();
}
