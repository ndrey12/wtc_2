import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/user_data_cubit.dart';

class ChangeEmailEndDrawer extends StatefulWidget {
  ChangeEmailEndDrawer({Key? key}) : super(key: key);

  @override
  State<ChangeEmailEndDrawer> createState() => _ChangeEmailEndDrawerState();
}

class _ChangeEmailEndDrawerState extends State<ChangeEmailEndDrawer> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Change Email',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    BlocProvider.of<UserDataCubit>(context).changeEmail(
                      passwordController.text,
                      emailController.text,
                    );
                    AppRouter.hideEndDrawerScreen();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
