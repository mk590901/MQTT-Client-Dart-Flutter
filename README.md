# MQTT-Client-Dart

MQTT Client Flutter demo app.

## Introduction

The application uses package https://pub.dev/packages/mqtt_client to implement access, communication, subscription, and sending and receiving data via the __MQTT bridge__ host. The package isn't used directly, but indirectly, through the hierarchical state machine by sending events and receiving messages about the end of operations. This allows for simplified sending and receiving data and error handling.

## MQTT Client State Machine

Below is some information about the created hierarchical state machine.

### Scheme

The Hierarchical state machine diagram describing the behavior of the __MQTT__ client is shown below in the figure. There are three main states: __disconnected__, __connected__ and __subscribed__ and several intermediate states: __connecting__, __subscribing__ and __publishing__. The state machine is controlled via events: _connect_, _subscribe_, _publish_, _unsubscribe_ and _disconnect_. 

![output1](https://github.com/user-attachments/assets/07f5f09e-0a0e-4788-b126-dddf5defe84f)


## Movie

https://github.com/user-attachments/assets/2bb69c78-24fc-4dcc-85b9-9132a644fd4f

