import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  final String title ='选择学生';
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List studentList = [];
  List<int> selecteds;
  bool showFloatButton = false;
  @override
  void initState() {
    studentList = [{"name":'李突发'},{"name":'地'}];
    selecteds = [];
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){})
        ],
      ),
      body:list(context),
      floatingActionButton:showFloatButton? FloatingActionButton(onPressed: (){},child: Text('确认')):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget list(BuildContext context){
     return ListView.builder(
      itemCount:studentList.length,
      itemBuilder: (BuildContext context,int index){
       return  CheckboxListTile(
        title: Text(studentList[index]['name']),
        value: this.selecteds.length>0?selecteds.contains(index):false, onChanged: (bool status){
          if(status){
             this.setState(() { 
              //  this.selecteds.add(index);
               if(this.selecteds.length==0||(this.selecteds.length>0&&!this.selecteds.contains(index))){
                 this.selecteds.add(index);
               }
               if(this.selecteds.length>0){
                this.showFloatButton = true;
              }else{
                this.showFloatButton = false;
              }

             });
          }else{
            this.setState(() { 
              this.selecteds.remove(index);
              
              if(this.selecteds.length>0){
                this.showFloatButton = true;
              }else{
                this.showFloatButton = false;
              }
            });
          }
          // print('selecteds${this.selecteds}');
         
        }
      );
     });
  }
}