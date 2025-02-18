import 'dart:io';
import 'dart:math';

import 'mqtt_cs_8_helper.dart';
//import 'mqtt_cs_9_helper.dart';
import 'typedef.dart';

class MQTTBridge {
  late MqttHelper  _hsmHelper;
  final VoidCallbackBoolString callbackFunction;
  final Random random = Random();

  void response(bool ok, String text, bool next) {
    print('MQTTBridge.response->[$text]->[$ok]');
    callbackFunction.call(ok,text, next);
    if (ok) {
      if (next) {
        post('Succeeded');
      }
    }
    else {
      if (next) {
        post('Failed');
      }
    }
  }

  MQTTBridge (this.callbackFunction) {
    _hsmHelper = MqttHelper(response, this);
    _hsmHelper.init();
  }

  String state() {
    return _hsmHelper.state();
  }

  void post (String eventName){
    _hsmHelper.run(eventName);
  }

  void post2 (String eventName, VoidCallback succeeded, VoidCallback failed,){
    //_hsmHelper.run(eventName);
    //Future.delayed(Duration(seconds: 2));
    sleep(Duration(seconds: 2));
    if (oracle()) {
      succeeded();
    } else {
      failed();
    }
  }


  bool oracle() {
    int value = getRandomInRange(1,100);
    return true; //(value > 30 ? true : false);
  }

  int getRandomInRange(int min, int max) {
    if (min > max) {
      throw ArgumentError('min should be less than or equal to max');
    }
    return min + random.nextInt(max - min + 1);
  }

  bool isSubscribed() {
    bool result = false;
    if (state() == 'AwaitPublishing') {
      result = true;
    }
    return result;
  }

  bool isConnected() {
    bool result = true;
    if (state() == 'Disconnected') {
      result = false;
    }
    return result;
  }

  void setUnitTest() {
    _hsmHelper.setUnitTest();
  }

}