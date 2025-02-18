import 'dart:math';

import 'mqtt_bridge.dart';
import 'mqtt_service.dart';
import 'typedef.dart';

class MQTTClient {

  late MqttService mqttService;

  final String subscribeTopic = 'hsm_v2/topic';

  final VoidCallbackBoolString callbackFunction;
  final Random random = Random();
  final MQTTBridge bridge;

  MQTTClient(this.callbackFunction, this.bridge) {
    mqttService = MqttService(callbackFunction, bridge);
  }

  //final MqttService mqttService = MqttService();

  void post (String event) {
    // Future.delayed(const Duration(seconds: 1), () {
    //   callbackFunction.call(oracle(), event);
    // });
    switch (event) {
      case 'Connect':
        connect();
        break;
      case 'Subscribe':
        subscribe();
        break;
      case 'Publish':
        publish();
        break;
      case 'Unsubscribe':
        unsubscribe();
        break;
      // case 'OnUnsubscribe':
      //   print('------- OnUnsubscribe -------');
      //   break;
      case 'Disconnect':
        disconnect();
        break;
      // case 'OnDisconnect':
      //   print('------- OnDisconnect -------');
      //   break;

    }
  }

  void connect () {
    print('******* connect *******');
    mqttService.connect();
  }

  void subscribe () {
    print('******* subscribe *******');
    mqttService.subscribe(subscribeTopic);
  }

  void publish () {
    print('******* publish *******');
    mqttService.publish(subscribeTopic, randomString(32));
    //callbackFunction.call(oracle(), 'Publish');
  }

  void unsubscribe () {
    print('******* unsubscribe *******');
    mqttService.unsubscribe(subscribeTopic);
    //callbackFunction.call(oracle(), 'Unsubscribe');
  }

  void disconnect () {
    print('******* disconnect *******');
    mqttService.disconnect();
    //callbackFunction.call(oracle(), 'Disconnect');
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

  String randomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void setUnitTest() {
    mqttService.setUnitTest();
  }

}