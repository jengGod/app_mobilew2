import 'dart:convert';

import 'package:flutter/services.dart';

class Configuration {
  static Future <Map<String, dynamic>> getConfig(){
    return rootBundle.loadString('assets/image/config/config.json').then(
    (value){
      //convert string to object 
      return jsonDecode(value) as Map<String, dynamic>;
    },
    );
  }
}