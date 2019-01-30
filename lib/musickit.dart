import 'dart:async';

import 'package:flutter/services.dart';


class Musickit {
  static const MethodChannel _channel = const MethodChannel('musickit');

  static Future<String> get ping async {
    final String result = await _channel.invokeMethod('ping');
    return result;
  }

  static Future<String> get appleMusicRequestPermission async {
    final String result = await _channel.invokeMethod('appleMusicRequestPermission');
    return result;
  }

  static Future<String> get appleMusicCheckIfDeviceCanPlayback async {
    final String result = await _channel.invokeMethod('appleMusicCheckIfDeviceCanPlayback');
    return result;
  }

  static Future<String> get fetchUserToken async {
    final String result = await _channel.invokeMethod('fetchUserToken');
    return result;
  }

  static Future<String> appleMusicPlayTrackId(List ids) async {
    final String result = await _channel.invokeMethod('appleMusicPlayTrackId', ids);
    return result;
  }
}
