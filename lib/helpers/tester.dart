import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    MyAppState myAppState() => new MyAppState();
    return myAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new Scaffold(body: new Builder(
      builder: (BuildContext context) {
        return new Stack(
          children: <Widget>[
            new Image.asset(
              'assets/images/bg.jpeg',
              fit: BoxFit.fitWidth,
            ),
            new Center(
              child: new Container(
                height: 370.0,
                child: Container(
                  height: 250.0,
                  child: new Card(
                    color: Colors.white,
                    elevation: 6.0,
                    margin: EdgeInsets.only(right: 15.0, left: 15.0),
                    child: new Wrap(
                      children: <Widget>[
                        Center(
                          child: new Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: new Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red),
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.person),
                          title: new TextFormField(
                            decoration: new InputDecoration(
                              hintText: 'Please enter email',
                              labelText: 'Enter Your Email address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        new ListTile(
                          leading: const Icon(Icons.lock),
                          title: new TextFormField(
                            decoration: new InputDecoration(
                              hintText: 'Please enter password',
                              labelText: 'Enter Your Password',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, bottom: 15.0),
                          child: Center(
                            child: Text(
                              "FORGOT PASSWORD",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 40.0, top: 10.0),
                            child: Text.rich(
                              TextSpan(
                                children: const <TextSpan>[
                                  TextSpan(
                                      text: 'NEW USER ? ',
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black)),
                                  TextSpan(
                                      text: 'REGISTER',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          decoration: TextDecoration.underline,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 120.0)),
                      ],
                    ),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 30),
              ),
            ),
            new Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 310.0)),
                ElevatedButton(
                  onPressed: () {
                    print('Login Pressed');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  child: new Text('Login',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ))
          ],
        );
      },
    )));
  }
}
