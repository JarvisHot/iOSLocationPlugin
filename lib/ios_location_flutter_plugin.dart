
import 'dart:async';

import 'package:flutter/services.dart';

class IosLocationFlutterPlugin {
  IosLocationFlutterPlugin._() {
    print("ios location plugin init");
  }
  static final IosLocationFlutterPlugin _instance = new IosLocationFlutterPlugin._();
  static IosLocationFlutterPlugin get instance => _instance;
  final methodChannel = const MethodChannel('ios_location_flutter_plugin');
  Future<Map<String,dynamic>> startLocation() async {
   Map? dic = await methodChannel.invokeMapMethod("startLocation");
   return dic?.cast<String,dynamic>() ?? {};
  }
}
