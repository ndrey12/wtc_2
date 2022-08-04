import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CoinPrices {
  static Future<Map<String, String>> get(List<String> coinNames) async {
    try {
      String api_params = "[\"" + coinNames[0] + "\"";
      for (int i = 1; i < coinNames.length; i++) {
        api_params = '$api_params,\"${coinNames[i]}\"';
      }
      api_params = '$api_params]';
      var getCoinsApi = Uri.parse(
          "https://api.binance.com/api/v3/ticker/price?symbols=$api_params");
      var response = await http.get(getCoinsApi);

      if (response.statusCode == 200) {
        Map<String, String> coinPrices = {};
        List<dynamic> jsonData = jsonDecode(response.body);
        for (var jsonCoinData in jsonData) {
          String coinName = jsonCoinData["symbol"];
          String coinPrice = jsonCoinData["price"];
          coinPrices[coinName] = coinPrice;
        }
        return coinPrices;
      }
      return {};
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
    return {};
  }
}
