// 📄 generar_qr_widget.dart - VERSIÓN MEJORADA
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'generar_qr_model.dart';
export 'generar_qr_model.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerarQrWidget extends StatefulWidget {
  const GenerarQrWidget({super.key});

  static String routeName = 'GenerarQr';
  static String routePath = '/generarQr';

  @override
  State<GenerarQrWidget> createState() => _GenerarQrWidgetState();
}

class _GenerarQrWidgetState extends State<GenerarQrWidget> {
  late GenerarQrModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String qrData = '';
  String nombreVendedor = '';
  int cantidadProductos = 0;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GenerarQrModel());
    _cargarDatosVendedor();
  }

  Future<void> _cargarDatosVendedor() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => cargando = false);
      return;
    }

    try {
      // 1. Cargar información del vendedor
      final vendedorDoc = await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(user.uid)
          .get();

      // 2. Contar productos del vendedor
      final productosSnapshot = await FirebaseFirestore.instance
          .collection('catalogo')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        nombreVendedor = vendedorDoc.data()?['nombre'] ?? 'Vendedor';
        cantidadProductos = productosSnapshot.docs.length;
        
        // ✅ QR QUE SÍ FUNCIONA - Formato simple y claro
        qrData = 'priceqr://vendedor/${user.uid}';
        // Alternativa: 'https://priceqr.com/vendedor/${user.uid}'
        
        cargando = false;
      });
    } catch (e) {
      print('❌ Error cargando datos para QR: $e');
      setState(() {
        qrData = 'priceqr://vendedor/${user.uid}';
        nombreVendedor = 'Vendedor';
        cargando = false;
      });
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
        title: Text(
          'Mi Código QR',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Karla',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 22.0,
                letterSpacing: 0.0,
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        elevation: 0.0,
      ),
      body: cargando ? _buildLoading() : _buildBody(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Generando tu código QR...'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // ✅ INFORMACIÓN DEL VENDEDOR
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    nombreVendedor,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$cantidadProductos productos en catálogo',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // ✅ QR REAL Y FUNCIONAL
            Text(
              'Código QR de mi catálogo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            
            SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Escanea para ver mi catálogo',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // ✅ DATOS DEL QR (PARA PRUEBAS)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos del QR:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    qrData,
                    style: TextStyle(
                      fontSize: 10,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // ✅ BOTONES DE ACCIÓN
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Compartir QR (implementaremos luego)
                      _mostrarMensaje('Función de compartir próximamente');
                    },
                    icon: Icon(Icons.share),
                    label: Text('Compartir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.pop(); // ✅ BOTÓN PARA VOLVER
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Volver'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // ✅ INSTRUCCIONES
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 ¿Cómo usar este QR?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Los turistas escanean este código con la app PriceQR\n'
                    '2. Podrán ver todos tus productos y precios\n'
                    '3. Tu catálogo se actualiza automáticamente',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
    );
  }
}