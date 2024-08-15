import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurveyService {
  final String _url = 'https://fhawxe4zgf.sharedwithexpose.com/api';
 

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
   
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  sendResults(apiUrl, results) async {
    var fullUrl = _url + apiUrl;
   

    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(results), headers: _setHeaders());
  }



  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token'
      };
}
