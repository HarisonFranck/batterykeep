import 'package:flutter/services.dart';

class BatteryEventService {
  static const EventChannel _eventChannel = EventChannel(
    'com.batterykeep.battery.events',
  );

  Stream<dynamic> get stream {
    return _eventChannel.receiveBroadcastStream();
  }
}
