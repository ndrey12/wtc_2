import 'dart:async';
import 'dart:convert';
import 'package:beta_wtc_bloc/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/models/register_status.dart';
import 'package:beta_wtc_bloc/models/login_status.dart';
import 'package:crypto/crypto.dart';

class UserFunctions {
  static Future<RegisterStatus> registerUser(
      String username, String password, String email) async {
    var salt =
        '55d22cd3f15b89648eef873c0d7b0224ba933148b96738a2f1718a957f884b39';
    var saltedPassword = salt + password;
    var bytes = utf8.encode(saltedPassword);
    var encryptedPassword = sha256.convert(bytes);
    try {
      var registerApi =
          Uri.parse("https://watchthecrypto.com:5052/api/register");
      var response = await http.post(
        registerApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': encryptedPassword.toString(),
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        return RegisterStatus(status: true, message: "User have been created");
      } else {
        return RegisterStatus(status: false, message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return RegisterStatus(status: false, message: "Unknown error.");
  }

  static Future<LoginStatus> loginUser(String username, String password) async {
    var salt =
        '55d22cd3f15b89648eef873c0d7b0224ba933148b96738a2f1718a957f884b39';
    var saltedPassword = salt + password;
    var bytes = utf8.encode(saltedPassword);
    var encryptedPassword = sha256.convert(bytes);
    UserData userData = UserData(username: "n/a", email: "n/a", token: "n/a");
    try {
      var loginApi = Uri.parse("https://watchthecrypto.com:5052/api/login");
      var response = await http.post(
        loginApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': encryptedPassword.toString(),
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);

        userData = UserData(
            username: decodedResponse["username"],
            email: decodedResponse["email"],
            token: decodedResponse["token"]);

        return LoginStatus(
            userData: userData,
            status: true,
            message: "You have been connected!");
      } else {
        return LoginStatus(
            userData: userData, status: false, message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return LoginStatus(
        userData: userData, status: false, message: "Unknown error!");
  }
}
