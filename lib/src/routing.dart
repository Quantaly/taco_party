import 'package:angular_router/angular_router.dart';

import 'screens/bundle_manager/bundle_manager.template.dart'
    as bundle_manager_template;
import 'screens/home/home.template.dart' as home_template;

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

  static final bundleManager = RouteDefinition(
    path: "tools/bundle_manager",
    component: bundle_manager_template.BundleManagerScreenComponentNgFactory,
  );

  static final all = [
    home,
    bundleManager,
  ];
}
