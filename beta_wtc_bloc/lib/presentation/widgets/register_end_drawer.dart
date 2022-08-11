import 'package:beta_wtc_bloc/logic/cubit/alert_cubit.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/user_data_cubit.dart';

class RegisterEndDrawer extends StatefulWidget {
  RegisterEndDrawer({Key? key}) : super(key: key);

  @override
  State<RegisterEndDrawer> createState() => _RegisterEndDrawerState();
}

class _RegisterEndDrawerState extends State<RegisterEndDrawer> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

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
                  'Sign in',
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
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordRepeatController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
                  border: OutlineInputBorder(),
                  labelText: 'Repeat password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () async {
                    if (passwordController.text !=
                        passwordRepeatController.text) {
                      BlocProvider.of<AlertCubit>(context)
                          .showAlert("Error!", "Passwords are not the same.");
                    } else if (passwordController.text.length < 8) {
                      BlocProvider.of<AlertCubit>(context).showAlert("Error!",
                          "Password must have at least 8 characters.");
                    } else if (isEmail(emailController.text) == false) {
                      BlocProvider.of<AlertCubit>(context)
                          .showAlert("Error!", "Please enter a valid email!");
                    } else {
                      BlocProvider.of<UserDataCubit>(context).registerAccount(
                          usernameController.text,
                          passwordController.text,
                          emailController.text);
                      AppRouter.hideEndDrawerScreen();
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
