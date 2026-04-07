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
import '../screens/chat_screen.dart';

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

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      context.goNamed(LoginWidget.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  void _showComingSoonModal(BuildContext context,
      {String featureName = 'esta función'}) {
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
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_outlined, size: 40),
                  SizedBox(height: 20),
                  Text('¡Próximamente! 🚀'),
                  SizedBox(height: 15),
                  Text('$featureName estará disponible próximamente.'),
                  SizedBox(height: 25),
                  FFButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: '¡Entendido!',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
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
            children: [
              // 🔥 HEADER CON USUARIO (CORREGIDO)
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E1E2D),
                      Color(0xFF2A2A40),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    children: [
                      // FOTO
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
                            ),
                          ),
                        ),
                      ),

                      // INFO USUARIO
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 14),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                    color: Colors.white);
                              }

                              final userData =
                                  snapshot.data?.data() as Map<String, dynamic>?;

                              final nombre = userData?['nombre'] ?? 'Usuario';
                              final correo = userData?['correo'] ??
                                  FirebaseAuth.instance.currentUser?.email ??
                                  '';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    nombre,
                                    style: GoogleFonts.karla(
                                      color: Colors.amber,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    correo,
                                    style: GoogleFonts.karla(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              _buildMenuCard(
                title: 'Edit Profile',
                icon: Icons.edit,
                iconColor: Colors.black,
                onTap: () =>
                    context.pushNamed(EditarPerfilUsuarioWidget.routeName),
              ),

              _buildMenuCard(
                title: 'Notification Settings',
                icon: Icons.notifications,
                iconColor: Colors.orange,
                onTap: () => _showComingSoonModal(context),
              ),

              _buildMenuCard(
                title: 'About the App',
                icon: Icons.info,
                iconColor: Colors.blue,
                onTap: () => _showComingSoonModal(context),
              ),

              _buildMenuCard(
                title: 'Contact Support',
                icon: Icons.support,
                iconColor: Colors.black,
                onTap: () => _showComingSoonModal(context),
              ),

              // 🤖 BOTÓN CHAT IA
              _buildMenuCard(
                title: 'Chat con IA',
                icon: Icons.smart_toy,
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChatScreen(),
                    ),
                  );
                },
              ),

              Padding(
                padding: EdgeInsets.only(top: 60),
                child: FFButtonWidget(
                  onPressed: _signOut,
                  text: 'Log Out',
                  icon: Icon(Icons.logout),
                  options: FFButtonOptions(
                    width: 170,
                    height: 52,
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

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              Icon(icon, color: iconColor),
              SizedBox(width: 16),
              Expanded(child: Text(title)),
              Icon(Icons.arrow_forward_ios),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}