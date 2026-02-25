import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'q_r_verification_model.dart';
export 'q_r_verification_model.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart'; // ← AGREGAR ESTE IMPORT

class QRVerificationWidget extends StatefulWidget {
  const QRVerificationWidget({super.key});

  static String routeName = 'QRVerification';
  static String routePath = '/qRVerification';

  @override
  State<QRVerificationWidget> createState() => _QRVerificationWidgetState();
}

class _QRVerificationWidgetState extends State<QRVerificationWidget> {
  late QRVerificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isProcessing = false;
  bool _flashOn = false;
  bool _cameraFront = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QRVerificationModel());
  }

  @override
  void dispose() {
    _model.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });
    _cameraController.toggleTorch();
  }

  void _switchCamera() {
    setState(() {
      _cameraFront = !_cameraFront;
    });
    _cameraController.switchCamera();
  }

  void _vibrate() {
    // Efecto de vibración visual
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/QR_Verification.png',
              ).image,
            ),
          ),
          child: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // HEADER MEJORADO
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 11.0),
                      child: Container(
                        width: double.infinity,
                        height: 35.0,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.safePop();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              'Escanear QR',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Karla',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 24), // Para balancear el diseño
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'assets/images/Button.png',
                              width: 200.0,
                              height: 77.6,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CONTENEDOR DE CÁMARA MEJORADO
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                children: [
                                  MobileScanner(
                                    controller: _cameraController,
                                    onDetect: (capture) async {
                                      if (_isProcessing) return;
                                      _isProcessing = true;
                                      _vibrate(); // Vibración al detectar

                                      final List<Barcode> barcodes = capture.barcodes;
                                      for (final barcode in barcodes) {
                                        final value = barcode.rawValue ?? '';
                                        debugPrint('🔍 Código detectado: $value');

                                        if (value.isEmpty) continue;

                                        // ✅ 1. DETECTAR FORMATO PRICEQR
                                        if (value.startsWith('priceqr://vendedor/')) {
                                          final userId = value.replaceFirst('priceqr://vendedor/', '');
                                          debugPrint('✅ QR PriceQR detectado - UserID: $userId');
                                          
                                          // Mostrar feedback visual
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text('Catálogo detectado!'),
                                                ],
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          // Navegar al catálogo público
                                          if (mounted) {
                                            await Future.delayed(Duration(milliseconds: 500));
                                            context.pushNamed(
                                              'CatalogoPublico',
                                              pathParameters: {'userId': userId},
                                            );
                                          }
                                          _isProcessing = true;
                                          return;
                                        }

                                        // ✅ 2. VERIFICAR SI ES IMAGEN
                                        final isImageUrl = value.endsWith('.jpg') ||
                                            value.endsWith('.jpeg') ||
                                            value.endsWith('.png') ||
                                            value.endsWith('.gif') ||
                                            value.contains('data:image');

                                        if (isImageUrl) {
                                          // Muestra modal con la imagen
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              bool isFullScreen = false;

                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Dialog(
                                                    insetPadding: isFullScreen
                                                        ? EdgeInsets.zero
                                                        : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                                    backgroundColor:
                                                        Colors.black.withOpacity(isFullScreen ? 1.0 : 0.9),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(isFullScreen ? 0 : 20),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isFullScreen = !isFullScreen;
                                                            });
                                                          },
                                                          child: InteractiveViewer(
                                                            child: Image.network(
                                                              value,
                                                              fit: BoxFit.contain,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return Container(
                                                                  padding: const EdgeInsets.all(20),
                                                                  child: const Text(
                                                                    'No se pudo cargar la imagen 😢',
                                                                    style: TextStyle(color: Colors.white),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 10,
                                                          top: 10,
                                                          child: IconButton(
                                                            icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                                            onPressed: () => Navigator.of(context).pop(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );

                                        } else {
                                          // ✅ 3. CUALQUIER OTRO QR
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('📄 QR: $value'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      }

                                      await Future.delayed(const Duration(seconds: 2));
                                      _isProcessing = false;
                                    },
                                  ),

                                  // MARCO DE ESCANEO MEJORADO
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CustomPaint(
                                        painter: _ScannerOverlayPainter(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // CONTROLES DE CÁMARA
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // BOTÓN FLASH
                                _CameraControlButton(
                                  icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                                  onPressed: _toggleFlash,
                                  tooltip: _flashOn ? 'Apagar flash' : 'Encender flash',
                                ),
                                SizedBox(width: 20),
                                // BOTÓN CAMBIAR CÁMARA
                                _CameraControlButton(
                                  icon: _cameraFront ? Icons.camera_front : Icons.camera_rear,
                                  onPressed: _switchCamera,
                                  tooltip: _cameraFront ? 'Cámara trasera' : 'Cámara frontal',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // INSTRUCCIONES MEJORADAS
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 20),
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
                            '📱 Cómo escanear',
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Karla',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Apunta a un código QR de vendedor PriceQR\n'
                            '• Mantén estable el dispositivo\n'
                            '• El escaneo es automático',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Karla',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontSize: 12,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// BOTÓN DE CONTROL DE CÁMARA PERSONALIZADO
class _CameraControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _CameraControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}

// OVERLAY PERSONALIZADO PARA EL ESCÁNER
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final cornerSize = 20.0;
    final margin = 40.0;

    // Esquina superior izquierda
    path.moveTo(margin, margin + cornerSize);
    path.lineTo(margin, margin);
    path.lineTo(margin + cornerSize, margin);

    // Esquina superior derecha
    path.moveTo(size.width - margin - cornerSize, margin);
    path.lineTo(size.width - margin, margin);
    path.lineTo(size.width - margin, margin + cornerSize);

    // Esquina inferior derecha
    path.moveTo(size.width - margin, size.height - margin - cornerSize);
    path.lineTo(size.width - margin, size.height - margin);
    path.lineTo(size.width - margin - cornerSize, size.height - margin);

    // Esquina inferior izquierda
    path.moveTo(margin + cornerSize, size.height - margin);
    path.lineTo(margin, size.height - margin);
    path.lineTo(margin, size.height - margin - cornerSize);

    canvas.drawPath(path, paint);

    // Línea de escaneo animada
    final scanPaint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..strokeWidth = 2;

    final animatedOffset = DateTime.now().millisecond / 1000 * size.height;
    canvas.drawLine(
      Offset(margin, margin + animatedOffset % (size.height - 2 * margin)),
      Offset(size.width - margin, margin + animatedOffset % (size.height - 2 * margin)),
      scanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}