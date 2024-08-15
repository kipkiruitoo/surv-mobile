import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surve/helpers/drawer.dart';
import 'package:surve/models/project.dart';
import 'package:surve/screens/surveys.dart';
import 'package:surve/services/project_service.dart';

import 'package:timeago/timeago.dart' as timeago;

class ProjectsScreen extends StatefulWidget {
  String? token;

  ProjectsScreen({this.token});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  bool _loading = true;

  List<Project> projects = List.empty(growable: true);

  Future<void> getProjects() async {
    var res = await ProjectService().getData("/projects", widget.token);
    var body = json.decode(res.body);

    print(body);

    if (body["projects"].toString().isNotEmpty) {
      var project_list = body["projects"];
      // print(projects);
      print(project_list[0]);
      project_list.forEach((element) {
        Project project = new Project(
            name: element["name"],
            start_date: DateTime.parse(element["start_date"]),
            end_date: DateTime.parse(element["end_date"]),
            id: element["uuid"]);
        setState(() {
          projects.add(project);
        });
      });
    }
    //
    setState(() {
      _loading = false;
    });
  }

  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    getProjects();
    super.initState();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Running Projects",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Closed Projects",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: closeTopContainer ? 0 : 1,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: size.width,
                        alignment: Alignment.topCenter,
                        height: closeTopContainer ? 0 : size.height * 0.30,
                        child: categoriesScroller),
                  ),
                  Expanded(
                      child: ListView.builder(
                          controller: controller,
                          itemCount: projects.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            double scale = 1.0;
                            if (topContainer > 0.5) {
                              scale = index + 0.5 - topContainer;
                              if (scale < 0) {
                                scale = 0;
                              } else if (scale > 1) {
                                scale = 1;
                              }
                            }
                            return ListItem(
                              project: projects[index],
                            );
                          }))
                ],
              ),
            ),
    ));
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();
  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Current\nProjects",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "5 Projects",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Newest",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "20 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Super\nSaving",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  Project project;
  ListItem({required this.project});

  @override
  Widget build(BuildContext context) {
    final enddate = DateFormat.yMMMEd().format(project.end_date);
    return GestureDetector(
      onTap: () {
        print(enddate);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewSurveys(
                      projectId: project.id,
                      projectName: project.name,
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
                      project.name,
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
                      "Ending on: ${enddate}",
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
                          "https://picsum.photos/80/80/?random=${project.id}"))
            ],
          ),
        ),
      ),
    );
  }
}
