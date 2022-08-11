import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/logic/cubit/alert_cubit.dart';
import 'package:beta_wtc_bloc/logic/cubit/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordBody extends StatefulWidget {
  ForgotPasswordBody({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordNewController = TextEditingController();
    TextEditingController passwordRepeatController = TextEditingController();
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordRes) {
          //! Trimitem alerta primita din server side
        }
      },
      builder: (context, state) {
        return Center(
          child: Container(
            width: 600,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyDark,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(fontSize: 20),
                      )),
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
                                      content: const Text(
                                          'Passwords are not the same'),
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
                            if (state is ForgotPasswordCanSubmit) {
                              BlocProvider.of<ForgotPasswordCubit>(context)
                                  .changePassword(passwordNewController.text);
                            } else {
                              BlocProvider.of<AlertCubit>(context).showAlert(
                                  "Error!",
                                  "You cannot submit right now, please try again later.");
                            }
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
