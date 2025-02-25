import 'dart:math';

import 'mqtt_bridge.dart';
import 'mqtt_service.dart';
import 'typedef.dart';

class MQTTClient {

  late MqttService mqttService;

  final String subscribeTopic = 'hsm_v2/topic';
  final VoidCallbackBoolString callbackFunction;
  final MQTTBridge bridge;

  MQTTClient(this.callbackFunction, this.bridge) {
    mqttService = MqttService(callbackFunction, bridge);
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

  String randomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void setUnitTest() {
    mqttService.setUnitTest();
  }

}