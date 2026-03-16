import '/flutter_flow/flutter_flow_theme.dart';
import '/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'perfil_vendedor_model.dart';
export 'perfil_vendedor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '/components/nav_bar_widget.dart';

class PerfilVendedorWidget extends StatefulWidget {
  const PerfilVendedorWidget({super.key});

  static String routeName = 'PerfilVendedor';
  static String routePath = '/perfilVendedor';

  @override
  State<PerfilVendedorWidget> createState() => _PerfilVendedorWidgetState();
}

class _PerfilVendedorWidgetState extends State<PerfilVendedorWidget> {
  late PerfilVendedorModel _model;

  String nombre = '';
  String correo = '';

  bool cargando = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilVendedorModel());
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => cargando = false);
      return;
    }

    try {
      final vendedorDoc = await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(user.uid)
          .get();

      if (vendedorDoc.exists && vendedorDoc.data() != null) {
        final data = vendedorDoc.data()!;
        nombre = data['nombre'] ?? 'Vendedor';
        correo = data['correo'] ?? user.email ?? '';
      } else {
        nombre = 'Vendedor';
        correo = user.email ?? '';
      }
    } catch (e) {
      print("Error cargando datos: $e");
    }

    setState(() {
      cargando = false;
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [

                    /// HEADER PROFESIONAL
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF3A7BD5),
                            Color(0xFF00D2FF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [

                          /// AVATAR
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.black26,
                                  offset: Offset(0,6),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.storefront,
                              size: 50,
                              color: Color(0xFF3A7BD5),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            correo,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// BOTON EDITAR PERFIL
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3A7BD5),
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              context.pushNamed('EditarPerfilVendedor');
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Editar perfil"),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// TARJETA QR 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          context.pushNamed(GenerarQrWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 170,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF667EEA),
                                Color(0xFF764BA2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 15,
                                color: Colors.black26,
                                offset: Offset(0,5),
                              )
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(
                                Icons.qr_code_2,
                                size: 75,
                                color: Colors.white,
                              ),

                              SizedBox(height: 10),

                              Text(
                                "QR de mi catálogo",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              Text(
                                "Compártelo con tus clientes",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _sectionTitle("Gestión de vendedor"),

                    _menuOption(
                        Icons.inventory_2_outlined,
                        "Mi catálogo de productos",
                        () => context.pushNamed('MiCatalogo')),

                    _menuOption(
                        Icons.add_business_outlined,
                        "Añadir nuevo producto",
                        () => context.pushNamed('AnadirProducto')),

                    const SizedBox(height: 25),

                    _sectionTitle("Configuración"),

                    _menuOption(
                        Icons.notifications_outlined,
                        "Notificaciones",
                        () => context.pushNamed('NotificationsWidget')),

                    _menuOption(
                        Icons.security_outlined,
                        "Privacidad y seguridad",
                        () {}),

                    _menuOption(
                        Icons.settings_outlined,
                        "Configuración general",
                        () {}),

                    const SizedBox(height: 35),

                    /// BOTON CERRAR SESION
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            context.pushNamed(SignAccesoWidget.routeName);
                          }
                        },
                        text: 'Cerrar sesión',
                        icon: const Icon(Icons.logout),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: Colors.black,
                          textStyle: const TextStyle(color: Colors.white),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40)
                  ],
                ),
              ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _menuOption(IconData icon, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: Offset(0,4),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 14),
              Expanded(child: Text(text)),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
