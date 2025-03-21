# MQTT-Client-Dart

MQTT Client Flutter demo app.

## Introduction

The application uses package https://pub.dev/packages/mqtt_client to implement access, communication, subscription, and sending and receiving data via the __MQTT bridge__ host. The package isn't used directly, but indirectly, through the hierarchical state machine by sending events and receiving messages about the end of operations. This allows for simplified sending and receiving data and error handling.

## MQTT Client State Machine

Below is some information about the created hierarchical state machine.

### Scheme

The Hierarchical state machine diagram describing the behavior of the __MQTT__ client is shown below in the figure. There are three main states: __disconnected__, __connected__ and __subscribed__ and several intermediate states: __connecting__, __subscribing__ and __publishing__. The state machine is controlled via events: _connect_, _subscribe_, _publish_, _unsubscribe_ and _disconnect_. 

![output1](https://github.com/user-attachments/assets/07f5f09e-0a0e-4788-b126-dddf5defe84f)

### Implementation

State machine was automatically generated by the graphical editor and is presented in the module __MqttHelper__ (_mqtt_cs_8_helper.dart_)  as a class with set of transfer functions that interact with the pub dev __mqtt_client__ package via the custom __MQTTClient__ object. The responses in the form of events _succeeded_ and _failed_ are sent back to the state machine, causing a change in its states. Threaded code interpretation is used. This approach is simple, compact and transparent.

## Description of the application

The screen is divided into two parts. At the top is a set of buttons corresponding to the operations that the mqtt client can perform, at the bottom is the result of performing these operations. Don't be afraid to mix operations up by performing them in a different order than the logic suggests: the state machine will respond to the error with messages. Pay attention to the publish operation. In the list of messages, after the word publish, a line of random characters appears: this is the message that the client sends to cloud. Note that sometimes lines of random characters appear without any connection with the execution of the publish command. This is not an error. It's just that the same application was launched in parallel on the second phone, we just see the data sent by this second application. Actually, this is the whole point of the demo: using the __mqtt__ client, you can easily exchange data between applications.

Note. The application uses the __free host__ _test.mosquitto.org_ as an __MQTT__ broker. You can also use _broker.hivemq.com_ (mqtt_service.dart). Just keep in mind that sometimes during the day the excessive load on these sites creates problems when connecting.

## Movie

https://github.com/user-attachments/assets/2bb69c78-24fc-4dcc-85b9-9132a644fd4f

