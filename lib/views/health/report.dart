import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/argument.dart';
// import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/health.dart';
import 'package:health/model/profile.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/index.dart';
import 'package:provider/provider.dart';

class HealthReport extends StatefulWidget {
  final String title = '晨午检上报';

  @override
  _HealthReportState createState() => _HealthReportState();
}

class _HealthReportState extends State<HealthReport> {
  final _formKey = GlobalKey<FormState>();
  Profile _profile = Global.profile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List _bindClass = [];
  List registerTypeList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.REGISTERTYPE]);
  List checkTypeList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.CHECKTYPE]);
  List illTypeList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.ILLTYPE]);
  List isHealList = Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  Health _health = new Health();
  bool visible = false;
  @override
  void initState() {
    
    super.initState();
    _bindClass = _profile.user.classIdAndNames??[];
    // print('_bindClass:$_bindClass');
  }
  @override
  Widget build(BuildContext context) {
    // print('_health$_health');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: form(),
    );
  }

  Map amap(Map a, Map b) {
    a.forEach((key, _) {
      if(b[key]!=null){
        a[key] = b[key];
      }
     
    });
    // print('a$a');
    return a;
  }

  Widget form() {
    final _arg = Provider.of<ProfileNotify>(context).argValue;
    // print('arg:$_arg');
    if (_arg != null) {
      Health _thealth = _arg.params as Health;
      // print('_thealth:${_thealth.toJson()}');
      this.setState(() {
        // _health = Object;
        _health = Health.fromJson(amap(_health.toJson(), _thealth.toJson()));
        // print('_health:${_health.toJson()}');
      });
    }
    return Form(
      key: _formKey,
      autovalidate: true,
      child: ListView(
        children: <Widget>[
          infoTitle('基本信息'),
          // TextFormField(
          //     // expands: true,
          //     readOnly: true,
          //     enabled: false,
          //     initialValue: _profile.user.organName,
          //     textAlign: TextAlign.right,
          //     decoration: InputDecoration(
          //         contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          //         prefixIcon: Padding(
          //             padding: EdgeInsets.only(left: 10.0, right: 10.0),
          //             child: Text('所属地区:')),
          //         prefixIconConstraints: BoxConstraints())),
          // TextFormField(
          //     // autofocus: false,

          //     readOnly: true,
          //     enabled: false,
          //     initialValue: _profile.user.schName,
          //     textAlign: TextAlign.right,
          //     decoration: InputDecoration(
          //         contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          //         prefixIcon: Padding(
          //             padding: EdgeInsets.only(left: 10.0, right: 10.0),
          //             child: Text('学校名称:')),
          //         prefixIconConstraints: BoxConstraints())),
          FLListTile(
            title: Text('所属班级'),
            /*Icon(Icons.navigate_next)*/
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.className ?? ''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: showPicker,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('学生信息'),
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.stuNumValue ?? ''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: openSearch,
          ),
          Divider(height: 1),
          ListTile(
            title: Text('所属地区:'),
            trailing: Text(_health.provinceName??''),
          ),
          Divider(height: 1),
          ListTile(
            title: Text('学校名称:'),
            trailing: Text(_health.schoolName??''),
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('登记类型'),
            trailing: ChoiceChipOptions(
              data: registerTypeList,
              label: 'name',
              onValueChange: (int _index) {
                this.setState(() {
                  _health.registerType = registerTypeList[_index]['code'];
                });
              },
            ),
            // onTap: openSearch,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('上报类型'),
            trailing: ChoiceChipOptions(
              data: checkTypeList,
              label: 'name',
              onValueChange: (int _index) {
                this.setState(() {
                  _health.checkType = checkTypeList[_index]['code'];
                });
              },
            ),
            // onTap: openSearch,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('发病日期'),
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.illDate ?? ''),
                  Icon(Icons.calendar_today)
                ]),
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: new DateTime.now(),
                      firstDate:
                          new DateTime.now().subtract(new Duration(days: 30)),
                      lastDate: new DateTime.now().add(new Duration(days: 30)))
                  .then((value) => {
                        print('取消:$value'),
                        if (value != null)
                          {
                            this.setState(() {
                              this._health.illDate =
                                  formatDate(value, [yyyy, '-', mm, '-', dd]);
                            })
                          }
                      });
            },
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('离校日期'),
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.leaveDate ?? ''),
                  Icon(Icons.calendar_today)
                ]),
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: new DateTime.now(),
                      firstDate:
                          new DateTime.now().subtract(new Duration(days: 30)),
                      lastDate: new DateTime.now().add(new Duration(days: 30)))
                  .then((value) => {
                        if (value != null)
                          {
                            this.setState(() {
                              this._health.leaveDate =
                                  formatDate(value, [yyyy, '-', mm, '-', dd]);
                            })
                          }
                      });
            },
          ),
          infoTitle('症状信息'),
          FLListTile(
            title: Text('学生症状'),
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.symptomTypeMultiValue!=null?_health.symptomTypeMultiValue.join(','):''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: () {
              Navigator.of(context).pushNamed('/healthSelectSym');
            },
          ),
          Divider(height: 1),
          ListTile(
              title: Text('是否就诊'),
              trailing: RadioOptions(
                data: isHealList,
                label: 'name',
                onValueChange: (int _index) {
                  _health.isHealed = isHealList[_index]['code'];
                },
              )),
          Divider(height: 1),
          ListTile(
            title: Text('病例类型'),
            trailing: ChoiceChipOptions(
              selectIndex: -1,
              data: illTypeList,
              label: 'name',
              onValueChange: (int _index) {
                this.setState(() {
                  _health.illType = illTypeList[_index]['code'];
                  if (_index == 2) {
                    this.visible = true;
                  } else {
                    this.visible = false;
                  }
                });

                String routeName = '';
                if (_index == 0) {
                  routeName = '/healthSelect';
                  Navigator.of(context).pushNamed(routeName);
                }
                if (_index == 1) {
                  routeName = '/healthSelectIll';
                  Navigator.of(context).pushNamed(routeName);
                }
              },
            ),
          ),
          Divider(height: 1),
          Offstage(
            offstage: visible,
            child: Column(children: <Widget>[
              ListTile(title: Text('确诊详情'), trailing: Text(_health.memo ?? '')),
              Divider(height: 1),
            ]),
          ),
          ListTile(
            title: Text('就诊日期'),
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.healDate ?? ''),
                  Icon(Icons.calendar_today)
                ]),
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: new DateTime.now(),
                      firstDate:
                          new DateTime.now().subtract(new Duration(days: 30)),
                      lastDate: new DateTime.now().add(new Duration(days: 30)))
                  .then((value) => {
                        this.setState(() {
                          if (value != null) {
                            _health.healDate =
                                formatDate(value, [yyyy, '-', mm, '-', dd]);
                          }
                        })
                      });
            },
          ),
          Divider(height: 1),
          TextFormField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text('就诊医院:')),
                prefixIconConstraints: BoxConstraints()),
            onSaved: (val) {
              _health.healHospital = val;
            },
          ),
          Divider(height: 1),
          TextFormField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text('采取措施:')),
                prefixIconConstraints: BoxConstraints()),
            onSaved: (val) {
              _health.measure = val;
            },
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: RaisedButton(
                onPressed: () {
                  if (_health.registerType == null) {
                    _health.registerType= registerTypeList[0]['code'];
                  }
                  if (_health.checkType == null) {
                    _health.checkType = registerTypeList[0]['code'];
                  }
                  if (_health.illType == null) {
                    _health.illType = illTypeList[0]['code'];
                  }
                  if (_health.isHealed == null) {
                    _health.isHealed = isHealList[0]['code'];
                  }
                  if(_health.personType == null){
                    /*Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.PERSONTYPE])[0]['code']*/ 
                     _health.personType = '1';
                  }
                  var _form = _formKey.currentState;
                  if (_form.validate()) {
                    _form.save();
                    _healthReport();
                  }
                },
                child: Text('提交')),
          )
        ],
      ),
    );
  }

  Widget infoTitle(String title) {
    return Container(
        color: Color(0xffe4e4e4),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(title));
  }

/*选择列表*/
  showPicker() {
    List<PickerItem> _picerItem =
        _bindClass.map((e) => PickerItem(text: Text(e['className']))).toList();
    Picker picker = Picker(
      adapter: PickerDataAdapter(data: _picerItem),
      title: Text('选择班级'),
      onConfirm: (picker, selecteds) {
        // print(selecteds);
        this.setState(() {
          _health.className = _bindClass[selecteds[0]]['className'];
          _health.classId = _bindClass[selecteds[0]]['classId'];
        });
      },
    );
    picker.show(_scaffoldKey.currentState);
  }

  void openSearch() {
    if(_health.className!=null){
      // print('params:${_health.classId}');
      Navigator.of(context).pushNamed('/searchStudent',arguments: Argument(params:_health.classId));

    }else{
      FLToast.info(text:'请选择班级');
    }
  }

  Future _healthReport() async {
   var res = await healthReport(_health);
   
   if(res==null){
     Navigator.of(context).pop();
   }
  }
}
