import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'catalogo_publico_model.dart';
export 'catalogo_publico_model.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:math' as math;

class CatalogoPublicoWidget extends StatefulWidget {
  const CatalogoPublicoWidget({
    super.key,
    required this.userIdVendedor,
  });

  static String routeName = 'CatalogoPublico';
  static String routePath = '/catalogoPublico/:userId';

  final String userIdVendedor;

  @override
  State<CatalogoPublicoWidget> createState() => _CatalogoPublicoWidgetState();
}

class _CatalogoPublicoWidgetState extends State<CatalogoPublicoWidget> {
  late CatalogoPublicoModel _model;
  
  List<QueryDocumentSnapshot> productos = [];
  bool cargando = true;
  String nombreVendedor = '';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CatalogoPublicoModel());
    _cargarCatalogoVendedor();
  }

  Future<void> _cargarCatalogoVendedor() async {
    try {
      // 1. Cargar información del vendedor
      final vendedorDoc = await FirebaseFirestore.instance
          .collection('vendedores')
          .doc(widget.userIdVendedor)
          .get();

      if (!vendedorDoc.exists) {
        setState(() {
          cargando = false;
          errorMessage = 'Vendedor no encontrado';
        });
        return;
      }

      // 2. Cargar productos del vendedor
      final productosSnapshot = await FirebaseFirestore.instance
          .collection('catalogo')
          .where('userId', isEqualTo: widget.userIdVendedor)
          .orderBy('fecha_creacion', descending: true)
          .get();

      setState(() {
        nombreVendedor = vendedorDoc.data()?['nombre'] ?? 'Vendedor';
        productos = productosSnapshot.docs;
        cargando = false;
      });
    } catch (e) {
      print('❌ Error cargando catálogo público: $e');
      setState(() {
        cargando = false;
        errorMessage = 'Error cargando catálogo: $e';
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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        title: Text('Catálogo de $nombreVendedor'),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (cargando) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    
    if (productos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_mall_directory, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Este vendedor no tiene productos',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return _buildListaProductos();
  }

  Widget _buildListaProductos() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        final data = producto.data() as Map<String, dynamic>;
        
        return _buildProductoCard(data);
      },
    );
  }

  Widget _buildProductoCard(Map<String, dynamic> data) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // IMAGEN DEL PRODUCTO - MEJORADO
            _buildImagenProducto(data['imagenes_base64']),
            SizedBox(width: 12),
            
            // INFORMACIÓN DEL PRODUCTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nombre'] ?? 'Sin nombre',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Precio: \$${data['precio']?.toString() ?? '0'} ${data['moneda'] ?? 'COP'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Categoría: ${data['categoria'] ?? 'Sin categoría'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Stock: ${data['stock']?.toString() ?? '0'} unidades',
                    style: TextStyle(
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  SizedBox(height: 4),
                  _buildEstadoPrecio(data['precio'], data['precio_maximo_oficial']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 IMAGEN DEL PRODUCTO - DECODIFICACIÓN MEJORADA
  Widget _buildImagenProducto(dynamic imagenesBase64) {
    // Si no hay imágenes o la lista está vacía
    if (imagenesBase64 == null) {
      print('🔍 No hay imágenes (null)');
      return _buildPlaceholderImage(Colors.grey, Icons.image, 'Sin imagen');
    }
    
    if (imagenesBase64 is List && imagenesBase64.isEmpty) {
      print('🔍 Lista de imágenes vacía');
      return _buildPlaceholderImage(Colors.grey, Icons.image, 'Sin imagen');
    }
    
    // Si es una lista con al menos una imagen
    if (imagenesBase64 is List && imagenesBase64.isNotEmpty) {
      final dynamic primeraImagen = imagenesBase64[0];
      
      // Verificar que sea un string
      if (primeraImagen is! String) {
        print('❌ La imagen no es un string: ${primeraImagen.runtimeType}');
        return _buildPlaceholderImage(Colors.orange, Icons.error, 'Formato inválido');
      }
      
      final String primeraImagenBase64 = primeraImagen;
      
      // Verificar que no esté vacío
      if (primeraImagenBase64.isEmpty) {
        print('❌ String base64 vacío');
        return _buildPlaceholderImage(Colors.orange, Icons.error, 'Base64 vacío');
      }
      
      try {
        // Limpiar el string base64 (remover data:image/... si existe)
        String cleanBase64 = primeraImagenBase64;
        if (primeraImagenBase64.contains(',')) {
          cleanBase64 = primeraImagenBase64.split(',').last;
        }
        
        // Verificar que el string base64 sea válido
        if (cleanBase64.isEmpty) {
          print('❌ Base64 limpio está vacío');
          return _buildPlaceholderImage(Colors.orange, Icons.error, 'Base64 inválido');
        }
        
        // Asegurarse de que la longitud sea múltiplo de 4 (requerimiento de base64)
        final int remainder = cleanBase64.length % 4;
        if (remainder != 0) {
          cleanBase64 += '=' * (4 - remainder);
        }
        
        print('🔍 Decodificando imagen base64, longitud: ${cleanBase64.length}');
        
        // Decodificar base64 a bytes
        final Uint8List bytes = base64.decode(cleanBase64);
        
        if (bytes.isEmpty) {
          print('❌ Bytes decodificados están vacíos');
          return _buildPlaceholderImage(Colors.red, Icons.broken_image, 'Bytes vacíos');
        }
        
        print('✅ Imagen decodificada correctamente, bytes: ${bytes.length}');
        
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        print('❌ Error decodificando imagen base64: $e');
        print('🔍 Base64 problemático: ${primeraImagenBase64.substring(0, math.min(100, primeraImagenBase64.length))}...');
        return _buildPlaceholderImage(Colors.red, Icons.broken_image, 'Error: ${e.toString()}');
      }
    }
    
    // Si es un string directamente (no una lista)
    if (imagenesBase64 is String) {
      try {
        String cleanBase64 = imagenesBase64;
        if (imagenesBase64.contains(',')) {
          cleanBase64 = imagenesBase64.split(',').last;
        }
        
        final int remainder = cleanBase64.length % 4;
        if (remainder != 0) {
          cleanBase64 += '=' * (4 - remainder);
        }
        
        final Uint8List bytes = base64.decode(cleanBase64);
        
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        print('❌ Error decodificando imagen base64 (string directo): $e');
        return _buildPlaceholderImage(Colors.red, Icons.broken_image, 'Error decoding');
      }
    }
    
    print('❌ Formato de imagen no reconocido: ${imagenesBase64.runtimeType}');
    return _buildPlaceholderImage(Colors.orange, Icons.error, 'Formato desconocido');
  }

  // 🎯 PLACEHOLDER MEJORADO CON MÁS INFORMACIÓN
  Widget _buildPlaceholderImage(Color color, IconData icon, String debugInfo) {
    Color backgroundColor;
    Color borderColor;
    Color iconColor;
    
    if (color == Colors.grey) {
      backgroundColor = Colors.grey.shade100;
      borderColor = Colors.grey.shade300;
      iconColor = Colors.grey.shade600;
    } else if (color == Colors.orange) {
      backgroundColor = Colors.orange.shade100;
      borderColor = Colors.orange.shade300;
      iconColor = Colors.orange.shade600;
    } else if (color == Colors.red) {
      backgroundColor = Colors.red.shade100;
      borderColor = Colors.red.shade300;
      iconColor = Colors.red.shade600;
    } else {
      backgroundColor = color.withOpacity(0.1);
      borderColor = color;
      iconColor = color;
    }
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          SizedBox(height: 2),
          Text(
            '?',
            style: TextStyle(
              color: iconColor,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoPrecio(dynamic precio, dynamic precioMaximoOficial) {
    final precioNum = double.tryParse(precio?.toString() ?? '0') ?? 0;
    final precioMaxNum = double.tryParse(precioMaximoOficial?.toString() ?? '0') ?? 0;
    final esValido = precioMaxNum == 0 || precioNum <= precioMaxNum;
    
    return Text(
      esValido ? '✅ Precio válido' : '⚠️ Posible sobreprecio',
      style: TextStyle(
        color: esValido ? Colors.green : Colors.orange,
        fontSize: 12,
      ),
    );
  }
}