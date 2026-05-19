import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nav_bar_model.dart';
export 'nav_bar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  late NavBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// ICONO
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),

            const SizedBox(height: 6),

            /// TEXTO
            Text(
              label,
              style: GoogleFonts.karla(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 1.0),

      child: Container(
        width: double.infinity,
        height: 90,

        decoration: BoxDecoration(
          color: Colors.transparent,
        ),

        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [

            /// NAVBAR
            Container(
              width: double.infinity,
              height: 72,

              margin: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                child: Row(
                  children: [

                    /// EXPLORE
                    navItem(
                      icon: Icons.explore_rounded,
                      label: 'Explore',
                      colors: const [
                        Color(0xFF4F46E5),
                        Color(0xFF6366F1),
                      ],
                      onTap: () async {
                        context.pushNamed(
                          HomeWidget.routeName,
                        );
                      },
                    ),

                    /// SOS
                    navItem(
                      icon: Icons.sos_rounded,
                      label: 'SOS',
                      colors: const [
                        Color(0xFFFF4D4D),
                        Color(0xFFFF6B6B),
                      ],
                      onTap: () async {
                        context.pushNamed(
                          SosWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey:
                                TransitionInfo(
                              hasTransition: true,
                              transitionType:
                                  PageTransitionType
                                      .rightToLeft,
                              duration: Duration(
                                  milliseconds: 250),
                            ),
                          },
                        );
                      },
                    ),

                    const SizedBox(width: 58),

                    /// INBOX
                    navItem(
                      icon: Icons.notifications_rounded,
                      label: 'Inbox',
                      colors: const [
                        Color(0xFF0EA5E9),
                        Color(0xFF38BDF8),
                      ],
                      onTap: () async {
                        context.pushNamed(
                          NotificationsWidget
                              .routeName,
                        );
                      },
                    ),

                    /// PROFILE
                    navItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      colors: const [
                        Color(0xFF111827),
                        Color(0xFF374151),
                      ],
                      onTap: () async {

                        final user =
                            FirebaseAuth.instance
                                .currentUser;

                        if (user == null) {

                          context.pushNamed(
                            SignAccesoWidget
                                .routeName,
                          );

                          return;
                        }

                        final userDoc =
                            await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(user.uid)
                                .get();

                        final rol =
                            userDoc.data()?['rol'] ??
                                'cliente';

                        if (rol == 'vendedor') {

                          context.pushNamed(
                            PerfilVendedorWidget
                                .routeName,
                          );

                        } else {

                          context.pushNamed(
                            ProfileUserWidget
                                .routeName,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// BOTON QR CENTRAL
            Positioned(
              top: 0,

              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF111827),
                      Color(0xFF1F2937),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),

                child: FlutterFlowIconButton(
                  borderRadius: 99,
                  buttonSize: 62,
                  fillColor: Colors.transparent,

                  icon: const Icon(
                    Icons.qr_code_rounded,
                    color: Colors.white,
                    size: 30,
                  ),

                  onPressed: () async {

                    context.pushNamed(
                      QRVerificationWidget
                          .routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey:
                            TransitionInfo(
                          hasTransition: true,
                          transitionType:
                              PageTransitionType
                                  .rightToLeft,
                          duration: Duration(
                              milliseconds: 350),
                        ),
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}