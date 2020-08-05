import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/store/profileNotify.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:health/views/index.dart';
import 'model/global.dart';
import 'model/profile.dart';
import 'routes/index.dart';

// import 'package:flui/widgets/toast.dart';
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermission();
  final _profileNotify = ProfileNotify();

  Global.init().then((e) => runApp(Provider<Profile>.value(
        value: Global.profile,
        child: ChangeNotifierProvider.value(
          value: _profileNotify,
          child: MyApp(),
        ),
      )));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

Future requestPermission() async {
  PermissionHandler()
      .requestPermissions([PermissionGroup.photos, PermissionGroup.camera]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
        child: MaterialApp(
      title: '家校通',
      locale: Locale('zh', 'CH'),
      localizationsDelegates: [
        PickerLocalizationsDelegate.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        // const Locale('en', 'US'),
      ],
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Colors.blue,
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary)),
      onGenerateRoute: (RouteSettings routeSetting) {
        print('routeSetting${routeSetting.arguments}');
        String routeName = routeSetting.name;

        // print('${Global.profile.isLogin}');
        if (Global.profile.isLogin != null && Global.profile.isLogin == true) {
          if (routes[routeName] != null) {
            // return MaterialPageRoute(maintainState:keepAliveList.firstWhere((element) => element == routeName,orElse: (){return null;})!=null?true:false ,
            //     builder: routes[routeName], settings: routeSetting);
            return PageRouteBuilder(
              settings: routeSetting,
              pageBuilder: routes[routeName],
              maintainState: keepAliveList.firstWhere(
                          (element) => element == routeName, orElse: () {
                        return null;
                      }) !=
                      null
                  ? true
                  : false,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                Global.appContext = context;
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.fastOutSlowIn)),
                  child: child,
                );
              },
            );
          } else {
            // return MaterialPageRoute(
            //     builder: (context) => NotFound(), maintainState: false);
            return PageRouteBuilder(pageBuilder: (context, a, b) {
              return NotFound();
            });
          }
        } else {
          // return MaterialPageRoute(builder: routes['/login'],maintainState: false);
          return PageRouteBuilder(
            pageBuilder: routes['/login'],
            maintainState: false,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                        begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(CurvedAnimation(
                        parent: animation, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            },
          );
        }
      },
      // builder: (context, child) {
      //   return Scaffold(body: FlutterEasyLoading(child: child));
      //   // return FlutterEasyLoading(child: child);
      // },
    ));
  }
}
