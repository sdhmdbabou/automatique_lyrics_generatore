import 'package:automatique_lyrics/color.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';


class Lyrics_Screen extends StatefulWidget {
  const Lyrics_Screen({super.key});

  @override
  State<Lyrics_Screen> createState() => _Lyrics_ScreenState();
}

class _Lyrics_ScreenState extends State<Lyrics_Screen> {
  SpeechToText speechToText = SpeechToText();
  var text = "hold the button and start speaking ";
  var isListening = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          endRadius: 75.0,
          animate: isListening,
          duration: Duration(milliseconds: 2000),
          glowColor: bgColor,
          repeat: true,
          repeatPauseDuration: Duration(milliseconds: 100),
          showTwoGlows: true,
          child: GestureDetector(
            child: CircleAvatar(
              backgroundColor: bgColor,
              radius: 35,
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
            onTapDown: (details) async {
              if (!isListening) {
                var available = await speechToText.initialize();
                if (available) {
                  setState(() {
                    isListening = true;
                    speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          text = result.recognizedWords;
                        });
                      },
                    );
                  });
                }
              }
            },
            onTapUp: (details) {
              setState(() {
                isListening = false;
              });
              speechToText.stop();
            },
          ), // CircleAvatar
        ), // AvatarGlow

        appBar: AppBar(
          leading: const Icon(Icons.sort_rounded, color: Colors.white),
          centerTitle: true,
          backgroundColor: bgColor,
          elevation: 0.0,
          title: const Text(
            "automatique_lyrics",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
            ), // TextStyle
          ), // Text
        ),
        body: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              margin: const EdgeInsets.only(bottom: 150),
              child: Text(text,
                  style: TextStyle(
                    fontSize: 24,
                    color: isListening ? Colors.black87 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ))),
        ));
  }
}
