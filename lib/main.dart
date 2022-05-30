import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Variables

  String milliSecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;
  Color backColor = Color(0xffFF40CA88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFF282E3D), //FF282E3D
        body: Stack(children: [
          const Align(
            alignment: Alignment(0, -0.9), //0 - centre 1, top - so 0.1 is 10%
            child: Text(
              'Test your \n reaction speed ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            //Centre
            alignment: Alignment.center,
            child: ColoredBox(
              color: Color(0xffFF6D6D6D),
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    milliSecondsText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    _startWaitingTime();
                    break;
                  case GameState.waiting:
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: _getColor(),
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
        break;
      case GameState.waiting:
        return "WAIT";
        break;
      case GameState.canBeStopped:
        return "STOP";
        break;
    }
  }

  _getColor() {
    switch (gameState) {
      case GameState.readyToStart:
        // return Colors.green;
        return Color(0xffFF40CA88);
        break;
      case GameState.waiting:
        return Color(0xffFFE0982D);
        // return Colors.yellow;
        break;
      case GameState.canBeStopped:
        // return Colors.red;
        return Color(0xffFFE02D47);
        break;
    }
  }

  //Functions

  void _startWaitingTime() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        milliSecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
