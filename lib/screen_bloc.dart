import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'mqtt_bridge.dart';

// Events
abstract class ButtonEvent extends Equatable {
  const ButtonEvent();

  @override
  List<Object> get props => [];
}

class ButtonPressed extends ButtonEvent {
  final String button;

  const ButtonPressed(this.button);

  @override
  List<Object> get props => [button];
}

class ButtonPressedSuccess extends ButtonEvent {
  final String button;
  final String message;

  const ButtonPressedSuccess(this.button, this.message);

  @override
  List<Object> get props => [button, message];
}

class ButtonPressedFailed extends ButtonEvent {
  final String button;
  final String errorMessage;

  const ButtonPressedFailed(this.button, this.errorMessage);

  @override
  List<Object> get props => [button, errorMessage];
}

// States
abstract class ButtonState extends Equatable {
  const ButtonState();

  @override
  List<Object> get props => [];

  get messages => null;

  get buttonStates => null;
}

class ButtonInitial extends ButtonState {
  @override
  final List<String> messages;
  @override
  final Map<String, bool> buttonStates;

  const ButtonInitial(this.messages, this.buttonStates);

  @override
  List<Object> get props => [messages, buttonStates];
}

class ButtonLoading extends ButtonState {
  final String button;
  @override
  final List<String> messages;
  @override
  final Map<String, bool> buttonStates;

  const ButtonLoading(this.button, this.messages, this.buttonStates);

  @override
  List<Object> get props => [button, messages, buttonStates];
}

class ButtonSuccess extends ButtonState {
  final String button;
  @override
  final List<String> messages;
  @override
  final Map<String, bool> buttonStates;

  const ButtonSuccess(this.button, this.messages, this.buttonStates);

  @override
  List<Object> get props => [button, messages, buttonStates];
}

class ButtonFailure extends ButtonState {
  final String button;
  @override
  final List<String> messages;
  @override
  final Map<String, bool> buttonStates;

  const ButtonFailure(this.button, this.messages, this.buttonStates);

  @override
  List<Object> get props => [button, messages, buttonStates];
}

// BLoC
class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {

  late MQTTBridge mqttBridge;

  late ButtonPressed currentEvent;

  ButtonBloc()
      : super(ButtonInitial([], {
    'Connect': false,
    'Subscribe': false,
    'Publish': false,
    'Unsubscribe': false,
    'Disconnect': true,
  })) {

    mqttBridge = MQTTBridge(response);

    on<ButtonPressed>((event, emit) {
      final currentMessages = state.messages;
      final currentButtonStates = state.buttonStates;
      emit(ButtonLoading(event.button, currentMessages, currentButtonStates));

      // Save event в in variable
      currentEvent = event;

      asyncFunction(event.button);

    });

    on<ButtonPressedSuccess>((event, emit) {
      final List<String> currentMessages = List.from(state.messages)..add(event.message);
      final Map<String, bool> currentButtonStates = Map.from(state.buttonStates)
        ..[event.button] = true;

      if (event.button == 'Connect' || event.button == 'Subscribe' || event.button == 'Publish') {
        currentButtonStates['Disconnect'] = false;
      } else if (event.button == 'Unsubscribe') {
        currentButtonStates['Connect'] = false;
        currentButtonStates['Subscribe'] = false;
        currentButtonStates['Publish'] = false;
      } else if (event.button == 'Disconnect') {
        currentButtonStates['Connect'] = false;
        currentButtonStates['Subscribe'] = false;
        currentButtonStates['Publish'] = false;
        currentButtonStates['Unsubscribe'] = false;
      }

      emit(ButtonSuccess(event.button, currentMessages, currentButtonStates));
    });

    on<ButtonPressedFailed>((event, emit) {
      final List<String> currentMessages = List.from(state.messages)..add(event.errorMessage);
      final Map<String, bool> currentButtonStates = Map.from(state.buttonStates)
        ..[event.button] = false;
      emit(ButtonFailure(event.button, currentMessages, currentButtonStates));
    });
  }

  void asyncFunction(String button) {
    mqttBridge.post(button);
  }

  void response(bool rc, String text, bool next) {

    print ('response $rc [$text]');
    if (rc) {
      add(ButtonPressedSuccess(currentEvent.button, text));
    } else {
      add(ButtonPressedFailed(currentEvent.button, text));
    }
  }
}
