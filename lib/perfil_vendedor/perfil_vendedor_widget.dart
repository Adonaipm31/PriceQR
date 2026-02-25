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

  // ✅ AGREGAR ESTAS CONSTANTES PARA LA RUTA
  static String routeName = 'PerfilVendedor';
  static String routePath = '/perfilVendedor';

  @override
  State<PerfilVendedorWidget> createState() => _PerfilVendedorWidgetState();
}

class _PerfilVendedorWidgetState extends State<PerfilVendedorWidget> {
  late PerfilVendedorModel _model;

  String nombre = '';
  String correo = '';
  /* String ciudad = ''; */
  bool cargando = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

 @override
void initState() {
  super.initState();
  _model = createModel(context, () => PerfilVendedorModel());
  _cargarDatosVendedor();
}

Future<void> _cargarDatosVendedor() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    setState(() => cargando = false);
    return;
  }

  try {
    final doc = await FirebaseFirestore.instance
        .collection('vendedores')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      setState(() {
        nombre = data['nombre'] ?? 'Vendedor';
        correo = data['correo'] ?? user.email ?? 'Correo no disponible';
      });
    } else {
      // Si no existe el documento
      setState(() {
        nombre = 'Vendedor no encontrado';
        correo = user.email ?? 'Correo no disponible';
      });
    }
  } catch (e) {
    print('❌ Error al cargar datos del vendedor: $e');
  } finally {
    setState(() => cargando = false);
  }
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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Perfil Vendedor',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Karla',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
            child: InkWell(
              onTap: () {
                context.pushNamed('EditarPerfilVendedorWidget');
              },
              child: Icon(
                Icons.edit_outlined,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con información del usuario
              
             
Padding(
  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
  child: Row(
    children: [
      Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).alternate,
          shape: BoxShape.circle,
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 2.0,
          ),
        ),
        child: Icon(
          Icons.person,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 40.0,
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cargando)
                const Center(child: CircularProgressIndicator())
              else ...[
                Text(
                  nombre.isNotEmpty ? nombre : 'Nombre no disponible',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Karla',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Text(
                    correo.isNotEmpty ? correo : 'Correo no disponible',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Karla',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ],
  ),
),

              // Separador
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                child: Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),

              // QR del catálogo
              
Padding(
  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          'QR de mi catálogo de productos',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Karla',
                letterSpacing: 0.0,
              ),
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
        child: InkWell(
          onTap: () {
            // ✅ NAVEGACIÓN AL GENERAR QR
            context.pushNamed(GenerarQrWidget.routeName);
          },
          child: Container(
            width: double.infinity,
            height: 200.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x33000000),
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_2,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 80.0,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    'Código QR',
                    style: FlutterFlowTheme.of(context)
                        .bodyMedium
                        .override(
                          fontFamily: 'Karla',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                  child: Text(
                    'Toca aquí para generar y ver tu código QR',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context)
                        .bodySmall
                        .override(
                          fontFamily: 'Karla',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                SizedBox(height: 8),
                // ✅ INDICADOR VISUAL DE QUE ES CLICKEABLE
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Toca para ver QR',
                    style: TextStyle(
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
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

              // Separador
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                child: Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),

              // Configuración de cuenta
              _buildSectionTitle('Gestión de Vendedor'),
              _buildMenuOption(
                icon: Icons.edit_outlined,
                title: 'Editar perfil',
                onTap: () {
                  context.pushNamed('EditarPerfilVendedorWidget');
                },
              ),
              _buildMenuOption(
  icon: Icons.inventory_2_outlined,
  title: 'Mi catálogo de productos',
  onTap: () {
    // ✅ NAVEGACIÓN CORRECTA USANDO routeName
    context.pushNamed('MiCatalogo');
  },
),
                          _buildMenuOption(
                icon: Icons.add_business_outlined,
                title: 'Añadir nuevo producto',
                onTap: () {
                  context.pushNamed('AnadirProducto');
                },
              ),
              
              _buildMenuOption(
                icon: Icons.bar_chart_outlined,
                title: 'Estadísticas de ventas',
                onTap: () {
                  // Navegar a estadísticas
                  print('Navegar a estadísticas');
                },
              ),

              // Separador
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                child: Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),

              // Configuración
              _buildSectionTitle('Configuración'),
              _buildMenuOption(
                icon: Icons.notifications_outlined,
                title: 'Notificaciones',
                onTap: () {
                  context.pushNamed('NotificationsWidget');
                },
              ),
              _buildMenuOption(
                icon: Icons.security_outlined,
                title: 'Privacidad y seguridad',
                onTap: () {
                  // Navegar a privacidad
                  print('Navegar a privacidad');
                },
              ),
              _buildMenuOption(
                icon: Icons.settings_outlined,
                title: 'Configuración general',
                onTap: () {
                  // Navegar a configuración
                  print('Navegar a configuración');
                },
              ),

              // Separador
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                child: Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),

              // Soporte
              _buildSectionTitle('Soporte'),
              _buildMenuOption(
                icon: Icons.help_outline,
                title: 'Centro de ayuda',
                onTap: () {
                  // Navegar a ayuda
                  print('Navegar a centro de ayuda');
                },
              ),
              _buildMenuOption(
                icon: Icons.support_agent_outlined,
                title: 'Contactar soporte',
                subtitle: 'Soporte técnico y asistencia general',
                onTap: () {
                  // Contactar soporte
                  print('Contactar soporte');
                },
              ),
              _buildMenuOption(
                icon: Icons.info_outline,
                title: 'Acerca de la aplicación',
                onTap: () {
                  // Navegar a acerca de
                  print('Navegar a acerca de');
                },
              ),

              // Cerrar sesión
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 32.0),
                child: FFButtonWidget(
                  onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        context.pushNamed(SignAccesoWidget.routeName);
                      }
                    },

                  text: 'Cerrar sesión',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).error,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Karla',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 2.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
      child: Text(
        title,
        style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: 'Karla',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Karla',
                                letterSpacing: 0.0,
                              ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                            child: Text(
                              subtitle,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Karla',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}