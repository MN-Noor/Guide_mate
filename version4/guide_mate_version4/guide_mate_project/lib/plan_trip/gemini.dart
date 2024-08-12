import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  Future<Map<String, String>> getDistance(
      String origin, String destination) async {
    final apiKey = 'AIzaSyCyhHSmSA9oeC7IkxBtaVKoKQ0uDMKkk04';
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

  static Future<String?> generateContent(String user_data) async {
    final prompt = ("This is user requirments${user_data} based on these generate a proper planned trip. Generate the list of multiple locations to visit based on popular "
        "tourist destinations user preferences.\n"
        "For each segment of the trip, create two lists of 'origins' and 'destinations'. "
        "The first list should include each starting location, and the second list should include the next destination in the sequence."
        "Then, use the distance tool to calculate the travel time and distance between these locations. "
        "Based on this, generate a comprehensive travel plan that outlines the journey, including "
        "the travel times and distances for each segment.");
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

    final model = GenerativeModel(
      model: "gemini-1.5-pro-001",
      apiKey: 'AIzaSyAgOqd66nXVEF32ucERbna0iMCqJu8Dtkk',
      tools: [
        Tool(functionDeclarations: [distanceTool])
      ],
    );

    final chat = model.startChat();
    var response = await chat.sendMessage(Content.text(prompt));

    // print('Model Response: ${response.text}');
    // print('Function Calls: ${response.functionCalls}');

    final functionCalls = response.functionCalls.toList();
    if (functionCalls.isNotEmpty) {
      List<Map<String, String>> allResponces = [];
      for (var functionCall in functionCalls) {
        // print('Function Call Name: ${functionCall.name}');
        // print('Function Call Arguments: ${functionCall.args}');
        String origin = functionCall.args['origin'].toString();
        String destination = functionCall.args['destination'].toString();
        final result = await GeminiService().getDistance(origin, destination);
        allResponces.add(result);

        // print(result.toString());
      }
      String finalResponse = allResponces.join('\n');
      response = await chat.sendMessage(Content.text(
          "create a proper planned trip keeping in mind the user preferences budget(within budget) and other needs given here ${user_data} and add this distances and time between places which is provided here ${finalResponse} to ensure timely trip within budget and time trip  and keeping in mind necessities and no of people and family and depending upon that recommend some local sites,parks or restaurants to visit and also given estimated price for all services "));
      String finalResult = response.text.toString();
      // print('Model Response After Function Call: ${response.text}');
      return finalResult;
    }
  }
}
