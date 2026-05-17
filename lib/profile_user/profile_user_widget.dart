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
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
        ),
      );
    }
  }

  void _showComingSoonModal(
    BuildContext context, {
    String featureName = 'esta función',
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color:
                  FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      size: 42,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    '¡Próximamente! 🚀',
                    style: GoogleFonts.karla(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '$featureName estará disponible próximamente.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.karla(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 28),

                  FFButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: 'Entendido',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 52,
                      color: const Color(0xFF4F46E5),
                      textStyle: GoogleFonts.karla(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
      backgroundColor:
          FlutterFlowTheme.of(context).primaryBackground,

      body: Stack(
        children: [

          /// FONDO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF111827),
                  Color(0xFF1F2937),
                  Color(0xFFF5F7FA),
                  Color(0xFFF5F7FA),
                ],
                stops: [0, .25, .25, 1],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  /// HEADER PREMIUM
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(22, 24, 22, 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1E1E2D),
                            Color(0xFF2D3250),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.18),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(FirebaseAuth
                                .instance.currentUser?.uid)
                            .get(),
                        builder: (context, snapshot) {

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          final userData =
                              snapshot.data?.data()
                                  as Map<String, dynamic>?;

                          final nombre =
                              userData?['nombre'] ??
                                  'Usuario';

                          final correo =
                              userData?['correo'] ??
                                  FirebaseAuth.instance
                                      .currentUser?.email ??
                                  '';

                          final photoUrl =
                              userData?['photoUrl'];

                          return Row(
                            children: [

                              /// FOTO
                              Stack(
                                children: [

                                  Container(
                                    padding:
                                        const EdgeInsets.all(3),
                                    decoration:
                                        const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient:
                                          LinearGradient(
                                        colors: [
                                          Colors.amber,
                                          Colors.orange,
                                        ],
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor:
                                          Colors.white,
                                      backgroundImage:
                                          photoUrl != null
                                              ? NetworkImage(
                                                  photoUrl)
                                              : null,
                                      child:
                                          photoUrl == null
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 42,
                                                  color:
                                                      Colors.grey,
                                                )
                                              : null,
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration:
                                          BoxDecoration(
                                        color: Colors.green,
                                        shape:
                                            BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 18),

                              /// INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    Text(
                                      nombre,
                                      style:
                                          GoogleFonts.karla(
                                        color:
                                            Colors.white,
                                        fontSize: 22,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 6),

                                    Text(
                                      correo,
                                      style:
                                          GoogleFonts.karla(
                                        color:
                                            Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 14),

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors.white
                                            .withOpacity(
                                                .12),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    30),
                                      ),
                                      child: Text(
                                        'User Traveler ✈️',
                                        style:
                                            GoogleFonts
                                                .karla(
                                          color:
                                              Colors.amber,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// MENU
                  _modernMenuCard(
                    title: 'Edit Profile',
                    subtitle:
                        'Manage your personal information',
                    icon: Icons.person_outline,
                    color: const Color(0xFF4F46E5),
                    onTap: () => context.pushNamed(
                      EditarPerfilUsuarioWidget.routeName,
                    ),
                  ),

                  _modernMenuCard(
                    title: 'Notifications',
                    subtitle:
                        'Customize alerts and reminders',
                    icon: Icons.notifications_none,
                    color: Colors.orange,
                    onTap: () =>
                        _showComingSoonModal(context),
                  ),

                  _modernMenuCard(
                    title: 'About App',
                    subtitle:
                        'Version, policies and more',
                    icon: Icons.info_outline,
                    color: Colors.blue,
                    onTap: () =>
                        _showComingSoonModal(context),
                  ),

                  _modernMenuCard(
                    title: 'Support',
                    subtitle:
                        'Need help? Contact us',
                    icon: Icons.headset_mic_outlined,
                    color: Colors.green,
                    onTap: () =>
                        _showComingSoonModal(context),
                  ),

                  _modernMenuCard(
                    title: 'AI Assistant',
                    subtitle:
                        'Chat with artificial intelligence',
                    icon: Icons.smart_toy_outlined,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ChatScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  /// LOGOUT
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 75, 147, 255),
                            Color.fromARGB(255, 107, 166, 255),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.lightBlue.withOpacity(.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: FFButtonWidget(
                        onPressed: _signOut,
                        text: 'Log Out',
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 58,
                          color: Colors.transparent,
                          elevation: 0,
                          borderRadius:
                              BorderRadius.circular(18),
                          textStyle:
                              GoogleFonts.karla(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          wrapWithModel(
            model: _model.navBarModel,
            updateCallback: () => setState(() {}),
            child: NavBarWidget(),
          ),
        ],
      ),
    );
  }

  Widget _modernMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(22, 0, 22, 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: GoogleFonts.karla(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: GoogleFonts.karla(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}