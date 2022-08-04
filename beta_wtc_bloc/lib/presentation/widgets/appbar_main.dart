import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/presentation/widgets/appbar_main_leading.dart';

class AppBarMain extends StatelessWidget with PreferredSizeWidget {
  const AppBarMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Watch The Crypto"),
      leadingWidth: 100,
      toolbarHeight: 50.0,
      leading: AppBarMainLeading(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
