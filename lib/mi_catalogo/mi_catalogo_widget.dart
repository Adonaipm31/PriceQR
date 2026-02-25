import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'mi_catalogo_model.dart';          
export 'mi_catalogo_model.dart';           

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class MiCatalogoWidget extends StatefulWidget {
  const MiCatalogoWidget({super.key});

  static String routeName = 'MiCatalogo';
  static String routePath = '/miCatalogo';

  @override
  State<MiCatalogoWidget> createState() => _MiCatalogoWidgetState();
}

class _MiCatalogoWidgetState extends State<MiCatalogoWidget> {
  late MiCatalogoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<QueryDocumentSnapshot> productos = [];
  bool cargando = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MiCatalogoModel());
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        cargando = false;
        errorMessage = 'Usuario no autenticado';
      });
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('catalogo')
          .where('userId', isEqualTo: user.uid)
          .orderBy('fecha_creacion', descending: true)
          .get();

      print('✅ Productos encontrados en catalogo: ${querySnapshot.docs.length}');
      
      setState(() {
        productos = querySnapshot.docs;
        cargando = false;
      });
    } catch (e) {
      print('❌ Error cargando productos: $e');
      setState(() {
        cargando = false;
        errorMessage = 'Error cargando productos: $e';
        _cargarProductosSinOrden();
      });
    }
  }

  Future<void> _cargarProductosSinOrden() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('catalogo')
          .where('userId', isEqualTo: user.uid)
          .get();

      final productosOrdenados = querySnapshot.docs.toList()
        ..sort((a, b) {
          final fechaA = a['fecha_creacion'] as Timestamp?;
          final fechaB = b['fecha_creacion'] as Timestamp?;
          return (fechaB?.millisecondsSinceEpoch ?? 0)
              .compareTo(fechaA?.millisecondsSinceEpoch ?? 0);
        });

      setState(() {
        productos = productosOrdenados;
        cargando = false;
      });
    } catch (e) {
      print('❌ Error en carga temporal: $e');
      setState(() {
        cargando = false;
        errorMessage = 'Error cargando productos: $e';
      });
    }
  }

  Future<void> _eliminarProducto(String productId, String productName) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Producto', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('¿Estás seguro de eliminar "$productName"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Eliminar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        await FirebaseFirestore.instance
            .collection('catalogo')
            .doc(productId)
            .delete();
        
        await _cargarProductos();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Producto eliminado correctamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al eliminar producto: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
          'Mi Catálogo de Productos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        elevation: 1,
        actions: [
          // BOTÓN PARA AGREGAR NUEVO PRODUCTO
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: FlutterFlowTheme.of(context).primary),
            onPressed: () {
              context.pushNamed('AnadirProducto');
            },
            tooltip: 'Agregar nuevo producto',
          ),
        ],
      ),
      body: _buildBody(),
      // BOTÓN FLOTANTE PARA VOLVER AL PERFIL
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pop(); // Volver a la pantalla anterior
        },
        backgroundColor: FlutterFlowTheme.of(context).primary,
        child: Icon(Icons.arrow_back, color: Colors.white),
        tooltip: 'Volver al perfil',
      ),
    );
  }

  Widget _buildBody() {
    if (cargando) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando tu catálogo...',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error al cargar productos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, 
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              SizedBox(height: 20),
              // BOTÓN PARA REINTENTAR
              ElevatedButton.icon(
                onPressed: _cargarProductos,
                icon: Icon(Icons.refresh),
                label: Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              // BOTÓN PARA VOLVER
              TextButton(
                onPressed: () => context.pop(),
                child: Text('Volver al perfil'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (productos.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.shade400),
              SizedBox(height: 20),
              Text(
                'Tu catálogo está vacío',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Agrega tu primer producto para comenzar a vender',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              SizedBox(height: 30),
              // BOTÓN PRINCIPAL PARA AGREGAR PRODUCTO
              ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed('AnadirProducto');
                },
                icon: Icon(Icons.add),
                label: Text('Agregar Primer Producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 15),
              // BOTÓN SECUNDARIO PARA VOLVER
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text('Volver al Perfil'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: [
        // HEADER CON ESTADÍSTICAS
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            border: Border(bottom: BorderSide(color: FlutterFlowTheme.of(context).alternate)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total de productos',
                    style: TextStyle(
                      fontSize: 12,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  Text(
                    '${productos.length}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              // BOTÓN PARA AGREGAR MÁS PRODUCTOS
              ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed('AnadirProducto');
                },
                icon: Icon(Icons.add, size: 18),
                label: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildListaProductos()),
      ],
    );
  }

  Widget _buildListaProductos() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        final data = producto.data() as Map<String, dynamic>;
        
        return _buildProductoCard(producto.id, data, index);
      },
    );
  }

  Widget _buildProductoCard(String productId, Map<String, dynamic> data, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // IMAGEN DEL PRODUCTO
            _buildImagenProducto(data['imagenes_base64']),
            SizedBox(width: 12),
            // INFORMACIÓN DEL PRODUCTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['nombre'] ?? 'Sin nombre',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // BOTÓN ELIMINAR
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
                        onPressed: () => _eliminarProducto(productId, data['nombre'] ?? 'Producto'),
                        tooltip: 'Eliminar producto',
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 36),
                      ),
                    ],
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

  Widget _buildImagenProducto(dynamic imagenesBase64) {
    if (imagenesBase64 == null) {
      return _buildPlaceholderImage(Colors.grey, Icons.image);
    }
    
    if (imagenesBase64 is List && imagenesBase64.isEmpty) {
      return _buildPlaceholderImage(Colors.grey, Icons.image);
    }
    
    if (imagenesBase64 is List && imagenesBase64.isNotEmpty) {
      final dynamic primeraImagen = imagenesBase64[0];
      
      if (primeraImagen is! String) {
        return _buildPlaceholderImage(Colors.orange, Icons.error);
      }
      
      final String primeraImagenBase64 = primeraImagen;
      
      if (primeraImagenBase64.isEmpty) {
        return _buildPlaceholderImage(Colors.orange, Icons.error);
      }
      
      try {
        String cleanBase64 = primeraImagenBase64;
        if (primeraImagenBase64.contains(',')) {
          cleanBase64 = primeraImagenBase64.split(',').last;
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
        return _buildPlaceholderImage(Colors.red, Icons.broken_image);
      }
    }
    
    return _buildPlaceholderImage(Colors.grey, Icons.image);
  }

  Widget _buildPlaceholderImage(Color color, IconData icon) {
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
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildEstadoPrecio(dynamic precio, dynamic precioMaximoOficial) {
    final precioNum = double.tryParse(precio?.toString() ?? '0') ?? 0;
    final precioMaxNum = double.tryParse(precioMaximoOficial?.toString() ?? '0') ?? 0;
    
    final esValido = precioMaxNum == 0 || precioNum <= precioMaxNum;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: esValido ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: esValido ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            esValido ? Icons.check_circle : Icons.warning,
            size: 12,
            color: esValido ? Colors.green : Colors.orange,
          ),
          SizedBox(width: 4),
          Text(
            esValido ? 'Precio válido' : 'Posible sobreprecio',
            style: TextStyle(
              color: esValido ? Colors.green : Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}