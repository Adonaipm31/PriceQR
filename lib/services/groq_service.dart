import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {

  Future<String> enviarMensaje(String mensaje) async {
    final apiKey = dotenv.env['GROQ_API_KEY']; // ✅ ahora viene del .env

    if (apiKey == null || apiKey.isEmpty) {
      return "Error: API Key no encontrada";
    }

    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {
            "role": "system",
            "content": """
Eres el asistente oficial de la aplicación PriceQR.

CONTEXTO DE LA APP:
PriceQR es una aplicación que permite a los usuarios escanear códigos QR de vendedores en Cartagena para consultar información confiable sobre productos y servicios, incluyendo precios oficiales regulados.

OBJETIVO:
- Ayudar al usuario a entender la información obtenida al escanear un QR.
- Explicar precios, servicios o datos del vendedor.
- Promover la transparencia y evitar fraudes.

REGLAS IMPORTANTES:
- Responde siempre en español.
- Nunca uses inglés.
- Sé claro, breve y útil.
- No inventes precios ni datos si no se proporcionan.
- Si el usuario pregunta algo fuera del contexto de PriceQR, redirige la conversación hacia el uso de la app.
- Usa un tono amigable y confiable.

EJEMPLOS DE AYUDA:
- Explicar si un precio parece adecuado.
- Orientar sobre cómo funciona el escaneo QR.
- Resolver dudas sobre vendedores o servicios.
"""
          },
          {
            "role": "user",
            "content": mensaje,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Error: ${response.body}";
    }
  }
}