import 'package:angular_router/angular_router.dart';

import 'screens/home/home.template.dart' as home_template;
import 'screens/repository_manager/repository_manager.template.dart'
    as repository_manager_template;

/*
 supposedly, putting the RoutePaths and RouteDefinitions in the same file is a
 bad idea.

 so I guess I'm about to find out why.
*/

class Routes {
  static final home = RouteDefinition(
    path: "home",
    component: home_template.HomeScreenComponentNgFactory,
    useAsDefault: true,
  );

  static final repositoryManager = RouteDefinition(
    path: "tools/repository_manager",
    component:
        repository_manager_template.RepositoryManagerScreenComponentNgFactory,
  );

  static final all = [
    home,
    repositoryManager,
  ];
}
