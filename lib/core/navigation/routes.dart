import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../modules/home/presentation/ui/screens/home_screen.dart';
import '../ui/screens/splash_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) => SplashScreen(appNavigator: GetIt.I()),
  '/home': (_) => HomeScreen(
        customerStore: GetIt.I(),
        scaffoldHandler: GetIt.I(),
      ),
};
