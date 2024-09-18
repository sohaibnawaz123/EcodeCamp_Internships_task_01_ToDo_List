class ToDoList {
  final String taskId;
  final String taskName;
  bool taskComplete;

  ToDoList({required this.taskId, required this.taskName, this.taskComplete = false});

  static List<ToDoList> myList() {
    return [];
  }

  Map<String, dynamic> toMap() {
    return {'taskId': taskId, 'taskName': taskName, "taskComplete": taskComplete ? 1 : 0};
  }

  factory ToDoList.fromMap(Map<String, dynamic> json) {
    return ToDoList(
        taskId: json['taskId'], taskName: json['taskName'], taskComplete: json['taskComplete']==1);
  }
}
