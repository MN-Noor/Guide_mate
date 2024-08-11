import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:guide_mate_project/plan_trip/gemini.dart';

Future<String> getWeatherInfo(String cityName) async {
  String weatherApiKey = "6db2763627415e9e790c7174b573d636";
  final response = await http.get(Uri.parse(
      'http://api.openweathermap.org/data/2.5/weather?&appid=$weatherApiKey&q=$cityName'));

  if (response.statusCode == 200) {
    final weatherData = jsonDecode(response.body);

    if (weatherData['cod'] == '404') {
      return 'City Not Found';
    }

    return 'Temperature (in Kelvin): ${weatherData['main']['temp'].toStringAsFixed(2)}, '
        'Atmospheric pressure (in hPa): ${weatherData['main']['pressure']}, '
        'Humidity (in percentage): ${weatherData['main']['humidity']}, '
        'Description: ${weatherData['weather'][0]['description']}';
  } else {
    return 'Weather information not available.';
  }
}

Future<String> generateGuide(String cityName) async {
  String weather = await getWeatherInfo(cityName);
  String prompt =
      "This is current weather updates of a place $cityName $weather. As a tourist guide, guide the tourist about weather and guide them about clothing and measures to enjoy that weather and ensure that travelers have a memorable trip. Share safety measures to take when visiting this location and offer tips on how to make the most of their journey. Do not generate your response in readme form. Generate in simple text and do not add asterisks or any alphanumeric characters. Your response should be in one long comprehensive paragraph without any formatting.";
  String? response = await GeminiService.generateContent(prompt);
  return response ?? "No guide content available.";
}

class GuideTTS {
  final FlutterTts flutterTts = FlutterTts();
  String text = "";
  TtsState ttsState = TtsState.stopped;
  int currentPosition = 0;

  GuideTTS() {
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
      currentPosition = 0;
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
    });

    flutterTts.setPauseHandler(() {
      ttsState = TtsState.paused;
    });

    flutterTts.setContinueHandler(() {
      ttsState = TtsState.continued;
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
    });
  }

  Future<void> generateAndSpeakGuide(String cityName) async {
    text = await generateGuide(cityName);
    currentPosition = 0;
    await _speak();
  }

  Future<void> _speak() async {
    String textToSpeak = text.substring(currentPosition);
    var result = await flutterTts.speak(textToSpeak);
    if (result == 1) ttsState = TtsState.playing;
  }

  Future<void> pause() async {
    var result = await flutterTts.pause();
    if (result == 1) ttsState = TtsState.paused;
  }

  Future<void> resume() async {
    var result = await flutterTts.speak(text.substring(currentPosition));
    if (result == 1) ttsState = TtsState.continued;
  }

  Future<void> stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
      currentPosition = 0;
    }
  }
}

enum TtsState { playing, stopped, paused, continued }
