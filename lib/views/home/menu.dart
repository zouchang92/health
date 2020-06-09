import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // final int GRID_VIEW_ITEM_COUNT = 4;
  List images = [
    'images/upload_bg.png',
    'images/upload_bg.png',
    'images/upload_bg.png'
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Image.asset('images/upload_bg.png')
      ],
    );
  }
  /*卡片1-卡片容器*/
  Widget column1(){
    return Card(
      child: swiper(),
    );
  } 
  /*卡片1-轮播图*/ 
  Widget swiper(){
    return Container(
      height: 150.0,
      child: Swiper(
        itemCount: images.length,
        itemBuilder: (_,index){
          return Image.asset(images[index]);
        },
        autoplay: true,
        pagination: new SwiperPagination(),
      ),
    );
  }
}