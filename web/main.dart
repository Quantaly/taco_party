import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:http/http.dart' as http;
import 'package:taco_party/app_component.template.dart' as ng;

import 'main.template.dart' as self;

@GenerateInjector([
  routerProvidersHash,
  FactoryProvider(BodyElement, provideBody),
  FactoryProvider(TitleElement, provideTitle),
  FactoryProvider(HeadElement, provideHead),
  ClassProvider(http.Client),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}

BodyElement provideBody() => querySelector("body");
TitleElement provideTitle() => querySelector("title");
HeadElement provideHead() => querySelector("head");
