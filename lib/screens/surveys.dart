import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:surve/helpers/drawer.dart';
import 'package:surve/models/survey.dart';
import 'package:surve/screens/survey.dart';
import 'package:surve/services/survey_service.dart';

class NewSurveys extends StatefulWidget {
  final dynamic projectId;
  final dynamic projectName;
  NewSurveys({this.projectId, this.projectName});
  @override
  _NewSurveysState createState() => _NewSurveysState();
}

class _NewSurveysState extends State<NewSurveys> {
  bool _loading = true;
  List<Survey> surveys = List.empty(growable: true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSurveys();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  ScrollController controller = ScrollController();
  Future<void> getSurveys() async {
    var res = await SurveyService().getData("/surveys/${widget.projectId}");
    var body = json.decode(res.body);

    print(body);
    if (body["surveys"].toString().isNotEmpty) {
      var survey_list = body["surveys"];

      print(survey_list[0]);
      setState(() {
        this._loading = false;
      });
      // print(projects);
      survey_list.forEach((element) {
        Survey survey = new Survey(
            json: element["json"].runtimeType == Null ? {} : element["json"],
            name: element["name"],
            id: element["id"],
            project: element["project_id"],
            slug: element["slug"]);
        setState(() {
          surveys.add(survey);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
        body: _loading
            ? Center(
                child: Container(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.pink[800],
                )),
              )
            : Container(
                height: size.height,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: surveys.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SurveyItem(
                                survey: surveys[index],
                              );
                            }))
                  ],
                ),
              ),
      ),
    );
  }
}

class SurveyItem extends StatelessWidget {
  Survey survey;
  SurveyItem({required this.survey});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SurveyInstance(
                      id: survey.id,
                      name: survey.name,
                      project: survey.project,
                      json: survey.json,
                      slug: '',
                    )));
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      survey.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Project Manager: John Doe",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Ending on: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.5),
                    )
                  ],
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                      imageUrl:
                          "https://picsum.photos/80/80/?random=${survey.id}"))
            ],
          ),
        ),
      ),
    );
  }
}
