import 'package:angular/angular.dart';

import '../../bundle.dart';

@Component(
  selector: "tp-bundle",
  templateUrl: "bundle_display.html",
  styleUrls: ["bundle_display.css"],
  directives: coreDirectives,
)
class BundleDisplayComponent {
  @Input()
  Bundle bundle;

  bool isExpanded = false;

  String get expandToggleDisplay => isExpanded ? "&ndash;" : "+";
  String get expandToggleAriaLabel => isExpanded ? "contract" : "expand";

  String get listDisplay => isExpanded ? "initial" : "none";
}
