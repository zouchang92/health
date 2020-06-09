import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final int GRID_VIEW_ITEM_COUNT = 4;
  /*
  'images/upload_bg.png',
    'images/upload_bg.png',
    'images/upload_bg.png'
  */ 
  List images = [
    {
      "picUrl":'images/upload_bg.png',
      "title":'通知标题'
    },{
      "picUrl":'images/upload_bg.png',
      "title":'通知标题2'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[column1()],
    );
  }

  /*卡片1-卡片容器*/
  Widget column1() {
    return Card(
      margin: EdgeInsets.all(15.0),
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: swiper(),
    );
  }

/*
Text('更多',style: TextStyle(color:Colors.white))
*/
  /*卡片1-轮播图*/
  Widget swiper() {
    return Stack(alignment: FractionalOffset(1, 0.9), children: <Widget>[
      Container(
        height: 200.0,
        child: Swiper(
          itemCount: images.length,
          itemBuilder: (_, index) {
            // print(images[index]);
            return swiperItem(imageUrl: images[index]['picUrl'], title: images[index]['title']);
          },
          autoplay: true,
          pagination: new SwiperPagination(),
        ),
      ),
      FlatButton(
        
        onPressed: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius:BorderRadius.all(Radius.circular(10.0)),
            color: Colors.blueAccent
          ),
          
          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
          // decoration: ,
          child:Text('更多',style: TextStyle(color:Colors.white))
        )
      )
    ]);
  }

  /*轮播-项*/
  Widget swiperItem({String imageUrl, String title}) {
    return Stack(
      alignment: FractionalOffset(0.1, 0.8),
      children: <Widget>[
        Image.asset(
          imageUrl,
          height: 200.0,
          fit: BoxFit.cover,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  /*功能按钮*/ 
  Widget menuButtons(){
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: GRID_VIEW_ITEM_COUNT
      ), 
      itemBuilder: (_,index){
        return Column(
          children: <Widget>[
            Image.asset('images/icon/menu_icon_1.png'),
            Text('平安上报')
          ],
        );
      }
     );
  }
}
