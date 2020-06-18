import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/health.dart';
class HealthDetail extends StatefulWidget {
  final String title = '晨午检详情';
  final Argument arg;
  HealthDetail({this.arg});
  @override
  _HealthDetailState createState() => _HealthDetailState();
}

class _HealthDetailState extends State<HealthDetail> {
    @override
  Widget build(BuildContext context) {
    Argument arg = ModalRoute.of(context).settings.arguments;
    Health health = Health.fromJson(arg.params);
    // print('arg${health.measure}');
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
          children: <Widget>[
             ListTile(
              title: Text('学生信息:'),
              trailing: Text(health.name ?? ''),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('学校名称:'),
              trailing: Text(health.schoolName ?? ''),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('所属班级:'),
              trailing: Text(health.className ?? ''),
            ),
            Divider(height: 1),
           
            ListTile(
              title: Text('登记类型:'),
              trailing: Chip(label: Text(Dictionary.getNameByUniqueNameAndCode(
                uniqueName: UniqueNameValues[
                                        UNIQUE_NAME.REGISTERTYPE],
                                    code: health.registerType
              ) ?? '')),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('上报类型:'),
              trailing: Chip(label: Text(Dictionary.getNameByUniqueNameAndCode(uniqueName:UniqueNameValues[UNIQUE_NAME.CHECKTYPE],code:health.checkType))),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('发病日期:'),
              trailing: Text(health.illDate ?? ''),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('离校日期:'),
              trailing: Text(health.leaveDate ?? ''),
            ),
            Divider(height: 1),
            infoTitle('症状信息'),
            ListTile(
              title: Text('学生症状:'),
              trailing: Text(Dictionary.getNameByUniqueNameAndCode(uniqueName:UniqueNameValues[UNIQUE_NAME.SYMPTOMTYPE],code:health.symptomType)),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('是否就诊:'),
              trailing: Chip(label: Text(health.isHealed ?? '')),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('病例类型:'),
              trailing: Chip(label: Text(Dictionary.getNameByUniqueNameAndCode(uniqueName:UniqueNameValues[UNIQUE_NAME.ILLTYPE],code:health.illType))),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('就诊日期:'),
              trailing: Text(health.healDate??''),
            ),
            Divider(height: 1),
            
            Offstage(
              offstage: (health.illType!=null&&health.illType != '3') ? false : true,
              child: infoTitle(getTypeValue(health.illType)),
            ),
            Offstage(
              offstage: (health.hurtType != null)?false:true,
              child: ListTile(
                title: Text('伤害信息'),
                trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                  uniqueName:UniqueNameValues[UNIQUE_NAME.HURTTYPE],
                  code:health.hurtType
                )),
              ),
            ),
            Offstage(
              offstage: (health.hurtSite != null)
                  ? false
                  : true,
              child: ListTile(
                title: Text('伤害地点'),
                trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                        uniqueName: UniqueNameValues[UNIQUE_NAME.HURTSITE],
                        code: health.hurtSite)),
              ),
            ),
           
            Offstage(
              offstage: (health.infectionType!=null)
                  ? false
                  : true,
              child: ListTile(
                title: Text('确诊详情'),
                trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                        uniqueName: UniqueNameValues[UNIQUE_NAME.INFECTIONTYPE],
                        code: health.infectionType) ??
                    ''),
              ),
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

  String getTypeValue(code) {
    var item = Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.ILLTYPE], code: code);
    return '$item信息';
  }
}


