import 'package:price_q_r/flutter_flow/form_field_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import 'package:flutter/material.dart';
import 'anadir_producto_model.dart';
export 'anadir_producto_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert'; // ✅ IMPORTANTE: Para base64

class AnadirProductoWidget extends StatefulWidget {
  const AnadirProductoWidget({super.key});

  static String routeName = 'AnadirProducto';
  static String routePath = '/anadirProducto';

  @override
  State<AnadirProductoWidget> createState() => _AnadirProductoWidgetState();
}

class _AnadirProductoWidgetState extends State<AnadirProductoWidget> {
  late AnadirProductoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _subiendo = false;
  int _caracteresDescripcion = 0;
  final int _maxCaracteres = 250;
  
  // ✅ VARIABLES PARA CONSULTA PRECIOS
  List<Map<String, dynamic>> _sugerencias = [];
  Map<String, dynamic>? _productoSeleccionado;
  bool _mostrarSugerencias = false;
  double _precioMaximoOficial = 0;
  double _precioReferenciaOficial = 0;

  // ✅ NUEVAS VARIABLES PARA IMÁGENES (BASE64)
  List<File> _imagenesSeleccionadas = [];
  List<String> _imagenesBase64 = []; // ✅ CAMBIO: Base64 en lugar de URLs
  bool _procesandoImagenes = false; // ✅ CAMBIO: Renombrado
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AnadirProductoModel());

    // Inicializar controllers
    _model.tipoValueController ??= FormFieldController<String>(null);
    _model.categoriaProductoValueController ??= FormFieldController<String>(null);
    
    _model.nombreProductoTextController ??= TextEditingController();
    _model.nombreProductoFocusNode ??= FocusNode();

    _model.descripcionProductoTextController ??= TextEditingController();
    _model.descripcionProductoFocusNode ??= FocusNode();

    _model.precioProductoTextController ??= TextEditingController();
    _model.precioProductoFocusNode ??= FocusNode();

    // Listener para contar caracteres
    _model.descripcionProductoTextController?.addListener(() {
      setState(() {
        _caracteresDescripcion = _model.descripcionProductoTextController?.text.length ?? 0;
      });
    });

    // Listener para búsqueda en tiempo real
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.nombreProductoTextController?.addListener(() {
        _buscarPreciosOficiales(_model.nombreProductoTextController?.text ?? '');
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ✅ FUNCIÓN: Filtrar categorías por tipo
  List<String> _obtenerCategoriasPorTipo(String? tipo) {
    if (tipo == 'Producto') {
      return const ['Comida', 'Bebidas', 'Otros Productos'];
    } else if (tipo == 'Servicio') {
      return const [
        'Servicios de Playa', 
        'Servicios de Bienestar', 
        'Actividades', 
        'Artesanías', 
        'Otros Servicios'
      ];
    } else {
      return const [
        'Comida', 'Bebidas', 'Servicios de Playa', 
        'Servicios de Bienestar', 'Actividades', 'Artesanías', 'Otros'
      ];
    }
  }

  // ✅ FUNCIÓN: Buscar precios oficiales
  Future<void> _buscarPreciosOficiales(String query) async {
    if (query.length < 2) {
      setState(() {
        _sugerencias = [];
        _mostrarSugerencias = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('precios_oficiales')
          .where('nombre', isGreaterThanOrEqualTo: query)
          .where('nombre', isLessThanOrEqualTo: query + 'z')
          .limit(5)
          .get();

      setState(() {
        _sugerencias = snapshot.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
        _mostrarSugerencias = _sugerencias.isNotEmpty;
      });
    } catch (e) {
      print('Error buscando precios oficiales: $e');
    }
  }

  // ✅ FUNCIÓN: Seleccionar producto oficial
  void _seleccionarProductoOficial(Map<String, dynamic> producto) {
    setState(() {
      _productoSeleccionado = producto;
      _precioMaximoOficial = (producto['precio_maximo'] ?? 0).toDouble();
      _precioReferenciaOficial = (producto['precio_referencia'] ?? 0).toDouble();
      
      // Auto-completar campos
      _model.nombreProductoTextController.text = producto['nombre'] ?? '';
      _model.descripcionProductoTextController.text = producto['descripcion'] ?? '';
      _model.precioProductoTextController.text = _precioReferenciaOficial.toStringAsFixed(0);
      
      // Auto-seleccionar categoría
      if (producto['categoria'] != null) {
        _model.categoriaProductoValue = producto['categoria'];
      }
      
      _mostrarSugerencias = false;
      _sugerencias = [];
    });
  }

  // ✅ FUNCIÓN: Convertir imagen a Base64
  Future<String> _convertirImagenABase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      print('Error convirtiendo imagen a base64: $e');
      throw e;
    }
  }

  // ✅ FUNCIÓN: Seleccionar de galería (BASE64)
  Future<void> _seleccionarDeGaleria() async {
    try {
      final XFile? imagen = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70, // ✅ REDUCIDO para base64 más pequeño
      );

      if (imagen != null && _imagenesSeleccionadas.length < 2) {
        final file = File(imagen.path);
        setState(() => _procesandoImagenes = true);
        
        try {
          final base64String = await _convertirImagenABase64(file);
          
          setState(() {
            _imagenesSeleccionadas.add(file);
            _imagenesBase64.add(base64String);
            _procesandoImagenes = false;
          });
        } catch (e) {
          setState(() => _procesandoImagenes = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error procesando imagen'),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
        }
      } else if (_imagenesSeleccionadas.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Máximo 2 imágenes permitidas'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } catch (e) {
      print('Error seleccionando imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  // ✅ FUNCIÓN: Tomar foto con cámara (BASE64)
  Future<void> _tomarFoto() async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 70, // ✅ REDUCIDO para base64 más pequeño
      );

      if (foto != null && _imagenesSeleccionadas.length < 2) {
        final file = File(foto.path);
        setState(() => _procesandoImagenes = true);
        
        try {
          final base64String = await _convertirImagenABase64(file);
          
          setState(() {
            _imagenesSeleccionadas.add(file);
            _imagenesBase64.add(base64String);
            _procesandoImagenes = false;
          });
        } catch (e) {
          setState(() => _procesandoImagenes = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error procesando imagen'),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
        }
      } else if (_imagenesSeleccionadas.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Máximo 2 imágenes permitidas'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } catch (e) {
      print('Error tomando foto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al tomar foto'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  // ✅ FUNCIÓN: Eliminar imagen
  void _eliminarImagen(int index) {
    setState(() {
      _imagenesSeleccionadas.removeAt(index);
      _imagenesBase64.removeAt(index);
    });
  }

  // ✅ WIDGET: Lista de sugerencias
  Widget _buildSugerencias() {
    if (!_mostrarSugerencias) return SizedBox();

    if (_sugerencias.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        ),
        child: Text(
          'No se encontraron precios oficiales para esta búsqueda.',
          style: FlutterFlowTheme.of(context).bodySmall.override(
            fontFamily: 'Karla',
            color: FlutterFlowTheme.of(context).secondaryText,
            letterSpacing: 0.0,
          ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _sugerencias.length,
        itemBuilder: (context, index) {
          final producto = _sugerencias[index];
          return ListTile(
            title: Text(
              producto['nombre'] ?? '',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Karla', letterSpacing: 0.0,
              ),
            ),
            subtitle: Text(
              'Ref: \$${producto['precio_referencia']?.toString() ?? '0'} COP • Máx: \$${producto['precio_maximo']?.toString() ?? '0'} COP',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Karla', color: FlutterFlowTheme.of(context).success, letterSpacing: 0.0,
              ),
            ),
            trailing: Text(producto['categoria'] ?? ''),
            onTap: () => _seleccionarProductoOficial(producto),
          );
        },
      ),
    );
  }

  // ✅ WIDGET: Indicador de validación de precio
  Widget _buildIndicadorPrecio() {
    if (_precioMaximoOficial == 0) return SizedBox();
    
    final precioIngresado = double.tryParse(_model.precioProductoTextController.text) ?? 0;
    final esPrecioValido = precioIngresado <= _precioMaximoOficial;
    
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: esPrecioValido 
            ? FlutterFlowTheme.of(context).success.withOpacity(0.1)
            : FlutterFlowTheme.of(context).error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: esPrecioValido 
              ? FlutterFlowTheme.of(context).success
              : FlutterFlowTheme.of(context).error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            esPrecioValido ? Icons.check_circle : Icons.warning_amber_rounded,
            color: esPrecioValido 
                ? FlutterFlowTheme.of(context).success
                : FlutterFlowTheme.of(context).error,
            size: 20.0,
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  esPrecioValido ? '✅ Precio dentro del rango oficial' : '⚠️ Precio superior al permitido',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Karla', fontWeight: FontWeight.bold,
                    color: esPrecioValido 
                        ? FlutterFlowTheme.of(context).success
                        : FlutterFlowTheme.of(context).error,
                    letterSpacing: 0.0,
                  ),
                ),
                Text(
                  esPrecioValido
                      ? 'Cumple con los precios establecidos por el gobierno'
                      : 'NO podrá registrar este precio - Máximo permitido: \$$_precioMaximoOficial COP',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Karla',
                    color: esPrecioValido 
                        ? FlutterFlowTheme.of(context).success
                        : FlutterFlowTheme.of(context).error,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FUNCIÓN PRINCIPAL: Guardar producto
  Future<void> _guardarProducto() async {
    // Validación básica
    if (_model.nombreProductoTextController.text.isEmpty ||
        _model.descripcionProductoTextController.text.isEmpty ||
        _model.precioProductoTextController.text.isEmpty ||
        _model.tipoValue == null ||
        _model.categoriaProductoValue == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (_caracteresDescripcion > _maxCaracteres) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La descripción no puede exceder los $_maxCaracteres caracteres'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    final precioIngresado = double.tryParse(_model.precioProductoTextController.text) ?? 0;
    
    // ✅ BUSCAR EN BASE DE DATOS SIEMPRE
    double precioMaximoEncontrado = 0;
    String nombreProductoOficial = '';
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('precios_oficiales')
          .where('categoria', isEqualTo: _model.categoriaProductoValue)
          .where('nombre', isGreaterThanOrEqualTo: _model.nombreProductoTextController.text)
          .where('nombre', isLessThanOrEqualTo: _model.nombreProductoTextController.text + 'z')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final producto = snapshot.docs.first.data();
        precioMaximoEncontrado = (producto['precio_maximo'] ?? 0).toDouble();
        nombreProductoOficial = producto['nombre'] ?? '';
      } else {
        final snapshotCategoria = await FirebaseFirestore.instance
            .collection('precios_oficiales')
            .where('categoria', isEqualTo: _model.categoriaProductoValue)
            .limit(5)
            .get();

        if (snapshotCategoria.docs.isNotEmpty) {
          for (final doc in snapshotCategoria.docs) {
            final precioMax = (doc.data()['precio_maximo'] ?? 0).toDouble();
            if (precioMax > precioMaximoEncontrado) {
              precioMaximoEncontrado = precioMax;
            }
          }
        }
      }
    } catch (e) {
      print('Error buscando precios oficiales: $e');
    }

    // ✅ VALIDACIÓN STRICT: Precio máximo oficial
    if (precioMaximoEncontrado > 0 && precioIngresado > precioMaximoEncontrado) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: FlutterFlowTheme.of(context).error, size: 24),
              SizedBox(width: 12),
              Text('Precio No Permitido', style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Karla', color: FlutterFlowTheme.of(context).error, letterSpacing: 0.0,
              )),
            ],
          ),
          content: Text(
            nombreProductoOficial.isNotEmpty
              ? 'Está sobrepasando los precios permitidos establecidos por el gobierno y la Asociación de Vendedores de Cartagena.\n\nProducto: $nombreProductoOficial\nPrecio ingresado: \$${precioIngresado.toStringAsFixed(0)} COP\nPrecio máximo permitido: \$${precioMaximoEncontrado.toStringAsFixed(0)} COP\n\nPor favor ajuste el precio para continuar con el registro.'
              : 'Está sobrepasando los precios permitidos establecidos por el gobierno y la Asociación de Vendedores de Cartagena.\n\nCategoría: ${_model.categoriaProductoValue}\nPrecio ingresado: \$${precioIngresado.toStringAsFixed(0)} COP\nPrecio máximo permitido en esta categoría: \$${precioMaximoEncontrado.toStringAsFixed(0)} COP\n\nPor favor ajuste el precio para continuar con el registro.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Karla', letterSpacing: 0.0, lineHeight: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Entendido', style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Karla', color: FlutterFlowTheme.of(context).primary, letterSpacing: 0.0,
              )),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _subiendo = true);

    try {
      // Obtener usuario actual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No hay usuario autenticado'), backgroundColor: FlutterFlowTheme.of(context).error),
        );
        setState(() => _subiendo = false);
        return;
      }

      // ✅ CREAR DOCUMENTO PARA FIRESTORE (CON BASE64)
      final nuevoProducto = {
        'nombre': _model.nombreProductoTextController.text,
        'descripcion': _model.descripcionProductoTextController.text,
        'precio': precioIngresado,
        'tipo': _model.tipoValue,
        'categoria': _model.categoriaProductoValue,
        'userId': user.uid,
        'userEmail': user.email,
        'stock': _model.tipoValue == 'Producto' 
            ? int.tryParse(_model.stockProductoTextController?.text ?? '0') ?? 0
            : null,
        'imagenes_base64': _imagenesBase64, // ✅ CAMBIO: Base64 en lugar de URLs
        'cantidad_imagenes': _imagenesBase64.length,
        'fecha_creacion': FieldValue.serverTimestamp(),
        'activo': true,
        'moneda': 'COP',
        if (_productoSeleccionado != null) ...{
          'precio_maximo_oficial': _precioMaximoOficial,
          'precio_referencia_oficial': _precioReferenciaOficial,
          'producto_oficial_id': _productoSeleccionado!['id'],
        }
      };

      // ✅ GUARDAR EN FIRESTORE
      await FirebaseFirestore.instance.collection('catalogo').add(nuevoProducto);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_model.tipoValue == 'Producto' ? 'Producto' : 'Servicio'} guardado exitosamente'),
          backgroundColor: FlutterFlowTheme.of(context).success,
        ),
      );

    } catch (e) {
      print('Error guardando producto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      setState(() => _subiendo = false);
    }

    if (context.mounted) {
      context.pop();
    }
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
          'Añadir Producto/Servicio',
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
              onTap: () => context.pop(),
              child: Icon(
                Icons.close,
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ SECCIÓN IMÁGENES MEJORADA (BASE64)
                Column(
                  children: [
                    Text(
                      'Imágenes (Máximo 2)',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Karla',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 8.0),
                    
                    if (_imagenesSeleccionadas.isNotEmpty) ...[
                      SizedBox(
                        height: 150.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imagenesSeleccionadas.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 150.0,
                                  margin: EdgeInsets.only(right: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: DecorationImage(
                                      image: FileImage(_imagenesSeleccionadas[index]),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).alternate,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 20.0,
                                  child: CircleAvatar(
                                    radius: 12.0,
                                    backgroundColor: FlutterFlowTheme.of(context).error,
                                    child: IconButton(
                                      icon: Icon(Icons.close, size: 12.0, color: Colors.white),
                                      onPressed: () => _eliminarImagen(index),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: (_imagenesSeleccionadas.length >= 2 || _procesandoImagenes) ? null : _seleccionarDeGaleria,
                            text: 'Galería',
                            icon: Icon(Icons.photo_library, size: 20.0),
                            options: FFButtonOptions(
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Karla',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                  ),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: (_imagenesSeleccionadas.length >= 2 || _procesandoImagenes) ? null : _tomarFoto,
                            text: 'Cámara',
                            icon: Icon(Icons.camera_alt, size: 20.0),
                            options: FFButtonOptions(
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Karla',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                  ),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    if (_procesandoImagenes) ...[
                      SizedBox(height: 16.0),
                      LinearProgressIndicator(
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Procesando imagen...',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Karla',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 24.0),

                // Tipo (Producto o Servicio)
                Text(
                  'Tipo *',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 8.0),
                FlutterFlowDropDown<String>(
                  controller: _model.tipoValueController ??= FormFieldController<String>(null),
                  options: const ['Producto', 'Servicio'],
                  onChanged: (val) {
                    setState(() {
                      _model.tipoValue = val;
                      _model.categoriaProductoValue = null;
                      _model.categoriaProductoValueController?.value = null;
                    });
                  },
                  width: double.infinity,
                  height: 50.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Karla',
                        letterSpacing: 0.0,
                      ),
                  hintText: 'Selecciona el tipo',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2.0,
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderWidth: 2.0,
                  borderRadius: 8.0,
                  margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                  hidesUnderline: true,
                ),

                SizedBox(height: 16.0),

                // Nombre con búsqueda en tiempo real
                Text(
                  'Nombre *',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _model.nombreProductoTextController,
                      focusNode: _model.nombreProductoFocusNode,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Escribe para buscar precios oficiales...',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        suffixIcon: _productoSeleccionado != null
                            ? Icon(Icons.check_circle, color: FlutterFlowTheme.of(context).success)
                            : null,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Karla',
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 8.0),
                    _buildSugerencias(),
                  ],
                ),

                SizedBox(height: 16.0),

                // Descripción con contador
                Text(
                  'Descripción *',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _model.descripcionProductoTextController,
                  focusNode: _model.descripcionProductoFocusNode,
                  maxLines: 4,
                  maxLength: _maxCaracteres,
                  decoration: InputDecoration(
                    hintText: 'Describe tu ${_model.tipoValue?.toLowerCase() ?? 'producto/servicio'}...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    counterText: '$_caracteresDescripcion/$_maxCaracteres',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Karla',
                        letterSpacing: 0.0,
                      ),
                ),

                SizedBox(height: 16.0),

                // Precio y Categoría en fila
                Row(
                  children: [
                    // Precio
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio *',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _model.precioProductoTextController,
                            focusNode: _model.precioProductoFocusNode,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: '0',
                              prefixText: '\$ ',
                              suffixText: ' COP',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Karla',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // Categoría (filtrada por tipo)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categoría *',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 8.0),
                          FlutterFlowDropDown<String>(
                            controller: _model.categoriaProductoValueController ??= FormFieldController<String>(null),
                            options: _obtenerCategoriasPorTipo(_model.tipoValue),
                            onChanged: (val) => setState(() => _model.categoriaProductoValue = val),
                            width: double.infinity,
                            height: 50.0,
                            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Karla',
                                  letterSpacing: 0.0,
                                ),
                            hintText: 'Selecciona categoría',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                            elevation: 2.0,
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderWidth: 2.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                            hidesUnderline: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ✅ Indicador de precio oficial
                if (_precioMaximoOficial > 0) ...[
                  SizedBox(height: 16.0),
                  _buildIndicadorPrecio(),
                ],

                // Stock solo para productos
                if (_model.tipoValue == 'Producto') ...[
                  SizedBox(height: 16.0),
                  Text(
                    'Stock disponible',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Karla',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _model.stockProductoTextController ??= TextEditingController(),
                    focusNode: _model.stockProductoFocusNode ??= FocusNode(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Karla',
                          letterSpacing: 0.0,
                        ),
                  ),
                ],

                SizedBox(height: 32.0),

                // Botón Guardar
                FFButtonWidget(
                  onPressed: _subiendo ? null : _guardarProducto,
                  text: _subiendo ? 'Guardando...' : 'Guardar ${_model.tipoValue ?? 'Producto/Servicio'}',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}