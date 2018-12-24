/*
 supposedly, putting the RoutePaths and RouteDefinitions in the same file is a
 bad idea.

 so I guess I'm about to find out why.
*/

import 'package:angular_router/angular_router.dart';

import 'screens/home/home.template.dart' as home_template;

class Routes {
  static final home = RouteDefinition(
    routePath: RoutePaths.home,
    component: home_template.HomeScreenComponentNgFactory,
    useAsDefault: true,
  );

  static final all = [
    home,
  ];
}

class RoutePaths {
  static final home = RoutePath(path: "home");
}
