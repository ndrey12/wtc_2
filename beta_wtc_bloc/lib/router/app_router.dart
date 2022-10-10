import 'package:beta_wtc_bloc/network/user_functions.dart';
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/screens/home_screen.dart';
import 'package:beta_wtc_bloc/presentation/screens/forgot_password_screen.dart';


class AppRouter {
  static final GlobalKey<ScaffoldState> _key = GlobalKey();
  static final GlobalKey<ScaffoldState> _forgotPasswordKey = GlobalKey();
  Route onGenerateRoute(RouteSettings settings) {
    final settingsUri = Uri.parse(settings.name.toString());
    final param_token = settingsUri.queryParameters['id'].toString();
    final path = settingsUri.path;
    if(path.toString() == '/validate-account')
    {
      //apelam functia de validare
      UserFunctions.validateAccount(param_token);
    }
    switch (path.toString()) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen(scaffoldKey: _key));
      case '/forgot-password':
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordScreen(
                scaffoldKey: _forgotPasswordKey, tokenParam: param_token));
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
