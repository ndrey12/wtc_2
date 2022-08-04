import 'package:beta_wtc_bloc/presentation/widgets/watcher_list.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/widgets/appbar_main.dart';
import 'package:beta_wtc_bloc/presentation/screens/drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        key: widget.scaffoldKey,
        appBar: const AppBarMain(),
        endDrawerEnableOpenDragGesture: false,
        drawerEnableOpenDragGesture: false,
        drawer: DrawerScreen(),
        body: WatcherList(),
      );
    });
  }
}
