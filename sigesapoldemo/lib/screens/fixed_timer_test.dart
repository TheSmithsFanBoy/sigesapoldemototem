


//!POSIBLE SOLUCIÓN ....
//? Problema: El initState solo se ejecuta la primera vez!
//! y una vez q llamaba todos los nombres, estaba haciendo dispose al Timer!
//* Recursividad luego de q el currentIndex < nombres.length 


import 'dart:async';
import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final tts = TextToSpeech();

  Timer? _timer;
  int _currentIdx = 0;
  List<String> _nombres = ['John', 'Mary', 'David', 'Sarah'];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_currentIdx < _nombres.length) {
        tts.speak(_nombres[_currentIdx]);
        setState(() {
          _currentIdx++;
        });
      } else {
        timer.cancel();
        _currentIdx = 0;
        startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posible Solución 10 seconds delay despues de llamar a todos')),
      body: Center(
        child: Text('Idx: $_currentIdx'),
      ),
    );
  }
}