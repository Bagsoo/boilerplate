import 'package:flutter/material.dart';
import 'core/app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.flavor = Flavor.prod;
  app.main();
}
