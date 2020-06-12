import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/global.dart';

import 'package:health/model/profile.dart';

class ProfileNotify with ChangeNotifier{
  Argument args;
  Profile get value=>Global.profile;
  Argument get argValue=>args;
  @override
  void notifyListeners() {
    Global.save();
    super.notifyListeners();
  }
  void saveArg(Argument _args){
     args = _args;
     super.notifyListeners();
  }
}