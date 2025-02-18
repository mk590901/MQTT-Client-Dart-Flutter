import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'mqtt_bridge.dart';

// События
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

// Состояния
abstract class ButtonState extends Equatable {
  const ButtonState();

  @override
  List<Object> get props => [];

  get messages => null;

  get buttonStates => null;
}

class ButtonInitial extends ButtonState {
  final List<String> messages;
  final Map<String, bool> buttonStates;

  const ButtonInitial(this.messages, this.buttonStates);

  @override
  List<Object> get props => [messages, buttonStates];
}

class ButtonLoading extends ButtonState {
  final String button;
  final List<String> messages;
  final Map<String, bool> buttonStates;

  const ButtonLoading(this.button, this.messages, this.buttonStates);

  @override
  List<Object> get props => [button, messages, buttonStates];
}

class ButtonSuccess extends ButtonState {
  final String button;
  final List<String> messages;
  final Map<String, bool> buttonStates;

  const ButtonSuccess(this.button, this.messages, this.buttonStates);

  @override
  List<Object> get props => [button, messages, buttonStates];
}

class ButtonFailure extends ButtonState {
  final String button;
  final List<String> messages;
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
      // asyncFunction(event.button, (bool rc, String text) {
      //   response(rc, text);
      // });

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

  // void asyncFunction(String button, void Function(bool, String) callback) {
  //   execute(button, callback);
  // }

  void asyncFunction(String button) {
    mqttBridge.post(button);
  }

  // void execute(String button, void Function(bool, String) callback) {
  //   Future.delayed(Duration(seconds: 2), () {
  //     if (button == 'Connect' || button == 'Publish') {
  //       callback(true, 'Operation $button succeeded');
  //     } else if (button == 'Subscribe') {
  //       callback(false, 'Operation $button failed');
  //     } else {
  //       callback(true, 'Operation $button succeeded');
  //     }
  //   });
  // }

  void response(bool rc, String text, bool next) {
    if (rc) {
      add(ButtonPressedSuccess(currentEvent.button, text));
    } else {
      add(ButtonPressedFailed(currentEvent.button, text));
    }
  }
}


// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// // События
// abstract class ButtonEvent extends Equatable {
//   const ButtonEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ButtonPressed extends ButtonEvent {
//   final String button;
//
//   const ButtonPressed(this.button);
//
//   @override
//   List<Object> get props => [button];
// }
//
// // Состояния
// abstract class ButtonState extends Equatable {
//   const ButtonState();
//
//   @override
//   List<Object> get props => [];
//
//   get buttonStates => null;
//
//   get messages => null;
// }
//
// class ButtonInitial extends ButtonState {
//   @override
//   final List<String> messages;
//   @override
//   final Map<String, bool> buttonStates;
//
//   const ButtonInitial(this.messages, this.buttonStates);
//
//   @override
//   List<Object> get props => [messages, buttonStates];
// }
//
// class ButtonLoading extends ButtonState {
//   final String button;
//   @override
//   final List<String> messages;
//   @override
//   final Map<String, bool> buttonStates;
//
//   const ButtonLoading(this.button, this.messages, this.buttonStates);
//
//   @override
//   List<Object> get props => [button, messages, buttonStates];
// }
//
// class ButtonSuccess extends ButtonState {
//   final String button;
//   @override
//   final List<String> messages;
//   @override
//   final Map<String, bool> buttonStates;
//
//   const ButtonSuccess(this.button, this.messages, this.buttonStates);
//
//   @override
//   List<Object> get props => [button, messages, buttonStates];
// }
//
// class ButtonFailure extends ButtonState {
//   final String button;
//   @override
//   final List<String> messages;
//   @override
//   final Map<String, bool> buttonStates;
//
//   const ButtonFailure(this.button, this.messages, this.buttonStates);
//
//   @override
//   List<Object> get props => [button, messages, buttonStates];
// }
//
// // BLoC
// class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
//   ButtonBloc()
//       : super(ButtonInitial([], {
//     'Connect': false,
//     'Subscribe': false,
//     'Publish': false,
//     'Unsubscribe': false,
//     'Disconnect': true,
//   })) {
//     on<ButtonPressed>((event, emit) async {
//       final currentMessages = (state as dynamic).messages;
//       final currentButtonStates = (state as dynamic).buttonStates;
//       emit(ButtonLoading(event.button, currentMessages, currentButtonStates));
//       try {
//         String message = await asyncFunction(event.button);
//         currentMessages.add(message);
//         currentButtonStates[event.button] = true;
//         if (event.button == 'Connect' || event.button == 'Subscribe' || event.button == 'Publish') {
//           currentButtonStates['Disconnect'] = false;
//         } else if (event.button == 'Unsubscribe') {
//           currentButtonStates['Connect'] = false;
//           currentButtonStates['Subscribe'] = false;
//           currentButtonStates['Publish'] = false;
//         } else if (event.button == 'Disconnect') {
//           currentButtonStates['Connect'] = false;
//           currentButtonStates['Subscribe'] = false;
//           currentButtonStates['Publish'] = false;
//           currentButtonStates['Unsubscribe'] = false;
//         }
//         emit(ButtonSuccess(event.button, List.from(currentMessages), Map.from(currentButtonStates)));
//       } catch (e) {
//         //currentMessages.add('Operation ${event.button} failed: $e');
//         currentMessages.add('$e');
//         currentButtonStates[event.button] = false;
//         emit(ButtonFailure(event.button, List.from(currentMessages), Map.from(currentButtonStates)));
//       }
//     });
//   }
//
//   Future<String> asyncFunction(String button) async {
//     await Future.delayed(Duration(seconds: 2)); // Симуляция асинхронной операции
//     if (button == 'Connect' || button == 'Publish') {
//       return 'Operation $button succeeded';
//     } else if (button == 'Subscribe') {
//       throw Exception('Operation $button failed'); // Симуляция ошибки
//     } else {
//       return 'Operation $button succeeded';
//     }
//   }
// }
//
