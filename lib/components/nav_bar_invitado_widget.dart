import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nav_bar_invitado_model.dart';
export 'nav_bar_invitado_model.dart';

class NavBarInvitadoWidget extends StatefulWidget {
  const NavBarInvitadoWidget({super.key});

  @override
  State<NavBarInvitadoWidget> createState() =>
      _NavBarInvitadoWidgetState();
}

class _NavBarInvitadoWidgetState
    extends State<NavBarInvitadoWidget> {
  late NavBarInvitadoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => NavBarInvitadoModel());
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

  void showRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor:
              FlutterFlowTheme.of(context)
                  .secondaryBackground,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                /// CERRAR
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () =>
                        Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color:
                          FlutterFlowTheme.of(context)
                              .secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// TITULO
                Text(
                  'Exclusive feature for registered users',
                  style:
                      FlutterFlowTheme.of(context)
                          .titleMedium
                          .override(
                            font:
                                GoogleFonts.karla(),
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            letterSpacing: 0,
                          ),
                ),

                const SizedBox(height: 12),

                /// TEXTO
                Text(
                  'Create an account to access notifications and enjoy all the benefits of PriceQR.',
                  style:
                      FlutterFlowTheme.of(context)
                          .bodyMedium,
                ),

                const SizedBox(height: 22),

                /// BOTON
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      context.pushNamed(
                        OpcionDeRegistroWidget
                            .routeName,
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          FlutterFlowTheme.of(
                                  context)
                              .primary,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),
                    ),
                    child: const Text(
                      'Create account',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          const AlignmentDirectional(0.0, 1.0),

      child: Container(
        width: double.infinity,
        height: 90,

        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),

        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [

            /// NAVBAR
            Container(
              width: double.infinity,
              height: 72,

              margin:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),

              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                child: Row(
                  children: [

                    /// EXPLORE
                    navItem(
                      icon:
                          Icons.explore_rounded,
                      label: 'Explore',
                      colors: const [
                        Color(0xFF4F46E5),
                        Color(0xFF6366F1),
                      ],
                      onTap: () async {
                        context.pushNamed(
                          HomeInvitadoWidget
                              .routeName,
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
                          extra:
                              <String, dynamic>{
                            kTransitionInfoKey:
                                TransitionInfo(
                              hasTransition:
                                  true,
                              transitionType:
                                  PageTransitionType
                                      .rightToLeft,
                              duration:
                                  Duration(
                                milliseconds:
                                    1,
                              ),
                            ),
                          },
                        );
                      },
                    ),

                    const SizedBox(width: 58),

                    /// INBOX RESTRINGIDO
                    navItem(
                      icon: Icons
                          .notifications_rounded,
                      label: 'Inbox',
                      colors: const [
                        Color(0xFF0EA5E9),
                        Color(0xFF38BDF8),
                      ],
                      onTap: () async {
                        showRegisterDialog();
                      },
                    ),

                    /// PROFILE
                    navItem(
                      icon:
                          Icons.person_rounded,
                      label: 'Profile',
                      colors: const [
                        Color(0xFF111827),
                        Color(0xFF374151),
                      ],
                      onTap: () async {
                        context.pushNamed(
                          ProfileUserInvitadoWidget
                              .routeName,
                        );
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
                  gradient:
                      const LinearGradient(
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
                      offset:
                          const Offset(0, 8),
                    )
                  ],
                ),

                child: FlutterFlowIconButton(
                  borderRadius: 99,
                  buttonSize: 62,
                  fillColor:
                      Colors.transparent,

                  icon: const Icon(
                    Icons.qr_code_rounded,
                    color: Colors.white,
                    size: 30,
                  ),

                  onPressed: () async {
                    context.pushNamed(
                      QRVerificationWidget
                          .routeName,
                      extra:
                          <String, dynamic>{
                        kTransitionInfoKey:
                            TransitionInfo(
                          hasTransition: true,
                          transitionType:
                              PageTransitionType
                                  .rightToLeft,
                          duration: Duration(
                            milliseconds: 350,
                          ),
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