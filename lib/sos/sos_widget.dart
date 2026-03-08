import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<void> llamarNumero(String numero) async {
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      final Uri url = Uri.parse("tel:$numero");

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      print("Permiso de llamada denegado");
    }
  }

  Widget emergencyCard(
      Color iconColor, IconData icon, String title, String contact, String numero) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF223844),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black26,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            GestureDetector(
              onTap: () {
                llamarNumero(numero);
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone,
                  color: iconColor,
                  size: 18,
                ),
              ),
            )
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
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF0E2A36),
        appBar: AppBar(
          backgroundColor: Color(0xFF0E2A36),
          elevation: 0,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            buttonSize: 46,
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            "Contactos de Emergencia",
            style: GoogleFonts.karla(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 26),
                  decoration: BoxDecoration(
                    color: Color(0xFF223844),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black38,
                        offset: Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF7A5A),
                              Color(0xFFFF4D4D)
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sos,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "En Caso de Emergencia",
                        style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Toca el icono de teléfono para llamar",
                        style: GoogleFonts.karla(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        emergencyCard(
                            Color(0xFF1E88E5),
                            Icons.shield,
                            "Policía",
                            "Contacto: 123",
                            "123"),

                        emergencyCard(
                            Color(0xFFE53935),
                            Icons.local_fire_department,
                            "Bomberos",
                            "Contacto: 123",
                            "123"),

                        emergencyCard(
                            Color(0xFF43A047),
                            Icons.medical_services,
                            "Ambulancia / Emergencia Médica",
                            "Contacto: 123",
                            "123"),

                        emergencyCard(
                            Color(0xFFFFA000),
                            Icons.support_agent,
                            "Defensa Civil / Rescate",
                            "Contacto: 911",
                            "911"),

                        emergencyCard(
                            Color(0xFFD32F2F),
                            Icons.favorite,
                            "Cruz Roja",
                            "Contacto: 911",
                            "911"),

                        SizedBox(height: 40)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}