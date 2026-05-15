import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/groq_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  final GroqService _groqService = GroqService();

  final TextEditingController _controller =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  List<Map<String, String>> mensajes = [];

  bool cargando = false;

  void enviarMensaje() async {
    if (_controller.text.trim().isEmpty) return;

    String mensajeUsuario = _controller.text;

    setState(() {
      mensajes.add({
        "rol": "user",
        "mensaje": mensajeUsuario,
      });

      cargando = true;
      _controller.clear();
    });

    scrollAbajo();

    String respuesta =
        await _groqService.enviarMensaje(mensajeUsuario);

    setState(() {
      mensajes.add({
        "rol": "bot",
        "mensaje": respuesta,
      });

      cargando = false;
    });

    scrollAbajo();
  }

  void scrollAbajo() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget mensajeIA(String texto) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 14,
        right: 70,
        top: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// AVATAR IA
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00C6FF),
                  Color(0xFF0072FF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          /// MENSAJE
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 12,
                  sigmaY: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(
                    texto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget mensajeUsuario(String texto) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 70,
        right: 14,
        top: 10,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2563EB),
                Color(0xFF1D4ED8),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget escribiendo() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 14,
        top: 12,
      ),
      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00C6FF),
                  Color(0xFF0072FF),
                ],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            child: Row(
              children: const [

                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),

                SizedBox(width: 12),

                Text(
                  "La IA está pensando...",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget sugerencias() {
    List<String> ejemplos = [
      "¿Que es priceQR?",
      "¿Como funciona la validacion de precios?",
      "¿La aplicacion cuenta con recomendaciones?",
      "¿Con que funcionalidades cuenta PriceQR?",
    ];

    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: ejemplos.length,
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: () {
              _controller.text = ejemplos[index];
            },

            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              child: Center(
                child: Text(
                  ejemplos[index],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF09090B),

      body: Stack(
        children: [

          /// FONDO GLOW
          Positioned(
            top: -100,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.18),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.14),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                /// BOTON REGRESAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// HEADER PREMIUM
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius:
                              BorderRadius.circular(24),
                          border: Border.all(
                            color:
                                Colors.white.withOpacity(0.06),
                          ),
                        ),

                        child: Row(
                          children: [

                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(16),
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(width: 14),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "AI Assistant",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "Modelo inteligente conectado",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green
                                    .withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [

                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor:
                                        Colors.greenAccent,
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "Online",
                                    style: TextStyle(
                                      color:
                                          Colors.greenAccent,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// SUGERENCIAS
                sugerencias(),

                const SizedBox(height: 10),

                /// MENSAJES
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: mensajes.length,
                    itemBuilder: (context, index) {

                      final mensaje = mensajes[index];

                      if (mensaje["rol"] == "user") {
                        return mensajeUsuario(
                          mensaje["mensaje"] ?? "",
                        );
                      }

                      return mensajeIA(
                        mensaje["mensaje"] ?? "",
                      );
                    },
                  ),
                ),

                if (cargando)
                  escribiendo(),

                /// INPUT PREMIUM
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 12,
                        sigmaY: 12,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius:
                              BorderRadius.circular(30),
                          border: Border.all(
                            color:
                                Colors.white.withOpacity(0.06),
                          ),
                        ),

                        child: Row(
                          children: [

                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.white70,
                              ),
                            ),

                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration:
                                    const InputDecoration(
                                  hintText:
                                      "Pregúntale algo a la IA...",
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.mic_none_rounded,
                                color: Colors.white70,
                              ),
                            ),

                            Container(
                              decoration:
                                  const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                ),
                              ),

                              child: IconButton(
                                onPressed: enviarMensaje,
                                icon: const Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}