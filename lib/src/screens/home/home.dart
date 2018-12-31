import 'package:angular/angular.dart';

import '../../components/repository_display/repository_display.dart';
import '../../repository.dart';
import '../../services/background_color_service.dart';
import '../../services/repository_reader_service.dart';

@Component(
  selector: "tp-home",
  templateUrl: "home.html",
  styleUrls: ["home.css"],
  directives: [coreDirectives, RepositoryDisplayComponent],
)
class HomeScreenComponent implements OnInit {
  BackgroundColorService _bgColor;
  RepositoryReaderService _repoReader;

  HomeScreenComponent(this._bgColor, this._repoReader);

  Repository repository;

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
    _repoReader
        .getRepository("example_repository.yaml")
        .then((r) => repository = r);
  }
}
