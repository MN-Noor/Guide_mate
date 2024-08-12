import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

Future<String> getWeatherInfo(String cityName) async {
  String weatherApiKey =
      "6db2763627415e9e790c7174b573d636"; // Ensure this key is valid and not restricted
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

Future<String?> geminiContent(String prompt) async {
  final geminiApiKey =
      'AIzaSyCyhHSmSA9oeC7IkxBtaVKoKQ0uDMKkk04'; // Ensure this key is valid
  String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$geminiApiKey";
  Map<String, dynamic> body = {
    "contents": [
      {
        "parts": [
          {"text": prompt},
        ],
      }
    ],
  };
  Uri uri = Uri.parse(url);

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      String message =
          decodedJson['candidates'][0]['content']['parts'][0]['text'];
      return message;
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error sending request to Gemini: $e');
    return null;
  }
}

Future<String> generateGuide(String cityName) async {
  String weather = await getWeatherInfo(cityName);
  String prompt =
      "This is the current weather update for $cityName: $weather. As a tourist guide, guide the tourist about the weather, clothing, and other essentials they should bring to enjoy this location. Also, share insights about the culture and local customs to ensure a memorable trip. Provide safety tips for visiting and advice on making the most of their journey.";
  String? response = await geminiContent(prompt);
  print(response);
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
      print("Error: $msg");
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
