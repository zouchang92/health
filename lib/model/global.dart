
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';

class Global{
  static SharedPreferences prefs;
  static String token;
  static Profile profile = Profile();
  static save() async{
    prefs.setString('profile', json.encode(profile.toJson()));
  }
  static Future quit() async{
     prefs = await SharedPreferences.getInstance();
     profile.isLogin = false;
     save();
  }
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
    // int _count = prefs.getInt('count');
    var _profile = prefs.getString('profile');
    
   
    if(_profile != null){
      try{
        var testprofile = json.decode(_profile);
        // print('_profile$_profile');
        // print('test_profile${testprofile['isLogin']}');
        profile = Profile.fromJson(testprofile);
        
      }catch(e){
        print(e);
      }
    }
}