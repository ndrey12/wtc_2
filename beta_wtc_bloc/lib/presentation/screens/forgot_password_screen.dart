import 'package:beta_wtc_bloc/constants/app_colors.dart';
import 'package:beta_wtc_bloc/presentation/widgets/forgot_password_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beta_wtc_bloc/logic/cubit/alert_cubit.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ForgotPasswordScreen({Key? key, required this.scaffoldKey})
      : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      String? para1 = Uri.base.queryParameters["para1"];
      return MultiBlocListener(
        listeners: [
          BlocListener<AlertCubit, AlertState>(
            listener: (context, state) {
              if (state is AlertShow) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(state.title),
                          content: Text(state.message),
                          actions: <Widget>[
                            IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ));
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.greyLight,
          key: widget.scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Watch The Crypto"),
          ),
          body: ForgotPasswordBody(),
        ),
      );
    });
  }
}
