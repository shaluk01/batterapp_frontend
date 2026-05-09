import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterService {
  static final String _apiKey =
      dotenv.env['OPENROUTER_API_KEY'] ?? '';

  static const String _url =
      "https://openrouter.ai/api/v1/chat/completions";

  static const String _systemPrompt = """
You are Batter Hub's customer support assistant.

Business details:
- Company: Batter Hub
- Product: Fresh homemade batter (Idli, Dosa, Vada, Appam)
- Delivery Time: 6:00 AM – 8:00 PM
- Zones: Multiple zones including Anna Nagar
- Freshness: Batter is prepared daily with no preservatives
- Orders can be cancelled before dispatch
- Support tone: Friendly, short, clear, professional

Rules:
- Answer ONLY batter, order, delivery, freshness, pricing, subscription related questions
- If question is outside Batter Hub, politely redirect
- Never invent offers or prices
- Sound like a real support executive
""";

  static Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "mistralai/mistral-7b-instruct",
          "messages": [
            {
              "role": "system",
              "content": _systemPrompt,
            },
            {
              "role": "user",
              "content": userMessage,
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["choices"][0]["message"]["content"];
      } else {
        return "⚠️ Sorry, I couldn’t respond right now.";
      }
    } catch (e) {
      return "⚠️ Network error. Please try again.";
    }
  }
}