import 'dart:convert';

import 'package:VoxAi/model/deepseek.dart';
import 'package:VoxAi/model/gemini.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey =
      '';
  static const String apikeyG = "";
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String baseUrlGemini =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$apikeyG";
  static const String model = "qwen/qwq-32b:free";

 
  Future<GeminiResponse> generateGeminiResponse(String prompt) async {
    try {
     
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.4,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 2048,
        }
      };

      final response = await http.post(
        Uri.parse(baseUrlGemini),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("response gemini :${response.body} ");
        final data = jsonDecode(response.body);
        return GeminiResponse.fromJson(data);
      } else if (response.statusCode == 429) {

        // Handle rate limiting
        final retryAfter = response.headers['retry-after'];
        await Future.delayed(Duration(seconds: int.parse(retryAfter ?? '30')));
        // Retry the request
        return generateGeminiResponse(prompt);
      } else {
        throw Exception(
            'Gemini API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate Gemini response: $e');
    }
  }

  //google/gemini-2.0-flash-lite-preview-02-05:free
  Future<DeepSeekResponse> generateResponse(String prompt) async {
    Map<String, dynamic> chathistory = {
      "role": "user",
      "content": prompt,
      "parts": [
        {"type": "text", "text": prompt},
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [chathistory]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return DeepSeekResponse.fromJson(data);
      } else if (response.statusCode == 429) {
        // Handle rate limiting
        final retryAfter = response.headers['retry-after'];
        await Future.delayed(Duration(seconds: int.parse(retryAfter ?? '30')));
        // Retry the request
        return generateResponse(prompt);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate response: $e');
    }
  }
}
