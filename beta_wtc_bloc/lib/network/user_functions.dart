import 'dart:async';
import 'dart:convert';
import 'package:beta_wtc_bloc/models/change_email_status.dart';
import 'package:beta_wtc_bloc/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:beta_wtc_bloc/models/register_status.dart';
import 'package:beta_wtc_bloc/models/login_status.dart';
import 'package:beta_wtc_bloc/models/user_coins_status.dart';
import 'package:beta_wtc_bloc/models/change_password_status.dart';
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

  static Future<UserCoinsStatus> getCoinsForUser(String token) async {
    try {
      var loginApi =
          Uri.parse("https://watchthecrypto.com:5052/api/get-coins-for-user");
      var response = await http.post(
        loginApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
        }),
      );
      if (response.statusCode == 200) {
        final split = response.body.split(',');
        List<String> coins = [];
        for (int i = 0; i < split.length; i++) {
          coins.add(split[i]);
        }
        return UserCoinsStatus(
            userCoins: coins, status: true, message: "Succes");
      } else {
        return UserCoinsStatus(
            userCoins: [], status: false, message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return UserCoinsStatus(
        userCoins: [], status: false, message: "Unknown error");
  }

  static Future<void> updateCoinsForUser(
      String token, List<String> coinNames) async {
    try {
      var loginApi = Uri.parse(
          "https://watchthecrypto.com:5052/api/update-coins-for-user");
      String stringCoinNames = "";
      for (int i = 0; i < coinNames.length - 1; i++) {
        stringCoinNames = '$stringCoinNames${coinNames[i]},';
      }
      stringCoinNames = '$stringCoinNames${coinNames[coinNames.length - 1]}';
      await http.post(
        loginApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'token': token,
          'coins_string': stringCoinNames,
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<ChangePasswordStatus> changePassword(
      String token, String oldPassword, String newPassword) async {
    var salt =
        '55d22cd3f15b89648eef873c0d7b0224ba933148b96738a2f1718a957f884b39';
    var saltedOldPassword = salt + oldPassword;
    var bytes = utf8.encode(saltedOldPassword);
    var encryptedOldPassword = sha256.convert(bytes);

    var saltedNewPassword = salt + newPassword;
    bytes = utf8.encode(saltedNewPassword);
    var encryptedNewPassword = sha256.convert(bytes);

    try {
      var getCoinsApi =
          Uri.parse("https://watchthecrypto.com:5052/api/change-password");
      var response = await http.post(
        getCoinsApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_password': encryptedNewPassword.toString(),
          'password': encryptedOldPassword.toString(),
          'token': token,
        }),
      );
      if (response.statusCode == 200) {
        return ChangePasswordStatus(
            status: true, message: "Password have been changed.");
      } else {
        return ChangePasswordStatus(status: false, message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return ChangePasswordStatus(status: false, message: "Unknown Error!");
  }

  static Future<ChangeEmailStatus> changeEmail(
      String token, String password, String email) async {
    var salt =
        '55d22cd3f15b89648eef873c0d7b0224ba933148b96738a2f1718a957f884b39';
    var saltedPassword = salt + password;
    var bytes = utf8.encode(saltedPassword);
    var encryptedPassword = sha256.convert(bytes);
    try {
      var getCoinsApi =
          Uri.parse("https://watchthecrypto.com:5052/api/change-email");
      var response = await http.post(
        getCoinsApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_email': email,
          'password': encryptedPassword.toString(),
          'token': token,
        }),
      );
      if (response.statusCode == 200) {
        return ChangeEmailStatus(
            status: true, message: "Email have been changed!");
      } else {
        return ChangeEmailStatus(status: false, message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return ChangeEmailStatus(status: false, message: "Unknown Error");
  }

  static Future<ChangePasswordStatus> forgotPassword(
      String token, String newPassword) async {
    var salt =
        '55d22cd3f15b89648eef873c0d7b0224ba933148b96738a2f1718a957f884b39';
    var saltedNewPassword = salt + newPassword;
    var bytes = utf8.encode(saltedNewPassword);
    var encryptedNewPassword = sha256.convert(bytes);

    try {
      var getCoinsApi =
          Uri.parse("https://watchthecrypto.com:5052/api/forgot-password");
      var response = await http.post(
        getCoinsApi,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'new_password': encryptedNewPassword.toString(),
          'token': token,
        }),
      );
      if (response.statusCode == 200) {
        return ChangePasswordStatus(
            status: true, message: "Password have been changed.");
      } else {
        return ChangePasswordStatus(status: false, message: response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return ChangePasswordStatus(status: false, message: "Unknown Error!");
  }
}
