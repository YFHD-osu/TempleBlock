import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings{
  Settings._();

  static Settings? _instance;
  static Settings get instance {
    _instance ??= Settings._();
    return _instance!;
  }

  bool stick = false;
  bool volume = false;
  bool vibration = false;
  double autoSpeed = 0;
  ValueNotifier<int> hitCount = ValueNotifier(0);

  Future<int> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    volume = prefs.getBool('volume') ?? true;
    vibration = prefs.getBool('vibration') ?? true;
    stick = prefs.getBool('stick') ?? true;
    autoSpeed = prefs.getDouble("autoSpeed") ?? 60.0;
    return 0;
  }

  int convertBPM() {
    //print( (1 / (autoSpeed / 60) * 1000).round());
    return (1 / (autoSpeed / 60) * 1000).round();
  }

}