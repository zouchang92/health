

import 'dart:io';

import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  PermissionHandler().requestPermissions([PermissionGroup.photos,PermissionGroup.camera]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
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
            return MaterialPageRoute(maintainState: true,
                builder: routes[routeName], settings: routeSetting);
          } else {
            return MaterialPageRoute(builder: (context) => NotFound(),maintainState: routeSetting.arguments==null?false:true);
          }
        } else {
          return MaterialPageRoute(builder: routes['/login'],maintainState: false);
        }
      },
      builder: (context, child) {
        return FLToastProvider(child: child);
      },
    );
  }
}
