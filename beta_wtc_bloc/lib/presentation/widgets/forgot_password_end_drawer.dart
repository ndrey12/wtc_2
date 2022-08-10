import 'package:beta_wtc_bloc/logic/cubit/forgot_password_cubit.dart';
import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordEndDrawer extends StatefulWidget {
  const ForgotPasswordEndDrawer({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordEndDrawer> createState() =>
      _ForgotPasswordEndDrawerState();
}

class _ForgotPasswordEndDrawerState extends State<ForgotPasswordEndDrawer> {
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
                  'Forgot Password',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Send Mail'),
                  onPressed: () {
                    BlocProvider.of<ForgotPasswordCubit>(context)
                        .sendForgotPasswordMail(emailController.text);
                    AppRouter.hideEndDrawerScreen();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
