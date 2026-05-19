import '/components/nav_bar_invitado_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_user_invitado_model.dart';
export 'profile_user_invitado_model.dart';

class ProfileUserInvitadoWidget extends StatefulWidget {
  const ProfileUserInvitadoWidget({super.key});

  static String routeName = 'ProfileUserInvitado';
  static String routePath = '/profileUserInvitado';

  @override
  State<ProfileUserInvitadoWidget> createState() =>
      _ProfileUserInvitadoWidgetState();
}

class _ProfileUserInvitadoWidgetState
    extends State<ProfileUserInvitadoWidget> {
  late ProfileUserInvitadoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileUserInvitadoModel());

    loadNotificationSettings();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// VARIABLES DE ESTADO
  bool eventNotifications = false;
  bool promotions = false;
  bool appUpdates = false;

  /// CARGAR CONFIGURACION
  Future<void> loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      eventNotifications =
          prefs.getBool('eventNotifications') ?? false;
      promotions = prefs.getBool('promotions') ?? false;
      appUpdates = prefs.getBool('appUpdates') ?? false;
    });
  }

  /// GUARDAR CONFIGURACION
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
        'eventNotifications', eventNotifications);

    await prefs.setBool('promotions', promotions);

    await prefs.setBool('appUpdates', appUpdates);
  }

  /// PEDIR PERMISOS
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.request();

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notifications enabled"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Notification permission denied"),
        ),
      );
    }
  }

  /// SETTINGS
  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Notification Settings",
                    style: GoogleFonts.karla(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _switchTile(
                    title: "Event Notifications",
                    value: eventNotifications,
                    icon: Icons.notifications_active,
                    color: Colors.orange,
                    onChanged: (v) async {

                      if (v) {
                        await requestNotificationPermission();
                      }

                      setModalState(() {
                        eventNotifications = v;
                      });

                      setState(() {});
                      saveSettings();
                    },
                  ),

                  _switchTile(
                    title: "Promotions",
                    value: promotions,
                    icon: Icons.local_offer,
                    color: Colors.pink,
                    onChanged: (v) {

                      setModalState(() {
                        promotions = v;
                      });

                      setState(() {});
                      saveSettings();
                    },
                  ),

                  _switchTile(
                    title: "App Updates",
                    value: appUpdates,
                    icon: Icons.system_update,
                    color: Colors.blue,
                    onChanged: (v) {

                      setModalState(() {
                        appUpdates = v;
                      });

                      setState(() {});
                      saveSettings();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// ABOUT
  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "About the App",
            style: GoogleFonts.karla(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "This application helps tourists discover trusted places such as restaurants, hotels, bars and other locations while avoiding price scams.",
            style: GoogleFonts.karla(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  /// SUPPORT
  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Contact Support",
                style: GoogleFonts.karla(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              _supportTile(
                icon: Icons.email,
                color: Colors.blue,
                title: "Email Support",
                subtitle: "support@priceqr.com",
              ),

              const SizedBox(height: 14),

              _supportTile(
                icon: Icons.phone,
                color: Colors.orange,
                title: "Call Support",
                subtitle: "+57 300 000 0000",
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToRegister() {
    context.pushNamed("OpcionDeRegistro");
  }

  Widget optionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 10,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _switchTile({
    required String title,
    required bool value,
    required IconData icon,
    required Color color,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: GoogleFonts.karla(
            fontWeight: FontWeight.w600,
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
      ),
    );
  }

  Widget _supportTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: GoogleFonts.karla(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: GoogleFonts.karla(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),

      body: Stack(
        children: [

          /// FONDO
          Container(
            width: double.infinity,
            height: double.infinity,
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
                stops: [0, .30, .30, 1],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [

                /// HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      22, 70, 22, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.08),
                      borderRadius:
                          BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(.08),
                      ),
                    ),
                    child: Column(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber,
                                Colors.orange,
                              ],
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 52,
                            backgroundImage: AssetImage(
                              'assets/images/wmremove-transformed.jpeg',
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "Guest User",
                          style: GoogleFonts.karla(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Browsing in guest mode",
                          style: GoogleFonts.karla(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// OPTIONS
                optionCard(
                  "Notification Settings",
                  "Manage alerts and updates",
                  Icons.notifications_outlined,
                  Colors.orange,
                  _showNotificationSettings,
                ),

                optionCard(
                  "About the App",
                  "Learn more about PriceQR",
                  Icons.info_outline,
                  Colors.blue,
                  _showAboutApp,
                ),

                optionCard(
                  "Contact Support",
                  "Need help? Contact us",
                  Icons.support_agent,
                  Colors.green,
                  _contactSupport,
                ),

                const SizedBox(height: 35),

                /// REGISTER BUTTON
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                          horizontal: 22),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F46E5),
                          Color(0xFF6366F1),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue
                              .withOpacity(.25),
                          blurRadius: 14,
                          offset:
                              const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: FFButtonWidget(
                      onPressed: _goToRegister,
                      text: 'Create Account',
                      icon: const Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                        size: 20,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 58,
                        color: Colors.transparent,
                        elevation: 0,
                        borderRadius:
                            BorderRadius.circular(
                                18),
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

                const SizedBox(height: 130),
              ],
            ),
          ),

          wrapWithModel(
            model: _model.navBarInvitadoModel,
            updateCallback: () => safeSetState(() {}),
            child: NavBarInvitadoWidget(),
          ),
        ],
      ),
    );
  }
}