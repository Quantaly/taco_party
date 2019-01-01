import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routing.dart';
import 'src/services/background_color_service.dart';
import 'src/services/repository_reader_service.dart';
import 'src/services/subscribed_repositories_service.dart';

@Component(
  selector: 'tp-app',
  templateUrl: 'app_component.html',
  directives: [routerDirectives],
  providers: [
    ClassProvider(BackgroundColorService),
    ClassProvider(RepositoryReaderService),
    ClassProvider(SubscribedRepositoriesService)
  ],
  exports: [Routes],
)
class AppComponent {}
