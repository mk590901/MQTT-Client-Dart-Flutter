// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_ff_client/client_helper.dart';
import 'package:mqtt_ff_client/mqtt_bridge.dart';

void response(bool ok, String text, bool next) {
  if (ok) {
    print('Succeeded: $text');
  }
  else {
    print('Failed:    $text');
  }
}

void main() {
  ClientHelper.initInstance();

  test('Init', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge,isNotNull);
    expect(bridge.state(), 'Disconnected');
  });

  test('Connect', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
  });

  test('Connect-Failed', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Failed');
    expect(bridge.state(), 'Disconnected');
  });

  test('Connect-Succeeded', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
  });

  test('AwaitSubscribe-Connect', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Connect');
    expect(bridge.state(), 'AwaitSubscribe');
  });

  test('AwaitSubscribe-Subscribe', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
  });

  test('AwaitSubscribe-Subscribe-Failed', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
    bridge.post('Failed');
    expect(bridge.state(), 'AwaitSubscribe');
  });

  test('AwaitSubscribe-Subscribe-Succeeded', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitPublishing');
  });

  test('AwaitPublishing-Connect', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitPublishing');
    bridge.post('Connect');
    expect(bridge.state(), 'AwaitPublishing');
  });

  test('AwaitPublishing-Publish', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitPublishing');
    bridge.post('Publish');
    expect(bridge.state(), 'Publishing');
  });

  test('AwaitPublishing-Publishing-Publish-Failed', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitPublishing');
    bridge.post('Publish');
    expect(bridge.state(), 'Publishing');
    bridge.post('Failed');
    expect(bridge.state(), 'AwaitPublishing');
  });

  test('AwaitPublishing-Publishing-Publish-Succeeded', () {
    MQTTBridge bridge = MQTTBridge(response);
    bridge.setUnitTest();
    expect(bridge.state(), 'Disconnected');
    bridge.post('Connect');
    expect(bridge.state(), 'Connecting');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitSubscribe');
    bridge.post('Subscribe');
    expect(bridge.state(), 'Subscribing');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitPublishing');
    bridge.post('Publish');
    expect(bridge.state(), 'Publishing');
    bridge.post('Succeeded');
    expect(bridge.state(), 'AwaitPublishing');
  });

}
