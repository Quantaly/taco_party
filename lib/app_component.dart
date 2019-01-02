import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routing.dart';
import 'src/services/background_color_service.dart';
import 'src/services/bundle_mass_loader_service.dart';
import 'src/services/bundle_reader_service.dart';
import 'src/services/subscribed_bundles_service.dart';

@Component(
  selector: 'tp-app',
  templateUrl: 'app_component.html',
  directives: [routerDirectives],
  providers: [
    ClassProvider(BackgroundColorService),
    ClassProvider(BundleMassLoaderService),
    ClassProvider(BundleReaderService),
    ClassProvider(SubscribedBundlesService),
  ],
  exports: [Routes],
)
class AppComponent {}
