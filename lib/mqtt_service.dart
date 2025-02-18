import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'client_helper.dart';
import 'mqtt_bridge.dart';
import 'typedef.dart';

class MqttService {

  static const String _server = 'test.mosquitto.org';
  //static const String _server = 'broker.hivemq.com';
  static String flutterClient = ClientHelper.instance()?.clientId()?? 'flutter_client' ;//'flutter_client';
  final MqttServerClient _client = MqttServerClient(_server, flutterClient);
  final VoidCallbackBoolString _cb;
  final MQTTBridge bridge;

  late bool unittest = false;

  MqttService(this._cb, this.bridge) {
    _client.logging(on: false); //  true
    _client.setProtocolV311();
    _client.connectTimeoutPeriod = 2000;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onUnsubscribed = onUnsubscribed;
  }

  void setUnitTest() {
    unittest = true;
  }

  void connect() {
    if (unittest) {
      return;
    }

    final connMess = MqttConnectMessage()
        .withClientIdentifier(flutterClient)
        .startClean();
    _client.connectionMessage = connMess;
    _client.connect().then((_) {
      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String pt = c[0].topic;
          onMessageReceived(pt, recMess);
        });
      }
      else {
        _cb.call(false, 'Connect', true);
        print(
            'ERROR MQTT client connection failed - disconnecting, status is ${_client.connectionStatus}');
        disconnect();
      }
    }).catchError((error) {
      _cb.call(false, 'Connect', true);
      print('Exception: $error');
      disconnect();
    });
  }

  void disconnect() {
    if (unittest) {
      return;
    }
    _client.disconnect();
  }

  void subscribe(String topic) {
    if (unittest) {
      return;
    }
    try {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
    catch (exception) {
      _cb.call(false, 'Subscribe', true);
    }
  }

  void unsubscribe(String topic) {
    if (unittest) {
      return;
    }
    _client.unsubscribe(topic);
  }

  void publish(String topic, String message) {
    if (unittest) {
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    try {
      _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      _cb.call(true, 'Publish', true);
    }
    catch (exception) {
      _cb.call(false, 'Publish', true);
    }
  }

  void onMessageReceived(String topic, MqttPublishMessage message) {
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    print('Received message: $payload from topic: $topic');
  }

  void onConnected() {
    print('******* onConnected $flutterClient *******');
    _cb.call(true, 'Connect', true);
  }

  void onDisconnected() {
    print('******* onDisconnected ******* [${bridge.state()}]');
    _cb.call(true, 'Disconnect', false);
    if (bridge.isConnected()) {
      bridge.post('Disconnect');
      //bridge.post('OnDisconnected');
    }
    ///disconnect();
  }

  void onSubscribed(String topic) {
    print('******* onSubscribed to topic: $topic *******');
    _cb.call(true, 'Subscribe', true);
  }

  void onUnsubscribed(String? topic) {
    print('***!*** onUnsubscribed from topic: $topic ***!*** ${bridge.state()}');
    _cb.call(true, 'Unsubscribe', false);
    if (bridge.isSubscribed()) {
      bridge.post('Unsubscribe');
    }
  }

}