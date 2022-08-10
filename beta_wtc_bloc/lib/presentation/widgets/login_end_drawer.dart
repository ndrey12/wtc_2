import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/user_data_cubit.dart';
import 'package:beta_wtc_bloc/logic/cubit/end_drawer_cubit.dart';

class LoginEndDrawer extends StatefulWidget {
  const LoginEndDrawer({Key? key}) : super(key: key);

  @override
  State<LoginEndDrawer> createState() => _LoginEndDrawerState();
}

class _LoginEndDrawerState extends State<LoginEndDrawer> {
  TextEditingController usernameController = TextEditingController();
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
                  'Log in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
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
                  child: const Text('Login'),
                  onPressed: () {
                    BlocProvider.of<UserDataCubit>(context).loginAccount(
                      usernameController.text,
                      passwordController.text,
                    );
                    AppRouter.hideEndDrawerScreen();
                  },
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<EndDrawerCubit>(context)
                        .openForgotPassword();
                  },
                  child: Text("Forgot Password?"),
                )),
          ],
        ),
      ),
    );
  }
}
