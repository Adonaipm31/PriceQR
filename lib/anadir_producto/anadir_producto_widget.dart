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

import 'dart:convert';

class AnadirProductoWidget extends StatefulWidget {
  const AnadirProductoWidget({super.key});

  static String routeName = 'AnadirProducto';
  static String routePath = '/anadirProducto';

  @override
  State<AnadirProductoWidget> createState() =>
      _AnadirProductoWidgetState();
}

class _AnadirProductoWidgetState
    extends State<AnadirProductoWidget> {
  late AnadirProductoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _subiendo = false;

  List<String> _imagenesBase64 = [];

  bool _procesandoImagenes = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _model = createModel(
      context,
      () => AnadirProductoModel(),
    );

    _model.tipoValueController ??=
        FormFieldController<String>(null);

    _model.categoriaProductoValueController ??=
        FormFieldController<String>(null);

    _model.nombreProductoTextController ??=
        TextEditingController();

    _model.descripcionProductoTextController ??=
        TextEditingController();

    _model.precioProductoTextController ??=
        TextEditingController();

    _model.stockProductoTextController ??=
        TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _seleccionarDeGaleria() async {
    try {
      final XFile? imagen =
          await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 40,
      );

      if (imagen != null) {
        setState(() {
          _procesandoImagenes = true;
        });

        final bytes = await imagen.readAsBytes();

        final base64String =
            'data:image/jpeg;base64,${base64Encode(bytes)}';

        setState(() {
          _imagenesBase64.add(base64String);

          _procesandoImagenes = false;
        });

        print('✅ Imagen agregada');
      }
    } catch (e) {
      setState(() {
        _procesandoImagenes = false;
      });

      print('❌ Error seleccionando imagen: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error seleccionando imagen'),
          backgroundColor:
              FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<void> _tomarFoto() async {
    try {
      final XFile? foto =
          await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 40,
      );

      if (foto != null) {
        setState(() {
          _procesandoImagenes = true;
        });

        final bytes = await foto.readAsBytes();

        final base64String =
            'data:image/jpeg;base64,${base64Encode(bytes)}';

        setState(() {
          _imagenesBase64.add(base64String);

          _procesandoImagenes = false;
        });

        print('✅ Foto agregada');
      }
    } catch (e) {
      setState(() {
        _procesandoImagenes = false;
      });

      print('❌ Error tomando foto: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error tomando foto'),
          backgroundColor:
              FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  void _eliminarImagen(int index) {
    setState(() {
      _imagenesBase64.removeAt(index);
    });
  }

  Future<void> _guardarProducto() async {
    if (_model.nombreProductoTextController.text
            .trim()
            .isEmpty ||
        _model.descripcionProductoTextController
            .text
            .trim()
            .isEmpty ||
        _model.precioProductoTextController.text
            .trim()
            .isEmpty ||
        _model.tipoValue == null ||
        _model.categoriaProductoValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Completa todos los campos'),
          backgroundColor:
              FlutterFlowTheme.of(context).error,
        ),
      );

      return;
    }

    setState(() {
      _subiendo = true;
    });

    try {
      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception(
            'Usuario no autenticado');
      }

      final nuevoProducto = {
        'nombre': _model
            .nombreProductoTextController.text
            .trim(),
        'descripcion': _model
            .descripcionProductoTextController
            .text
            .trim(),
        'precio': double.tryParse(
                _model
                    .precioProductoTextController
                    .text) ??
            0,
        'tipo': _model.tipoValue,
        'categoria':
            _model.categoriaProductoValue,
        'stock': int.tryParse(
                _model
                        .stockProductoTextController
                        ?.text ??
                    '0') ??
            0,
        'imagenes_base64':
            _imagenesBase64,
        'cantidad_imagenes':
            _imagenesBase64.length,
        'userId': user.uid,
        'userEmail': user.email,
        'fecha_creacion':
            FieldValue.serverTimestamp(),
        'activo': true,
        'moneda': 'COP',
      };

      await FirebaseFirestore.instance
          .collection('catalogo')
          .add(nuevoProducto);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text('✅ Producto guardado'),
          backgroundColor:
              FlutterFlowTheme.of(context)
                  .success,
        ),
      );

      context.pop();
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text('Error guardando producto'),
          backgroundColor:
              FlutterFlowTheme.of(context)
                  .error,
        ),
      );
    }

    setState(() {
      _subiendo = false;
    });
  }

  Widget _tituloCampo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboard =
        TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                FlutterFlowTheme.of(context)
                    .primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        title: Text(
          'Añadir Producto',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        actions: [
          Padding(
            padding:
                const EdgeInsets.only(
                    right: 12),
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),

          child: Container(
            width: double.infinity,

            padding:
                const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                      24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.05),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets
                              .all(12),

                      decoration:
                          BoxDecoration(
                        color: FlutterFlowTheme.of(
                                context)
                            .primary
                            .withOpacity(
                                0.12),

                        borderRadius:
                            BorderRadius
                                .circular(
                                    16),
                      ),

                      child: Icon(
                        Icons
                            .inventory_2_rounded,
                        size: 30,
                        color:
                            FlutterFlowTheme.of(
                                    context)
                                .primary,
                      ),
                    ),

                    const SizedBox(
                        width: 14),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'Nuevo producto',
                          style:
                              TextStyle(
                            fontSize:
                                20,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        SizedBox(
                            height: 4),

                        Text(
                          'Agrega información de tu producto',
                          style:
                              TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                _tituloCampo(
                    'Imágenes'),

                if (_imagenesBase64
                    .isNotEmpty)
                  SizedBox(
                    height: 160,

                    child:
                        ListView.builder(
                      scrollDirection:
                          Axis.horizontal,

                      itemCount:
                          _imagenesBase64
                              .length,

                      itemBuilder:
                          (context,
                              index) {
                        final imagenBase64 =
                            _imagenesBase64[
                                index];

                        String cleanBase64 =
                            imagenBase64
                                    .contains(
                                        ',')
                                ? imagenBase64
                                    .split(
                                        ',')
                                    .last
                                : imagenBase64;

                        return Padding(
                          padding:
                              const EdgeInsets
                                      .only(
                                  right:
                                      14),

                          child: Stack(
                            children: [
                              Container(
                                width: 160,

                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                          22),

                                  image:
                                      DecorationImage(
                                    image:
                                        MemoryImage(
                                      base64Decode(
                                          cleanBase64),
                                    ),

                                    fit: BoxFit
                                        .cover,
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 10,
                                right: 10,

                                child:
                                    GestureDetector(
                                  onTap: () =>
                                      _eliminarImagen(
                                          index),

                                  child:
                                      Container(
                                    padding:
                                        const EdgeInsets
                                                .all(
                                            6),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors
                                              .red,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    child:
                                        Icon(
                                      Icons
                                          .close,
                                      color:
                                          Colors
                                              .white,
                                      size:
                                          18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child:
                          FFButtonWidget(
                        onPressed:
                            _imagenesBase64
                                        .length >=
                                    2
                                ? null
                                : _seleccionarDeGaleria,

                        text: 'Galería',

                        icon: Icon(Icons
                            .photo_library_rounded),

                        options:
                            FFButtonOptions(
                          height: 54,

                          color:
                              Colors.white,

                          textStyle:
                              TextStyle(
                            color: Colors
                                .black87,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),

                          borderSide:
                              BorderSide(
                            color: Colors
                                .grey
                                .shade300,
                            width: 1.5,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      16),
                        ),
                      ),
                    ),

                    const SizedBox(
                        width: 14),

                    Expanded(
                      child:
                          FFButtonWidget(
                        onPressed:
                            _imagenesBase64
                                        .length >=
                                    2
                                ? null
                                : _tomarFoto,

                        text: 'Cámara',

                        icon: Icon(Icons
                            .camera_alt_rounded),

                        options:
                            FFButtonOptions(
                          height: 54,

                          color:
                              FlutterFlowTheme.of(
                                      context)
                                  .primary,

                          textStyle:
                              TextStyle(
                            color: Colors
                                .white,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      16),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_procesandoImagenes)
                  Padding(
                    padding:
                        const EdgeInsets
                            .only(top: 18),

                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      20),
                        ),

                        SizedBox(
                            height: 10),

                        Text(
                          'Procesando imagen...',
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 28),

                _tituloCampo('Nombre'),

                _input(
                  
                controller: _model
                      .nombreProductoTextController!,

                  hint:
                      'Nombre del producto',
                ),

                const SizedBox(height: 20),

                _tituloCampo(
                    'Descripción'),

                _input(
                  controller: _model
                      .descripcionProductoTextController!,
                  hint:
                      'Describe tu producto...',
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                _tituloCampo('Precio'),

                _input(
                  controller: _model
                      .precioProductoTextController!,
                  hint: '0',
                  keyboard:
                      TextInputType.number,
                ),

                const SizedBox(height: 20),

                _tituloCampo('Tipo'),

                FlutterFlowDropDown<String>(
                  controller: _model
                          .tipoValueController ??=
                      FormFieldController<
                          String>(
                    null,
                  ),

                  options: const [
                    'Producto',
                    'Servicio'
                  ],

                  onChanged: (val) {
                    setState(() {
                      _model.tipoValue =
                          val;
                    });
                  },

                  width: double.infinity,

                  height: 56,

                  textStyle:
                      FlutterFlowTheme.of(
                              context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                'Karla',
                            letterSpacing:
                                0.0,
                          ),

                  hintText:
                      'Selecciona tipo',

                  icon: Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                  ),

                  fillColor: Colors.white,

                  elevation: 0,

                  borderColor:
                      Colors.grey.shade300,

                  borderWidth: 1.5,

                  borderRadius: 16,

                  margin:
                      EdgeInsetsDirectional
                          .fromSTEB(
                              16,
                              4,
                              16,
                              4),

                  hidesUnderline:
                      true,

                  isSearchable:
                      false,

                  isMultiSelect:
                      false,
                ),

                const SizedBox(height: 20),

                _tituloCampo(
                    'Categoría'),

                FlutterFlowDropDown<String>(
                  controller: _model
                          .categoriaProductoValueController ??=
                      FormFieldController<
                          String>(
                    null,
                  ),

                  options: const [
                    'Comida',
                    'Bebidas',
                    'Servicios',
                    'Artesanías',
                    'Otros'
                  ],

                  onChanged: (val) {
                    setState(() {
                      _model
                              .categoriaProductoValue =
                          val;
                    });
                  },

                  width: double.infinity,

                  height: 56,

                  textStyle:
                      FlutterFlowTheme.of(
                              context)
                          .bodyMedium
                          .override(
                            fontFamily:
                                'Karla',
                            letterSpacing:
                                0.0,
                          ),

                  hintText:
                      'Selecciona categoría',

                  icon: Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                  ),

                  fillColor: Colors.white,

                  elevation: 0,

                  borderColor:
                      Colors.grey.shade300,

                  borderWidth: 1.5,

                  borderRadius: 16,

                  margin:
                      EdgeInsetsDirectional
                          .fromSTEB(
                              16,
                              4,
                              16,
                              4),

                  hidesUnderline:
                      true,

                  isSearchable:
                      false,

                  isMultiSelect:
                      false,
                ),

                const SizedBox(height: 20),

                _tituloCampo('Stock'),

                _input(
                  controller: _model
                      .stockProductoTextController!,
                  hint: '0',
                  keyboard:
                      TextInputType.number,
                ),

                const SizedBox(height: 34),

                FFButtonWidget(
                  onPressed:
                      _subiendo
                          ? null
                          : _guardarProducto,

                  text: _subiendo
                      ? 'Guardando...'
                      : 'Guardar Producto',

                  icon: Icon(
                    Icons.check_rounded,
                    size: 22,
                  ),

                  options:
                      FFButtonOptions(
                    width:
                        double.infinity,

                    height: 58,

                    color:
                        FlutterFlowTheme.of(
                                context)
                            .primary,

                    textStyle:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),

                    elevation: 0,

                    borderRadius:
                        BorderRadius
                            .circular(
                                18),
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