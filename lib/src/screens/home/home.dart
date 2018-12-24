import 'package:angular/angular.dart';

import '../../services/background_color_service.dart';

@Component(
  selector: "tp-home",
  templateUrl: "home.html",
  styleUrls: ["home.css"],
)
class HomeScreenComponent implements OnInit {
  BackgroundColorService _bgColor;

  HomeScreenComponent(this._bgColor);

  @override
  void ngOnInit() {
    _bgColor.backgroundColor = "yellow";
  }
}
