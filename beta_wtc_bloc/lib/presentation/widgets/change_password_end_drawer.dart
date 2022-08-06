import 'package:beta_wtc_bloc/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/user_data_cubit.dart';

class ChangePasswordEndDrawer extends StatefulWidget {
  ChangePasswordEndDrawer({Key? key}) : super(key: key);

  @override
  State<ChangePasswordEndDrawer> createState() =>
      _ChangePasswordEndDrawerState();
}

class _ChangePasswordEndDrawerState extends State<ChangePasswordEndDrawer> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
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
                  'Change Password',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
                  border: OutlineInputBorder(),
                  labelText: 'Current Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordNewController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
                  border: OutlineInputBorder(),
                  labelText: 'New password',
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
                  labelText: 'Repeat new password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    if (passwordNewController.text !=
                        passwordRepeatController.text) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Passwords are not the same'),
                                actions: <Widget>[
                                  IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ));
                    } else if (passwordNewController.text.length < 8) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Password must have at least 8 characters.'),
                                actions: <Widget>[
                                  IconButton(
                                      icon: new Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ));
                    } else {
                      BlocProvider.of<UserDataCubit>(context).changePassword(
                        passwordController.text,
                        passwordNewController.text,
                      );
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
