import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:surve/helpers/drawer.dart';
import 'package:surve/services/survey_service.dart';

class SurveyInstance extends StatefulWidget {
  final String? slug, name;
  final String? id;
  final String? project;
  String? html;
  Map<dynamic, dynamic>? json;

  SurveyInstance({this.slug, this.name, this.id, this.json, this.project});

  @override
  _SurveyInstanceState createState() => _SurveyInstanceState();
}

class _SurveyInstanceState extends State<SurveyInstance> {
  InAppWebViewController? _controller;
  InAppLocalhostServer localhostServer = new InAppLocalhostServer();
  int position = 0;

  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  doneLoading() {
    setState(() {
      position = 0;
    });
  }

  startLoading() {
    setState(() {
      position = 1;
    });
  }

  double progress = 0;

  @override
  void dispose() {
    super.dispose();
    localhostServer.close();
  }

  @override
  void initState() {
    // TODO: implement initState

    localhostServer.start();
    super.initState();
  }

  Future<void> sendResults(jsonData, context) async {
    setState(() {
      position = 1;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var agent = jsonDecode(localStorage.getString('user')!)['id'];
    print(agent);
    var data = {
      'json': jsonData,
      'agent': agent,
      "survey": widget.id,
      "project": widget.project
    };
    // print("here is the data from the app ${json}");

    print(data);
    var res =
        await SurveyService().sendResults("/survey/${widget.id}/result", data);
    var body = json.decode(res.body);

    print(body);
    if (body["message"] == "Survey Result successfully created") {
      Navigator.pop(context);
    }
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await _controller!.canGoBack()) {
            _controller!.goBack();
            return false;
          }
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _drawerKey,
          drawer: AppDrawer(),
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => _drawerKey.currentState!.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: Colors.pink[800],
              ),
            ),
            title: Center(
                child: Image(
              image: AssetImage('assets/logo.png'),
              height: 30,
            )),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.pink[800],
                  ),
                  onPressed: null),
              IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.pink[800],
                  ),
                  onPressed: null)
            ],
          ),
          body: Column(
            children: [
              Container(
                child: Center(
                  child: Text(
                    widget.name!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IndexedStack(
                index: position,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: MediaQuery.of(context).size.width,
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                          url: WebUri(
                              "http://localhost:8080/assets/index.html")),
                      initialSettings: settings,
                      onWebViewCreated:
                          (InAppWebViewController webViewController) async {
                        _controller = webViewController;

                        _controller!.addJavaScriptHandler(
                            handlerName: 'passJson',
                            callback: (args) {
                              // return data to JavaScript side!
                              return {'json': widget.json};
                            });
                        _controller!.addJavaScriptHandler(
                            handlerName: 'getJsonResults',
                            callback: (result) {
                              var data = HashMap.from(result[0]);
                              print(data.runtimeType);
                              sendResults(data, context);
                            });

                        // _controller.evaluateJavascript("<script> var json = ${widget.json}; </script>");
                      },
                      onLoadStart: (_controller, url) async {
                        startLoading();
                      },
                      onLoadStop: (_controller, url) async {
                        doneLoading();
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        // print(jsonEncode(consoleMessage.message));
                        print(consoleMessage.message);
                        // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
