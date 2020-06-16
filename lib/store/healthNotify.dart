import 'package:flutter/material.dart';
import 'package:health/model/health.dart';

class HealthNotify with ChangeNotifier{
  Health _health;
  Health get value =>  _health;
  // @override
  // void notifyListeners() {
    
  //   super.notifyListeners();
  // }
  void save(Health health){
    _health = health;
    notifyListeners();
  }
}