import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sos_model.dart';
export 'sos_model.dart';

class SosWidget extends StatefulWidget {
  const SosWidget({super.key});

  static String routeName = 'SOS';
  static String routePath = '/sos';

  @override
  State<SosWidget> createState() => _SosWidgetState();
}

class _SosWidgetState extends State<SosWidget> {
  late SosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SosModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// FUNCION LLAMAR
  Future<void> llamarNumero(String numero) async {
    try {

      final Uri telefonoUri = Uri(
        scheme: 'tel',
        path: numero,
      );

      await launchUrl(
        telefonoUri,
        mode: LaunchMode.externalApplication,
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error al llamar: $e",
          ),
        ),
      );
    }
  }

  /// CARD EMERGENCIA
  Widget emergencyCard({
    required Color iconColor,
    required IconData icon,
    required String title,
    required String contact,
    required String numero,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3440),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [

            /// ICONO
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconColor.withOpacity(.8),
                    iconColor,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            /// INFO
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    contact,
                    style: GoogleFonts.karla(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            /// BOTON LLAMAR
            InkWell(
              borderRadius:
                  BorderRadius.circular(100),
              onTap: () {
                llamarNumero(numero);
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone_in_talk_rounded,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus
            ?.unfocus();
      },

      child: Scaffold(
        key: scaffoldKey,
        backgroundColor:
            const Color(0xFF0B1F2A),

        body: Stack(
          children: [

            /// FONDO
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF07141C),
                    Color(0xFF102733),
                    Color(0xFF0B1F2A),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [

                  /// APPBAR CUSTOM
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                            16, 10, 16, 0),
                    child: Row(
                      children: [

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(.08),
                            borderRadius:
                                BorderRadius
                                    .circular(16),
                          ),
                          child:
                              FlutterFlowIconButton(
                            borderColor:
                                Colors.transparent,
                            borderRadius: 16,
                            borderWidth: 0,
                            buttonSize: 48,
                            icon: const Icon(
                              Icons
                                  .arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              context.pop();
                            },
                          ),
                        ),

                        const Spacer(),

                        Text(
                          "Emergency",
                          style:
                              GoogleFonts.karla(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// CARD PRINCIPAL SOS
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFFFF5F6D),
                            Color(0xFFFF3D54),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(
                                30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red
                                .withOpacity(.35),
                            blurRadius: 20,
                            offset:
                                const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.sos_rounded,
                              color: Colors.white,
                              size: 46,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "Emergency Contacts",
                            style:
                                GoogleFonts.karla(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Tap the phone icon to open the call app instantly",
                            textAlign:
                                TextAlign.center,
                            style:
                                GoogleFonts.karla(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// LISTA
                  Expanded(
                    child:
                        SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [

                          emergencyCard(
                            iconColor:
                                const Color(
                                    0xFF1E88E5),
                            icon: Icons.shield,
                            title: "Police",
                            contact:
                                "Emergency Contact: 123",
                            numero: "123",
                          ),

                          emergencyCard(
                            iconColor:
                                const Color(
                                    0xFFE53935),
                            icon: Icons
                                .local_fire_department,
                            title: "Firefighters",
                            contact:
                                "Emergency Contact: 119",
                            numero: "119",
                          ),

                          emergencyCard(
                            iconColor:
                                const Color(
                                    0xFF43A047),
                            icon:
                                Icons.medical_services,
                            title:
                                "Medical Emergency",
                            contact:
                                "Emergency Contact: 125",
                            numero: "125",
                          ),

                          emergencyCard(
                            iconColor:
                                const Color(
                                    0xFFFFA000),
                            icon:
                                Icons.support_agent,
                            title:
                                "Civil Defense",
                            contact:
                                "Emergency Contact: 144",
                            numero: "144",
                          ),

                          emergencyCard(
                            iconColor:
                                const Color(
                                    0xFFD32F2F),
                            icon: Icons.favorite,
                            title: "Red Cross",
                            contact:
                                "Emergency Contact: 132",
                            numero: "132",
                          ),

                          const SizedBox(
                              height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}