class Survey {
  String id;
  String project;
  String name;
  String slug;
  Map json;

  Survey(
      {required this.id,
      required this.name,
      required this.slug,
      required this.json,
      required this.project});
}
