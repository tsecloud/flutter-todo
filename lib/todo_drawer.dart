import 'package:flutter/material.dart';
import 'todo.dart';
///参考文章
///https://engineering.classpro.in/flutter-1-navigation-drawer-routes-8b43a201251e
///
const String _AccountName = 'Gru.mo';
const String _AccountEmail = 'Gru.mo@vodehr.com';


class DrawerPage extends StatelessWidget {


  DrawerPage({Key key, this.archiveSearch}):super(key:key);


  final ValueChanged<SearchStatus> archiveSearch;


  //显示用户头部信息
  final userAccountHeader = new UserAccountsDrawerHeader(
    accountName: const Text(_AccountName),
    accountEmail: const Text(_AccountEmail),
    currentAccountPicture: new CircleAvatar(
      backgroundColor: Colors.white,
      child: new FlutterLogo(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      elevation: 14.0,
      child: new ListView(
        padding: const EdgeInsets.only(top: 0.0),
        children: <Widget>[
          userAccountHeader,
          new ListTile(
            leading: new Icon(Icons.info),
            title: new Text('个人中心'),
            onTap: null,
          ),
          new Divider(
            height: 20.0,
          ),
          new ListTile(
            leading: new Text('Label'),
            trailing: new Text('Edit'),
            onTap: null,
          ),
          new ListTile(
            leading: new Icon(Icons.menu),
            title: new Text('全部'),
            onTap: () => _todoArchive(context,SearchStatus.all),
          ),
          new ListTile(
            leading: new Icon(Icons.done),
            title: new Text('已完成'),
            onTap: () => _todoArchive(context,SearchStatus.done),
          ),
          new ListTile(
            leading: new Icon(Icons.list),
            title: new Text('进行中'),
            onTap: () => _todoArchive(context,SearchStatus.doing),
          ),
          new ListTile(
            leading: new Icon(Icons.calendar_today),
            title: new Text('未开始'),
            onTap: () => _todoArchive(context, SearchStatus.wait),
          ),
          new ListTile(
            leading: new Icon(Icons.pause),
            title: new Text('已过期'),
            onTap: () {
              _todoArchive(context, SearchStatus.pause);
            },
          ),
        ],
      ),
    );
  }

  void _todoArchive(BuildContext context, SearchStatus status) {
    Navigator.of(context).pop();
    archiveSearch(status);
  }
}
