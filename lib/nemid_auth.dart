import 'dart:async';
import 'package:flutter/services.dart';

class NemId {
  static const MethodChannel _channel = const MethodChannel('nemid_auth');

  static Future<void> setNemIdEndpoints({
    String signing,
    String validation,
    bool isDev,
  }) async {
    try {
      await _channel.invokeMethod('setNemIdEndpoints', {
        "signing": signing,
        "validation": validation,
        "isDev": isDev,
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<String> get authWithNemID async {
    final String response = await _channel.invokeMethod('authWithNemID');
    return response;
  }
}
