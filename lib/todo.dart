class Todo {
  Todo();

  int id;
  String name;
  DateTime startAt;
  DateTime endAt;
  bool done;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
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
    startAt = map['start_at'];
    endAt = map['end_at'];
    done = map['done'] == 1 ? true : false;
  }
}