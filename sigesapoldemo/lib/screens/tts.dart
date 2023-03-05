import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

//! DEMO TTS - stackoverflow

class WaitingRoom extends StatefulWidget {
  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  FlutterTts flutterTts = FlutterTts();

  String speechBubbleText = 'Bonjour. Joue avec moi !';
  List<Widget> actions = [];
  bool alreadyDelayed = false;

  @override
  Widget build(BuildContext context) {
    print('Build-----------');
    if (!alreadyDelayed) {
      flutterTts.speak(speechBubbleText);
      flutterTts.setCompletionHandler(() {
        youWon();
      });
      alreadyDelayed = true;
    }

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              child: Text(
                speechBubbleText,
              ),
            ),
            Row(
              children: actions,
            ),
          ],
        ));
  }

  Future<void> youWon() async {
    flutterTts.setCompletionHandler(() {});
    setState(() {
      speechBubbleText = 'Bravo, tu as gagné !'
          'Le médecin devrait arriver bientôt';
      actions = [];
    });
    await flutterTts.speak(speechBubbleText);

    setState(() {
      speechBubbleText = 'Ca va se passer comme ça :';
    });
    await flutterTts.speak(speechBubbleText);

    setState(() {
      speechBubbleText = 'Tu vas attendre le médecin';
      actions = [];
      actions.add(Text('test'));
    });
    await flutterTts.speak(speechBubbleText);

    setState(() {
      speechBubbleText = 'Il viendra te chercher pour la consultation';
      actions = [];
      actions.add(Text('test'));
    });
    await flutterTts.speak(speechBubbleText);

    setState(() {
      speechBubbleText =
      'Quand ce sera fini, tu pourras rentrer à la maison !';
      actions = [];
      actions.add(Text('test'));
    });
    await flutterTts.speak(speechBubbleText);

    setState(() {
      speechBubbleText = 'Maintenant, on attend le médecin';
      actions = [];
      actions.add(Text('test'));
    });
    await flutterTts.speak(speechBubbleText);
  }
}