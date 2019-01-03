import 'dart:html';

import 'package:angular/angular.dart';

@Component(
  selector: "tp-screens-stage",
  templateUrl: "stage.html",
  styleUrls: ["stage.css"],
)
class StageScreenComponent implements AfterViewInit {
  @ViewChild("imageContainer")
  DivElement imageContainer;
  @ViewChild("stage")
  CanvasElement stage;

  @override
  ngAfterViewInit() {
    imageContainer.innerHtml = "HELLO";
  }
}
