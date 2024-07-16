import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:research_package/research_package.dart';
import 'package:surve/models/question.dart';

import '../models/choice.dart';

class SurveyBuilder {
  final input;
  Function resultCallback;
  Function cancelCallBack;

  SurveyBuilder(
      {this.input, required this.resultCallback, required this.cancelCallBack});

  Future<Widget> buildSurvey() async {
    RPOrderedTask linearSurveyTask = buildSurveyTask();
    var uuid = Uuid();
    // return Container();
    return RPUITask(
      key: Key(uuid.v4().toString()),
      task: linearSurveyTask,
      onSubmit: (result) {
        resultCallback(result);
      },
      onCancel: ([res]) => print('survey canceled'),
      // No onCancel
      // If there's no onCancel provided the survey just quits
    );
  }

  RPOrderedTask buildSurveyTask() {
    var uuid = Uuid();
    List questions = extractQuestions();
    // print(questions);
    List<RPStep> questiontasks = [];

    RPInstructionStep instructionStep = RPInstructionStep(
        identifier: "instructionID",
        title: "Welcome!",
        footnote: "(1) Important footnote",
        text:
            "Please fill out this questionnaire!\n\nIn this questionnaire the questions will come after each other in a given order. You still have the chance to skip a some of them though.",
        detailText: "For the sake of science of course...");

    List<RPStep> surveytasks = [];
    int i = 0;
    RPTextAnswerFormat textAnswerFormat =
        RPTextAnswerFormat(hintText: "Write your answer here");

    RPCompletionStep completionStep = RPCompletionStep(
        identifier: "completionID",
        title: "Finished",
        text: "Thank you for filling out the survey!");

    for (Question question in questions) {
      // will transllate different question types here
      RPQuestionStep surveytask = RPQuestionStep(
          identifier: 'q${i.toString()}ID',
          title: question.title,
          answerFormat: textAnswerFormat,
          optional: false);

      // print(surveytask.identifier);
      surveytasks.add(surveytask);

      i++;
    }

    questiontasks.add(instructionStep);
    questiontasks.addAll(surveytasks);
    questiontasks.add(completionStep);

    return RPOrderedTask(
      identifier: "survey1",
      steps: questiontasks,
    );
  }

  List extractQuestions() {
    Map<String, dynamic> surveyJson = input;

    print(surveyJson.runtimeType);
    // print();

    List pages = surveyJson['pages'];
    List questions = [];
    for (var item in pages) {
      // print(item['name']);
      List elements = item['elements'];

      // print(elements);

      for (Map<String, dynamic> element in elements) {
        List<Choice> choices = [];
        String title;
        if (element['title'] is String) {
          title = element['title'];
        } else {
          title = element['title']['default'];
        }

        // print(title.runtimeType);
        Question question;
        if (element['type'] == 'radiogroup') {
          for (var item in element['choices']) {
            print(item);
            Choice choice =
                new Choice(value: item['value'], text: item['text'][0]);
            choices.add(choice);
          }
          question = new Question(
              type: element['type'],
              name: element['name'],
              title: title,
              choices: choices);
        } else {
          question = Question(
              type: element['type'],
              name: element['name'],
              choices: [],
              title: title);
        }

        questions.add(question);
      }
    }

    return questions;
  }
}
