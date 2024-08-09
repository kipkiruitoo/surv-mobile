import 'package:flutter/material.dart';
import 'package:surve/screens/projects.dart';

import 'dart:convert';

import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/login_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    Toast.show(msg, duration: 2, gravity: 0);
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };

    // print(data);

    var res = await LoginService().login(data, '/login');
    var body = json.decode(res.body);
    // print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => ProjectsScreen()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80),
            height: 100,
            child: Center(
              child: Image(image: AssetImage('assets/logo.png')),
            ),
          ),
          Container(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Text(
                    "Hello",
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                  child: Text(
                    "There",
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(220, 80, 0, 0),
                  child: Text(
                    ".",
                    style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800]),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35, left: 20, right: 20),
            child: Form(
              key: _loginkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink[800]!)),
                        errorStyle: TextStyle(color: Colors.pink[800])),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink[800]!)),
                        errorStyle: TextStyle(color: Colors.pink[800])),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment(1, 0),
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: InkWell(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.pink[800],
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 40,
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_loginkey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.

                          _showMsg("Logging you in");
                          login();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.pink[800]!,
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.pink[800],
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Wrap(
              children: [
                Text(
                  "Dont Have an Account yet?",
                  style: TextStyle(color: Colors.pink[800]),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Contact your Supervisor or Project Manager',
                    style: TextStyle(
                        color: Colors.pink[800],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
