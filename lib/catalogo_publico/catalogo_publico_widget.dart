import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'catalogo_publico_model.dart';
export 'catalogo_publico_model.dart';
 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
 
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
  String nombreNegocio = '';
  String? errorMessage;
 
  // Precios oficiales por categoría: { "Servicios de Playa": { precio_maximo, precio_minimo, tolerancia } }
  Map<String, Map<String, dynamic>> preciosOficiales = {};
 
  // PRESUPUESTO Y SELECCIÓN
  int presupuestoUsuario = 0;
  int totalSeleccionado = 0;
  List<Map<String, dynamic>> productosSeleccionados = [];
 
  // Estado del botón adquirir
  bool guardando = false;
 
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CatalogoPublicoModel());
    _cargarDatos();
  }
 
  Future<void> _cargarDatos() async {
    await Future.wait([
      _cargarCatalogoVendedor(),
      _cargarPreciosOficiales(),
    ]);
  }
 
  // Carga precios_oficiales indexados por categoría
  Future<void> _cargarPreciosOficiales() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('precios_oficiales')
          .get();
 
      final mapa = <String, Map<String, dynamic>>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final categoria = data['categoria'] as String? ?? '';
        if (categoria.isNotEmpty) {
          mapa[categoria] = data;
        }
      }
 
      setState(() {
        preciosOficiales = mapa;
      });
    } catch (_) {
      // Si falla, simplemente no hay validación de precios oficiales
    }
  }
 
  Future<void> _cargarCatalogoVendedor() async {
    try {
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
 
      // OPCIÓN 2: Solo filtra por userId + orderBy, el filtro 'activo'
      // se aplica en memoria para evitar requerir índice compuesto en Firestore
      final productosSnapshot = await FirebaseFirestore.instance
          .collection('catalogo')
          .where('userId', isEqualTo: widget.userIdVendedor)
          .orderBy('fecha_creacion', descending: true)
          .get();
 
      // Filtrar productos activos en memoria
      final productosFiltrados = productosSnapshot.docs.where((doc) {
        final data = doc.data();
        return data['activo'] == true;
      }).toList();
 
      setState(() {
        // vendedores: 'nombre' = nombre persona, 'nombre_negocio' = nombre del negocio
        nombreVendedor = vendedorDoc.data()?['nombre'] ?? 'Vendedor';
        nombreNegocio =
            vendedorDoc.data()?['nombre_negocio'] ?? nombreVendedor;
        productos = productosFiltrados;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
        errorMessage = 'Error cargando catálogo: $e';
      });
    }
  }
 
  // GUARDAR VENTA EN FIRESTORE
  Future<void> _adquirirProductos() async {
    if (productosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona al menos un producto')),
      );
      return;
    }
 
    setState(() => guardando = true);
 
    try {
      // Obtener usuario logueado desde Firebase Auth
      final userAuth = FirebaseAuth.instance.currentUser;
      if (userAuth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay sesión activa')),
        );
        setState(() => guardando = false);
        return;
      }
 
      // Obtener datos del usuario desde la colección 'users'
      // Campos reales: nombre, rol, correo, estado_cuenta, fecha_creacion
      final usuarioDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth.uid)
          .get();
 
      final usuarioNombre =
          usuarioDoc.data()?['nombre'] ?? userAuth.displayName ?? 'Usuario';
 
      // Campo 'rol' en tu colección users (ej: 'turista')
      final tipoUsuario = usuarioDoc.data()?['rol'] ?? 'turista';
 
      // Calcular ahorro estimado (presupuesto - total gastado)
      final ahorroEstimado = presupuestoUsuario - totalSeleccionado;
 
      // Construir array de productos con la estructura de la colección ventas
      // ventas.productos[]: cantidad, nombre, precio (categoria), productoId
      final productosParaGuardar = productosSeleccionados.map((p) {
        return {
          'cantidad': 1,
          'nombre': p['nombre'] ?? '',
          'precio': p['categoria'] ?? '',
          'productoId': p['productoId'] ?? '',
        };
      }).toList();
 
      // Fecha en texto formato YYYY-MM-DD
      final ahora = DateTime.now();
      final fechaTexto =
          '${ahora.year}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')}';
 
      // Documento a guardar — campos exactos de tu colección ventas
      final venta = {
        'ahorroEstimado': ahorroEstimado,
        'fecha': Timestamp.now(),
        'fechaTexto': fechaTexto,
        'nombreNegocio': nombreNegocio,
        'origen': 'qr',
        'presupuestoUsuario': presupuestoUsuario,
        'productos': productosParaGuardar,
        'recomendacionIA': '',
        'tipoUsuario': tipoUsuario,
        'total': totalSeleccionado,
        'usoIA': false,
        'usuarioId': userAuth.uid,
        'usuarioNombre': usuarioNombre,
        'vendedorId': widget.userIdVendedor,
      };
 
      await FirebaseFirestore.instance.collection('ventas').add(venta);
 
      // Guardar valores antes de limpiar para mostrar en el dialog
      final totalGuardado = totalSeleccionado;
      final ahorroGuardado = ahorroEstimado;
 
      // Limpiar selección tras guardar
      setState(() {
        productosSeleccionados = [];
        totalSeleccionado = 0;
        guardando = false;
      });
 
      // Mostrar confirmación
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('¡Compra registrada!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Tu compra en $nombreNegocio fue registrada exitosamente.'),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total gastado:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$$totalGuardado',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ahorro:'),
                  Text(
                    '\$$ahorroGuardado',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar compra: $e')),
      );
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
        title: Text('Catálogo - $nombreNegocio'),
        automaticallyImplyLeading: true,
      ),
      // BOTÓN FLOTANTE — solo visible cuando hay productos seleccionados
      floatingActionButton: productosSeleccionados.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: guardando ? null : _adquirirProductos,
              backgroundColor: Colors.green,
              icon: guardando
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.shopping_cart_checkout, color: Colors.white),
              label: Text(
                guardando
                    ? 'Guardando...'
                    : 'Adquirir (${productosSeleccionados.length}) — \$$totalSeleccionado',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _buildBody(),
    );
  }
 
  Widget _buildBody() {
    if (cargando) {
      return Center(child: CircularProgressIndicator());
    }
 
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
 
    if (productos.isEmpty) {
      return Center(child: Text('No hay productos en este catálogo'));
    }
 
    return Column(
      children: [
        _buildPresupuestoInput(),
        _buildResumen(),
        Expanded(child: _buildListaProductos()),
      ],
    );
  }
 
  // INPUT PRESUPUESTO
  Widget _buildPresupuestoInput() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Ingresa tu presupuesto",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.attach_money),
        ),
        onChanged: (value) {
          setState(() {
            presupuestoUsuario = int.tryParse(value) ?? 0;
          });
        },
      ),
    );
  }
 
  // RESUMEN
  Widget _buildResumen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Presupuesto: \$${presupuestoUsuario}"),
          Text("Total seleccionado: \$${totalSeleccionado}"),
          Text(
            "Disponible: \$${presupuestoUsuario - totalSeleccionado}",
            style: TextStyle(
              color: (presupuestoUsuario - totalSeleccionado) >= 0
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
 
  Widget _buildListaProductos() {
    return ListView.builder(
      // padding bottom 100 para que el FAB no tape el último producto
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final data = productos[index].data() as Map<String, dynamic>;
        final docId = productos[index].id;
        return _buildProductoCard(data, docId);
      },
    );
  }
 
  Widget _buildProductoCard(Map<String, dynamic> data, String docId) {
    final precio = (data['precio'] ?? 0) as int;
 
    bool seleccionado = productosSeleccionados.any(
      (p) => p['nombre'] == data['nombre'],
    );
 
    // Solo marcar fuera de presupuesto si el producto NO está seleccionado
    bool superaPresupuesto = !seleccionado &&
        presupuestoUsuario > 0 &&
        (totalSeleccionado + precio) > presupuestoUsuario;
 
    return InkWell(
      onTap: superaPresupuesto
          ? null
          : () {
              setState(() {
                if (seleccionado) {
                  productosSeleccionados.removeWhere(
                      (p) => p['nombre'] == data['nombre']);
                  totalSeleccionado -= precio;
                } else {
                  productosSeleccionados.add({
                    'nombre': data['nombre'],
                    'precio': precio,
                    'categoria': data['categoria'] ?? '',
                    'productoId': docId,
                  });
                  totalSeleccionado += precio;
                }
              });
            },
      child: Card(
        color: seleccionado ? Colors.green.shade50 : null,
        margin: EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              _buildImagenProducto(data['imagenes_base64']),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['nombre'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Precio: \$${precio}"),
                    Text("Categoría: ${data['categoria'] ?? '-'}"),
                    if ((data['descripcion'] ?? '').toString().isNotEmpty)
                      Text(
                        data['descripcion'],
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 4),
                    if (seleccionado)
                      Text(
                        "✅ Seleccionado",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (superaPresupuesto)
                      Text(
                        "❌ Fuera de presupuesto",
                        style: TextStyle(color: Colors.red),
                      ),
                    // Validación contra precios_oficiales por categoría
                    _buildEstadoPrecio(precio, data['categoria']),
                  ],
                ),
              ),
              if (seleccionado)
                Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildImagenProducto(dynamic imagenesBase64) {
    try {
      if (imagenesBase64 is List && imagenesBase64.isNotEmpty) {
        String base64Img = imagenesBase64[0];
        if (base64Img.contains(',')) {
          base64Img = base64Img.split(',').last;
        }
 
        final remainder = base64Img.length % 4;
        if (remainder != 0) {
          base64Img += '=' * (4 - remainder);
        }
 
        final bytes = base64.decode(base64Img);
 
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
      }
    } catch (_) {}
 
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      child: Icon(Icons.image),
    );
  }
 
  // Valida el precio del producto contra precios_oficiales usando:
  // precio_maximo * (1 + tolerancia) como límite real
  Widget _buildEstadoPrecio(int precio, String? categoria) {
    if (categoria == null || categoria.isEmpty) {
      return SizedBox.shrink();
    }
 
    // Buscar precio oficial por categoría exacta, si no existe buscar 'default'
    final precioOficial =
        preciosOficiales[categoria] ?? preciosOficiales['default'];
 
    if (precioOficial == null) {
      return SizedBox.shrink();
    }
 
    final precioMaximo =
        (precioOficial['precio_maximo'] as num?)?.toDouble() ?? 0;
    final tolerancia =
        (precioOficial['tolerancia'] as num?)?.toDouble() ?? 0;
 
    // Límite real = precio_maximo * (1 + tolerancia)
    final limiteReal = precioMaximo * (1 + tolerancia);
 
    final esValido = limiteReal == 0 || precio <= limiteReal;
 
    return Text(
      esValido ? '✅ Precio válido' : '⚠️ Posible sobreprecio',
      style: TextStyle(
        color: esValido ? Colors.green : Colors.orange,
        fontSize: 12,
      ),
    );
  }
}
 
 