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

class _ProfileUserInvitadoWidgetState extends State<ProfileUserInvitadoWidget> {
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

// VARIABLES DE ESTADO
bool eventNotifications = false;
bool promotions = false;
bool appUpdates = false;

// CARGAR CONFIGURACION GUARDADA
Future<void> loadNotificationSettings() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    eventNotifications = prefs.getBool('eventNotifications') ?? false;
    promotions = prefs.getBool('promotions') ?? false;
    appUpdates = prefs.getBool('appUpdates') ?? false;
  });
}

// GUARDAR CONFIGURACION
Future<void> saveSettings() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('eventNotifications', eventNotifications);
  await prefs.setBool('promotions', promotions);
  await prefs.setBool('appUpdates', appUpdates);
}

// PEDIR PERMISO DE NOTIFICACIONES
Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();

  if (status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notifications enabled")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notification permission denied")),
    );
  }
}

/// NOTIFICATION SETTINGS FUNCIONAL
void _showNotificationSettings() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Notification Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  title: const Text("Event Notifications"),
                  value: eventNotifications,
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

                SwitchListTile(
                  title: const Text("Promotions"),
                  value: promotions,
                  onChanged: (v) {

                    setModalState(() {
                      promotions = v;
                    });

                    setState(() {});
                    saveSettings();
                  },
                ),

                SwitchListTile(
                  title: const Text("App Updates"),
                  value: appUpdates,
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

  /// ABOUT APP
  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("About the App"),
          content: const Text(
            "This application helps tourists discover trusted places such as restaurants, hotels, bars and other locations while avoiding price scams. "
            "You can explore locations, read reviews and enjoy a safer experience during your travels.",
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
 
  /// CONTACT SUPPORT
  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Contact Support",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text("Email Support"),
                subtitle: Text("support@priceqr.com"),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.orange),
                title: Text("Call Support"),
                subtitle: Text("+57 300 000 0000"),
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

  Widget optionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,

      body: Stack(
        children: [

          SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 52, 105, 219),
                        Color.fromARGB(255, 8, 70, 204),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Row(
                      children: [

                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              'assets/images/wmremove-transformed.jpeg',
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Guest User",
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .copyWith(color: Colors.white),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Browsing in guest mode",
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .copyWith(color: Colors.white70),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                optionCard(
                  "Notification Settings",
                  Icons.notifications,
                  Colors.orange,
                  _showNotificationSettings,
                ),

                optionCard(
                  "About the App",
                  Icons.info,
                  Colors.blue,
                  _showAboutApp,
                ),

                optionCard(
                  "Contact Support",
                  Icons.support_agent,
                  Colors.green,
                  _contactSupport,
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FFButtonWidget(
                    onPressed: _goToRegister,
                    text: "Create Account",
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 55,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 6,
                      borderRadius: BorderRadius.circular(14),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                        font: GoogleFonts.karla(),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 120),
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