import 'package:intl/intl.dart';
import 'package:path/path.dart';

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

  // 计算剩余时间的百分比
  double computeLeftTime(){

    if(this.done == true){
      return 1.0;
    }

    DateTime now = new DateTime.now();

    //判断是否开始
    if(now.compareTo(this.startAt) < 0){
      return 0.0;
    }

    num totalTime = this.endAt.difference(this.startAt).inMinutes;
    num useTime = now.difference(this.startAt).inMinutes;

    double left = useTime / totalTime;
    return left;
  }

  String getDateMd(DateTime datetime){
    String date = new DateFormat.Md().format(datetime);
    String time = new DateFormat.Hm().format(datetime);

    return date +" "+ time;
  }

}