class Todo {
  bool done;
  String name;
  String desc;
  TodoType type;
  List<String> images = [];
  String todoDate;
  String doneDate;
}

enum TodoType {
  EAT,
  VIDEO,
  TRAVEL,
  OTHER,
}