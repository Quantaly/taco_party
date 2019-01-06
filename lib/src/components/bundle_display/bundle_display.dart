import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../bundle.dart';
import '../../routing.dart';
import '../../tools/string_base64.dart';

@Component(
  selector: "tp-bundle",
  templateUrl: "bundle_display.html",
  styleUrls: ["bundle_display.css"],
  directives: [coreDirectives, routerDirectives],
)
class BundleDisplayComponent {
  static const _stringBase64 = StringBase64Encoder();

  @Input()
  Bundle bundle;

  @Input()
  String queryString;

  bool isExpanded = false;

  String get expandToggleDisplay => isExpanded ? "&ndash;" : "+";
  String get expandToggleAriaLabel => isExpanded ? "contract" : "expand";

  String get listDisplay => isExpanded ? "initial" : "none";

  String get bundleIdentifier => _stringBase64.encode(bundle.url);
  String stageLink(String spriteSetName) =>
      Routes.stageLink(bundleIdentifier, spriteSetName) + (queryString ?? "");
}
