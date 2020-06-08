import 'package:flutter/material.dart';
import 'package:health/model/global.dart';
import 'package:health/model/profile.dart';

class ProfileNotify with ChangeNotifier{
  Profile get value=>Global.profile;
  @override
  void notifyListeners() {
    Global.save();
    super.notifyListeners();
  }
}