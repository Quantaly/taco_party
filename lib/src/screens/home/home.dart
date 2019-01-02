import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../components/repository_display/repository_display.dart';
import '../../repository.dart';
import '../../routing.dart';
import '../../services/background_color_service.dart';
import '../../services/repository_mass_loader_service.dart';

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
  final RepositoryMassLoaderService _repoLoader;

  HomeScreenComponent(this._bgColor, this._repoLoader);

  List<Repository> repositories = [];

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
    _repoLoader.loadAsync().listen((list) => repositories = list);
  }

  String get repoManagerLink => Routes.repositoryManager.toUrl();
}
