import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  Future<Map<String, String>> getDistance(
      String origin, String destination) async {
    final apiKey = '';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$apiKey');

    // print('Request URL: $url');

    final response = await http.get(url);

    // print('API Response Status Code: ${response.statusCode}');
    // print('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final elements = data['rows'][0]['elements'][0];
        if (elements['status'] == 'OK') {
          final distance = elements['distance']['text'];
          final duration = elements['duration']['text'];
          return {
            'origin': origin,
            'destination': destination,
            'distance': distance,
            'duration': duration
          };
        } else {
          return {
            'origin': origin,
            'destination': destination,
            'error': 'Error in elements status: ${elements['status']}'
          };
        }
      } else {
        return {
          'origin': origin,
          'destination': destination,
          'error': 'Error in response status: ${data['status']}'
        };
      }
    } else {
      return {
        'origin': origin,
        'destination': destination,
        'error': 'Request failed with status: ${response.statusCode}'
      };
    }
  }

  static Future<String?> generateContent(String prompt) async {
    final distanceTool = FunctionDeclaration(
        'getDistance',
        'Calculate the distance and duration between two locations using the Google Maps Distance Matrix API.',
        Schema(SchemaType.object, properties: {
          'origin': Schema(SchemaType.string,
              description:
                  'The starting location for the distance calculation.'),
          'destination': Schema(SchemaType.string,
              description: 'The ending location for the distance calculation.'),
        }, requiredProperties: [
          'origin',
          'destination'
        ]));

    // Initialize the model
    final model = GenerativeModel(
      model: "gemini-1.5-pro-001",
      apiKey: '',
      tools: [
        Tool(functionDeclarations: [distanceTool])
      ],
    );

    final chat = model.startChat();
    var response = await chat.sendMessage(Content.text(prompt));

    // print('Model Response: ${response.text}');
    // print('Function Calls: ${response.functionCalls}');

    final functionCalls = response.functionCalls.toList();
    // When the model responds with a function call, invoke the function
    if (functionCalls.isNotEmpty) {
      List<Map<String, String>> allResponces = [];
      for (var functionCall in functionCalls) {
        // print('Function Call Name: ${functionCall.name}');
        // print('Function Call Arguments: ${functionCall.args}');
        String origin = functionCall.args['origin'].toString();
        String destination = functionCall.args['destination'].toString();
        final result = await GeminiService().getDistance(origin, destination);
        allResponces.add(result);

        print(result.toString());
      }
      String finalResponse = allResponces.join('\n');
      response = await chat.sendMessage(Content.text(finalResponse));
      String finalResult = response.text.toString();
      print('Model Response After Function Call: ${response.text}');
      return finalResult;
    }
  }
}
