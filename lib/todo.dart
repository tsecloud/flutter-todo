class Todo {
  Todo();

  int id;
  String name;
  String remark;
  DateTime startAt;
  DateTime endAt;
  bool done;

  Map<String, dynamic> toMap() {

    if(done == null || done  == false)
        done = false;

    Map<String, dynamic> map = {
      "name": name,
      "remark":remark,
      "start_at":startAt.millisecondsSinceEpoch,
      "end_at": endAt.millisecondsSinceEpoch,
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
    startAt = new DateTime.fromMicrosecondsSinceEpoch(map['start_at']);
    endAt = new DateTime.fromMicrosecondsSinceEpoch(map['end_at']);
    done = map['done'] == 1 ? true : false;
  }
}