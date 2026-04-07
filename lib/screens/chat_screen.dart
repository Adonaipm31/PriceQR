import 'package:flutter/material.dart';
import '../services/groq_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GroqService _groqService = GroqService();
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> mensajes = [];
  bool cargando = false;

  void enviarMensaje() async {
    if (_controller.text.trim().isEmpty) return;

    String mensajeUsuario = _controller.text;

    setState(() {
      mensajes.add({"rol": "user", "mensaje": mensajeUsuario});
      cargando = true;
      _controller.clear();
    });

    String respuesta = await _groqService.enviarMensaje(mensajeUsuario);

    setState(() {
      mensajes.add({"rol": "bot", "mensaje": respuesta});
      cargando = false;
    });
  }

  Widget burbuja(Map<String, String> mensaje) {
    bool esUsuario = mensaje["rol"] == "user";

    return Align(
      alignment:
          esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: esUsuario ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          mensaje["mensaje"] ?? "",
          style: TextStyle(
            color: esUsuario ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat con IA 🤖"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                return burbuja(mensajes[index]);
              },
            ),
          ),
          if (cargando)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: enviarMensaje,
              )
            ],
          )
        ],
      ),
    );
  }
}