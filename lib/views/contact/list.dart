import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/health.dart';
import 'package:health/store/profileNotify.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  final String title = '选择学生';
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List studentList = [
    {"name": '李突发', "id": '1', "stuNum": '0090897'},
    {"name": '地', "id": '2', "stuNum": '0090897'}
  ];
  int selected;
  bool showFloatButton = false;
  Argument args;
  Health health = new Health();
  @override
  void initState() {
    selected = 0;
    args = new Argument();
    health.stuNum = studentList[0]['stuNum'];
    health.stuNumValue = studentList[0]['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: list(context),
      floatingActionButton:
          FloatingActionButton(onPressed: _onpress, child: Text('确认')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget list(BuildContext context) {
    return ListView.builder(
        itemCount: studentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            RadioListTile(
              title: Text(studentList[index]['name']),
              value: index,
              groupValue: selected,
              onChanged: (_index) {
                //  print('_index:$_index');
                this.setState(() {
                  this.selected = _index;
                  health.stuNum = studentList[_index]['stuNum'];
                  health.stuNumValue = studentList[_index]['name'];
                });
              },
            ),
            index == studentList.length - 1
                ? Container(height: 0, width: 0)
                : Divider(height: 1)
          ]);
        });
  }

  void _onpress() {
    final _profileNotify = Provider.of<ProfileNotify>(context, listen: false);

    args.params = health;

    _profileNotify.saveArg(args);
    Navigator.of(context).pop();
  }
}
