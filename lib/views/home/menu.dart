import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:health/model/global.dart';
import 'package:health/model/profile.dart';
import 'package:health/value/menuValue.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final int gridVIEWITEMCOUNT = 3;
  final String defalutBanner = 'images/banner.png';
  /*轮播-通知-数据*/
  List images = [
    // {"picUrl": 'images/upload_bg.png', "title": '通知标题'},
    // {"picUrl": 'images/upload_bg.png', "title": '通知标题2'}
  ];
  Profile _profile = Global.profile;
  /*菜单-教师*/
  List menus ;
  @override
  void initState() {
    print(_profile.news);
    images = _profile.news??[];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return ListView(
      children: <Widget>[column1(), gridContainer()],
    );
    // return gridContainer();
  }

  /*卡片1-卡片容器*/
  Widget column1() {
    return Card(
      margin: EdgeInsets.all(15.0),
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child:images.length>0?swiper():swiperItem(imageUrl:'images/banner.png',title:'暂无通知'),
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
            return swiperItem(
                imageUrl: images[index]['cover']??defalutBanner,
                title: images[index]['title']);
          },
          autoplay: true,
          pagination: new SwiperPagination(),
        ),
      ),
      FlatButton(
          onPressed: () {},
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.blueAccent),
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
              // decoration: ,
              child: Text('更多', style: TextStyle(color: Colors.white))))
    ]);
  }

  /*轮播-项*/
  Widget swiperItem({String imageUrl, String title}) {
    return Stack(
      alignment: FractionalOffset(0.1, 0.2),
      children: <Widget>[
        Image.asset(
          imageUrl,
          height: 200.0,
          fit: BoxFit.cover,
        ),
        Text(
          title,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  /*功能按钮-container*/
  Widget gridContainer() {
    // print('profile${_profile.user.personType}');
    if((_profile.user.personType!=null)&&(_profile.user.personType=='parentDuty')){
         menus = MenuValue.PARENT_VALUE;
    }else{
      menus = MenuValue.TEACHER_VALUE;
    }
    print('menus:$menus');
    //  menus = _profile.user.personType=='teacherDuty'?MenuValue.TEACHER_VALUE:MenuValue.PARENT_VALUE;
   

    double _widthItem =
        (MediaQuery.of(context).size.width) / gridVIEWITEMCOUNT;
    // print(_width);
    int lenth = menus.length;
    double _height = ((lenth - 1) / gridVIEWITEMCOUNT + 1) * _widthItem;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: _height,
      child: menuButtons(),
    );
  }

  /*功能按钮*/
  Widget menuButtons() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridVIEWITEMCOUNT),
        itemCount: menus.length,
        itemBuilder: (_, index) {
          return FlatButton(
              onPressed: (){
                Navigator.of(context).pushNamed(menus[index]['path']);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Image.asset(menus[index]['picUrl']),
                  CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(menus[index]['picUrl'])),
                  Text(
                    menus[index]['title'],
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ));
        });
  }
}
