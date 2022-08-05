import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/screens/home_screen.dart';

class AppRouter {
  static final GlobalKey<ScaffoldState> _key = GlobalKey();
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen(scaffoldKey: _key));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static void showDrawerScreen() {
    _key.currentState!.openDrawer();
  }

  static void hideDrawerScreen() {
    _key.currentState!.closeDrawer();
  }

  static void showEndDrawerScreen() {
    _key.currentState!.openEndDrawer();
  }

  static void hideEndDrawerScreen() {
    _key.currentState!.closeEndDrawer();
  }
}
