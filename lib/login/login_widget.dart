import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
        body: Stack(
          children: [
            // 🔹 FONDO CON IMAGEN
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset(
                    'assets/images/imagen_cartagena.jpg',
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔹 BLUR + OSCURECER
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),

            // 🔹 CARD CENTRADA
            Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔐 LOGIN
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(SignAccesoWidget.routeName);
                        },
                        text: 'Log in',
                        icon: const Icon(Icons.key),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          iconColor: Colors.white,
                          color: const Color(0xFF00A7CA),
                          textStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.karla(
                                  fontWeight: FontWeight.bold,
                                ),
                                color: Colors.white,
                              ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🧾 SIGN UP
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                              OpcionDeRegistroWidget.routeName);
                        },
                        text: 'Sign up',
                        icon: const Icon(Icons.person_add_alt),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          iconColor: const Color(0xFF00A7CA),
                          color: Colors.transparent,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.karla(
                                  fontWeight: FontWeight.bold,
                                ),
                                color: const Color(0xFF00A7CA),
                              ),
                          borderSide: const BorderSide(
                            color: Color(0xFF00A7CA),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Explore as guest (limited access)',
                        style:
                            FlutterFlowTheme.of(context).labelMedium,
                      ),

                      const SizedBox(height: 12),

                      // 👤 GUEST
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(
                              HomeInvitadoWidget.routeName);
                        },
                        text: 'Proceed as Guest',
                        icon: const Icon(Icons.person_search),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          iconColor: Colors.white,
                          color: const Color(0xFF77B8E6),
                          textStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.karla(
                                  fontWeight: FontWeight.bold,
                                ),
                                color: Colors.white,
                              ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: () {
                          context.pushNamed(
                              SignAccesoWidget.routeName);
                        },
                        child: RichText(
                          textScaler:
                              MediaQuery.of(context).textScaler,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Forgot password or username? ',
                                style:
                                    TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Recover here',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration:
                                      TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
