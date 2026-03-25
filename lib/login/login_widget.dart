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
        backgroundColor: Color(0xDBFFFFFF),
        body: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: 670.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/imagen_cartagena.jpg',
                        ).image,
                      ),
                    ),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0x3500A7CA), Color(0x3500A7CA)],
                          stops: [0.0, 1.0],
                          begin: AlignmentDirectional(0.0, -1.0),
                          end: AlignmentDirectional(0, 1.0),
                        ),
                      ),
                      alignment: AlignmentDirectional(0.0, 1.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 44.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 16.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              context.pushNamed(SignAccesoWidget.routeName);
                            },
                            text: 'Log in',
                            icon: Icon(
                              Icons.key,
                              size: 24.0,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 60.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),

                              // ICONO BLANCO
                              iconColor: Colors.white,

                              // FONDO PRINCIPAL (#00A7CA)
                              color: Color(0xFF00A7CA),

                              textStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.karla(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // TEXTO BLANCO
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),

                              elevation: 2.0,

                              // SIN BORDE
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),

                              // HOVER (un poco más oscuro o mismo tono)
                              hoverColor: Color(0xFF0097B8),
                              hoverTextColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 16.0, 16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(OpcionDeRegistroWidget.routeName);
                          },
                          text: 'Sign up',
                          icon: Icon(
                            Icons.person_add_alt,
                            size: 24.0,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 60.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 12.0, 0.0),

                            // ICONO AZUL
                            iconColor: Color(0xFF00A7CA),

                            // FONDO TRANSPARENTE
                            color: Colors.transparent,

                            textStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.karla(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                                  // TEXTO AZUL
                                  color: Color(0xFF00A7CA),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),

                            elevation: 0.0,

                            // BORDE AZUL
                            borderSide: BorderSide(
                              color: Color(0xFF00A7CA),
                              width: 2.0,
                            ),

                            borderRadius: BorderRadius.circular(12.0),

                            // HOVER → se rellena
                            hoverColor: Color(0xFF00A7CA),
                            hoverTextColor: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 12.0, 0.0, 12.0),
                        child: Text(
                          'Explore as guest (limited access)',
                          style: FlutterFlowTheme.of(context).labelMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 16.0, 16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(HomeInvitadoWidget.routeName);
                          },
                          text: 'Proceed as Guest',
                          icon: Icon(
                            Icons.person_search,
                            size: 24.0,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 60.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 12.0, 0.0),

                            // ICONO BLANCO
                            iconColor: Colors.white,

                            // FONDO NORMAL (#77b8e6)
                            color: Color(0xFF77B8E6),

                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.karla(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  // TEXTO BLANCO
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),

                            elevation: 0.0,

                            // SIN BORDE (opcional, más limpio)
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),

                            borderRadius: BorderRadius.circular(12.0),

                            // HOVER (#00a7ca)
                            hoverColor: Color(0xFF00A7CA),
                            hoverTextColor: Colors.white,
                          ),
                        ),
                      ),

                      /// CAMBIO AQUÍ 👇
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 64.0),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(SignAccesoWidget.routeName);
                            print('🔵 RECOVER PRESIONADO');
                          },
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Forgot password or username? ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Recover here',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
