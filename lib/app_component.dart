import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routing.dart';
import 'src/services/background_color_service.dart';

@Component(
  selector: 'tp-app',
  templateUrl: 'app_component.html',
  directives: [routerDirectives],
  providers: [ClassProvider(BackgroundColorService)],
  exports: [Routes],
)
class AppComponent {}
