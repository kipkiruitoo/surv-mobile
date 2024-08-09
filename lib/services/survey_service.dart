import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurveyService {
  final String _url = 'https://recruit.tifaresearch.com/api';
  var token;

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  sendResults(apiUrl, results) async {
    var fullUrl = _url + apiUrl;
    await _getToken();

    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(results), headers: _setHeaders());
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')!)['token'];
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
