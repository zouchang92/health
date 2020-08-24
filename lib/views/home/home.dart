import 'package:flutter/material.dart';
// import 'package:health/model/global.dart';
import 'package:health/views/home/menu.dart';
import 'package:health/views/home/person.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List bottom = [
    {"name": '首页', "url": Menu(), "icon": Icon(Icons.home)},
    {"name": '我的', "url": Person(), "icon": Icon(Icons.person)}
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> _bottomItems = bottom
        .map((e) =>
            BottomNavigationBarItem(icon: e['icon'], title: Text(e['name'])))
        .toList();
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(bottom[index]['name']),
      // ),
      body: bottom[index]['url'],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: index,
        onTap: (int _index) {
          print(_index);
          this.setState(() {
            this.index = _index;
          });
        },
      ),
    );
  }
}
