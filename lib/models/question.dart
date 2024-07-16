import 'choice.dart';

class Question {
  final String type, name, title;
  List<Choice> choices;
  Question(
      {required this.type,
      required this.name,
      required this.title,
      required this.choices});
}
