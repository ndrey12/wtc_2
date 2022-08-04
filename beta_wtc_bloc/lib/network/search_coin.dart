import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchCoin {
  static Future<List<String>> getCoinsName() async {
    try {
      List<String> result = [];
      var getCoinsApi =
          Uri.parse("https://watchthecrypto.com:5052/api/get-all-coins");
      var response = await http.get(getCoinsApi);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        for (var jsonCoinData in jsonData) {
          String coinName = jsonCoinData["name"];
          result.add(coinName);
        }
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  static Future<List<String>> searchCoins(String query) async {
    List<String> allCoins = await getCoinsName();
    List<String> results = [];
    for (var coinName in allCoins) {
      if (coinName.toLowerCase().contains(query.toLowerCase())) {
        results.add(coinName);
      }
    }
    return results;
  }
}
