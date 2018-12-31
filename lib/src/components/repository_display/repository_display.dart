import 'package:angular/angular.dart';

import '../../repository.dart';

@Component(
  selector: "tp-repo",
  templateUrl: "repository_display.html",
  styleUrls: ["repository_display.css"],
  directives: coreDirectives,
)
class RepositoryDisplayComponent {
  @Input()
  Repository repository;

  bool isExpanded = false;

  String get expandToggleDisplay => isExpanded ? "&ndash;" : "+";
  String get expandToggleAriaLabel => isExpanded ? "contract" : "expand";

  String get listDisplay => isExpanded ? "initial" : "none";
}
