import 'package:flutter/material.dart';
import 'package:health/store/profileNotify.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:health/views/index.dart';
import 'model/global.dart';
import 'routes/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // requestPermission();
  final _profileNotify = ProfileNotify();
  Global.init().then((e) => runApp(
    Provider<bool>.value(
      value: true,
      child: ChangeNotifierProvider.value(
        value: _profileNotify,
        child: MyApp(),
      ),
    )
  ));
}

Future requestPermission() async {
  PermissionHandler().requestPermissions([PermissionGroup.photos]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '家校通',
      locale: Locale('zh', 'CH'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Colors.blue,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary)
      ),

       onGenerateRoute:(RouteSettings routeSetting){
        // print('routeSetting$routeSetting');
        String routeName = routeSetting.name;
        
        print('${Global.profile.isLogin}');
        if (Global.profile.isLogin!=null&&Global.profile.isLogin == true) {
          if(routes[routeName]!=null){
          return MaterialPageRoute(
              builder: routes[routeName], settings: routeSetting);
          }else{
            return MaterialPageRoute(
              builder: (context)=>NotFound()); 
          }

        }else{
          return MaterialPageRoute(
              builder: routes['/login']);
        }
        
      },
    );
  }
}


