import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../components/repository_display/repository_display.dart';
import '../../repository.dart';
import '../../routing.dart';
import '../../services/background_color_service.dart';
import '../../services/repository_reader_service.dart';

@Component(
  selector: "tp-screens-home",
  templateUrl: "home.html",
  styleUrls: ["home.css"],
  directives: [
    coreDirectives,
    routerDirectives,
    RepositoryDisplayComponent,
  ],
)
class HomeScreenComponent implements OnInit {
  final BackgroundColorService _bgColor;
  final RepositoryReaderService _repoReader;

  HomeScreenComponent(this._bgColor, this._repoReader);

  Repository repository;

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
    _repoReader
        .getRepository("example_repository.yaml")
        .then((r) => repository = r);
  }

  String get repoManagerLink => Routes.repositoryManager.toUrl();
}
