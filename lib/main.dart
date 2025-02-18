import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_helper.dart';
import 'screen_bloc.dart';

void main() {
  ClientHelper.initInstance();
  runApp(MQTTClientApp());
}

class MQTTClientApp extends StatelessWidget {
  const MQTTClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OperationsPage(),
    );
  }
}

class OperationsPage extends StatelessWidget {
  const OperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        debugPrint('******* onPopInvoked($didPop) *******');
        if (didPop) {
          return;
        }
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit from app',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text('Are you sure?',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontStyle: FontStyle.italic)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('MQTT Client App',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.bubble_chart_outlined, color: Colors.white)),
        ),
        body: BlocProvider(
          create: (_) => ButtonBloc(),
          child: ButtonScreen(),
        ),
      ),
    );
  }
}

class ButtonScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              'Connect',
              'Subscribe',
              'Publish',
              'Unsubscribe',
              'Disconnect'
            ].map((button) {
              return BlocBuilder<ButtonBloc, ButtonState>(
                builder: (context, state) {
                  bool isLoading =
                      state is ButtonLoading && state.button == button;
                  bool isSuccess = state.buttonStates[button] ?? false;
                  bool isFailure =
                      state is ButtonFailure && state.button == button;

                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (isFailure) {
                              return Colors.red;
                            }
                            return Colors.blue;
                          },
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () => context
                              .read<ButtonBloc>()
                              .add(ButtonPressed(button)),
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              isSuccess ? '✓ $button' : button,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: BlocListener<ButtonBloc, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccess || state is ButtonFailure) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              }
            },
            child: BlocBuilder<ButtonBloc, ButtonState>(
              builder: (context, state) {
                return ListView.separated(
                  controller: _scrollController,
                  itemCount: state.messages.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isError = message.contains('Failed');
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      dense: true,
                      title: Text(
                        message,
                        style: TextStyle(
                          color: isError ? Colors.red : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
