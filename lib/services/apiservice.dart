import 'dart:convert';

import 'package:VoxAi/model/deepseek.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey =
      '';
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String model = "qwen/qwq-32b:free";
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
