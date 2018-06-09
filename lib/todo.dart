class Todo {
  Todo();

  int id;
  String name;
  String remark;
  DateTime startAt;
  DateTime endAt;
  bool done;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "remark":remark,
      "start_at":startAt,
      "end_at": endAt,
      "done": done ? 1 : 0
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
  
  Todo.fromMap(Map<String, dynamic> map){
    name = map['name'];
    remark = map['remark'];
    startAt = map['start_at'];
    endAt = map['end_at'];
    done = map['done'] == 1 ? true : false;
  }
}