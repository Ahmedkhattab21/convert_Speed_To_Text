import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeetchScreenState();
}

class _SpeetchScreenState extends State<SpeechScreen> {
  bool isListening = false;
  Map<String, HighlightedWord> words = {
    "flutter": HighlightedWord(
      textStyle: TextStyle(color: Colors.red, fontSize: 50),
    ),
    "Ahmed": HighlightedWord(
      textStyle: TextStyle(color: Colors.blue, fontSize: 50),
    )
  };
  late stt.SpeechToText speech;
  String text = "Press on the button ";
  double confidence=1;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice To Text"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(30),
        child: TextHighlight(
          text: text,
          words: words,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Colors.blue,
        endRadius: 90.0,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: Material(
          // Replace this child with your own
          elevation: 8.0,
          shape: CircleBorder(),
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!isListening) {
      bool? available = await speech.initialize(
        onStatus: (val) {
          print("on Status $val");
        },
        onError: (val) {
          print("on error $val");
        },
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        speech.listen(onResult: (val) {
          setState(() {
            text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence >0){
              confidence=val.confidence;
            }
          });
        });
      }
    } else {
      setState(() {
        isListening=false;
      });
      speech.stop();
    }
  }
}
