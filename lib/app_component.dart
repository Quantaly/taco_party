import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:taco_party/everything.g.dart';

@Component(
  selector: 'tp-app',
  templateUrl: 'app_component.html',
  directives: [routerDirectives],
  providers: [
    ClassProvider(PageMetaService),
    ClassProvider(BundleMassLoaderService),
    ClassProvider(BundleReaderService),
    ClassProvider(SubscribedBundlesService),
  ],
  exports: [Routes],
)
class AppComponent {}
