import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_package/research_package.dart';

import '../utils/survey_builder.dart';



class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  // initialize the survey builder
  late SurveyBuilder surveyBuilder;

  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);

  void resultCallback(RPTaskResult result) {
    // Do anything with the result
    print(_encode(result));
  }

  void cancelCallBack(RPTaskResult result) {
    // Do anything with the result at the moment of the cancellation
    print("The result so far:\n" + _encode(result));
  }

  // takes in the survey json and returns a widget with the survey
  Future<Widget> processSurveyJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    surveyBuilder = new SurveyBuilder(
        input: data,
        resultCallback: resultCallback,
        cancelCallBack: cancelCallBack);

    return await surveyBuilder.buildSurvey();
  }

  @override
  void initState() {
    processSurveyJson();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: new AppBar(
        title: Text("Sample SurveyJS Survey"),
        centerTitle: true,
      ),
      body: FutureBuilder<Widget>(
          future: processSurveyJson(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Container(
                    child: snapshot.data,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 1.5,
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: '),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Loading Survey'),
              );
            }
          }),
    );
  }
}
