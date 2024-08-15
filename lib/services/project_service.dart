import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectService {
  final String _url = 'https://fhawxe4zgf.sharedwithexpose.com/api';
  // late String token = await _getToken();

  getData(apiUrl, token) async {
    var fullUrl = _url + apiUrl;

    var response = http.get(Uri.parse(fullUrl), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token"
    });

    print(response);
    return response;
  }
}
