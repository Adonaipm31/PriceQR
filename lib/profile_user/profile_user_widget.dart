import '/components/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_user_model.dart';
export 'profile_user_model.dart';

class ProfileUserWidget extends StatefulWidget {
  const ProfileUserWidget({super.key});

  static String routeName = 'ProfileUser';
  static String routePath = '/profileUser';

  @override
  State<ProfileUserWidget> createState() => _ProfileUserWidgetState();
}

class _ProfileUserWidgetState extends State<ProfileUserWidget> {
  late ProfileUserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileUserModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Función para cerrar sesión - CORREGIDA
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // ✅ Navegar a la pantalla de login - usa el nombre CORRECTO de tu ruta
      context.goNamed(LoginWidget.routeName);
    } catch (e) {
      print('Error durante logout: $e');
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  // Función para mostrar modal elegante - CORREGIDA
  void _showComingSoonModal(BuildContext context, {String featureName = 'esta función'}) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono decorativo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E2D).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.rocket_launch_outlined,
                      size: 40,
                      color: Color(0xFF1E1E2D),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Título
                  Text(
                    '¡Próximamente! 🚀',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                      ),
                      color: Color(0xFF1E1E2D),
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Descripción - CORREGIDA
                  Text(
                    '$featureName estará disponible en la próxima versión de PriceQR.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.karla(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 16,
                      lineHeight: 1.4,   // ✅ CORRECTO
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Mensaje adicional
                  Text(
                    'Estamos trabajando para brindarte la mejor experiencia.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.karla(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 25),
                  
                  // Botón de aceptar
                  FFButtonWidget(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: '¡Entendido!',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFF1E1E2D),
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.karla(
                          fontWeight: FontWeight.w600,
                        ),
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 160.0,
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E2D),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: FlutterFlowTheme.of(context).alternate,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw2fHxwZXJmaWx8ZW58MHx8fHwxNzU5NTI3NzE2fDA&ixlib=rb-4.1.0&q=80&w=1080',
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('usuarios')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container(
                                      width: 20,
                                      height: 20,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }
                                  if (!snapshot.hasData || !snapshot.data!.exists) {
                                    return const Text(
                                      'Usuario no encontrado',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }

                                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                                  final nombre = userData['nombre'] ?? 'Usuario';
                                  final correo = userData['correo'] ?? FirebaseAuth.instance.currentUser?.email ?? '';

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        nombre,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.karla(),
                                              color: Color(0xFFFFC107),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                        child: Text(
                                          correo,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.plusJakartaSans(),
                                                color: Color(0xFFB0BEC5),
                                              ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Edit Profile
              _buildMenuCard(
                title: 'Edit Profile',
                icon: Icons.edit,
                iconColor: FlutterFlowTheme.of(context).primaryText,
                onTap: () => context.pushNamed(EditarPerfilUsuarioWidget.routeName),
              ),
              
              // Notification Settings
              _buildMenuCard(
                title: 'Notification Settings',
                icon: Icons.notifications_sharp,
                iconColor: Color(0xFFDD932C),
                onTap: () => _showComingSoonModal(context, featureName: 'La configuración de notificaciones'),
              ),
              
              // About the App
              _buildMenuCard(
                title: 'About the App',
                icon: Icons.info,
                iconColor: Color(0xFF1F84D0),
                onTap: () => _showComingSoonModal(context, featureName: 'La información sobre la app'),
              ),
              
              // Contact Support
              _buildMenuCard(
                title: 'Contact Support',
                icon: Icons.support_agent,
                iconColor: Color(0xFF171817),
                onTap: () => _showComingSoonModal(context, featureName: 'El soporte al cliente'),
              ),
              
              // Log Out Button
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 104.0, 0.0, 40.0),
                child: FFButtonWidget(
                  onPressed: _signOut, // ✅ Funcionalidad de logout corregida
                  text: 'Log Out',
                  options: FFButtonOptions(
                    width: 110.0,
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Color(0xFF1E1E2D),
                    textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.karla(),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 3.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
          wrapWithModel(
            model: _model.navBarModel,
            updateCallback: () => safeSetState(() {}),
            child: NavBarWidget(),
          ),
        ],
      ),
    );
  }

  // Widget reutilizable para las tarjetas del menú
  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: Material(
        color: Colors.transparent,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: double.infinity,
          height: 60.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              width: 0.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 4.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.karla(),
                          letterSpacing: 0.0,
                        ),
                  ),
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}