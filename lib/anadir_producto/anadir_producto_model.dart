import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'anadir_producto_widget.dart' show AnadirProductoWidget;
import 'package:flutter/material.dart';

class AnadirProductoModel extends FlutterFlowModel<AnadirProductoWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  
  // State field(s) for tipo widget.
  String? tipoValue;
  FormFieldController<String>? tipoValueController;
  
  // State field(s) for nombreProducto widget.
  FocusNode? nombreProductoFocusNode;
  TextEditingController? nombreProductoTextController;
  String? Function(BuildContext, String?)? nombreProductoTextControllerValidator;
  
  // State field(s) for descripcionProducto widget.
  FocusNode? descripcionProductoFocusNode;
  TextEditingController? descripcionProductoTextController;
  String? Function(BuildContext, String?)? descripcionProductoTextControllerValidator;
  
  // State field(s) for precioProducto widget.
  FocusNode? precioProductoFocusNode;
  TextEditingController? precioProductoTextController;
  String? Function(BuildContext, String?)? precioProductoTextControllerValidator;
  
  // State field(s) for categoriaProducto widget.
  String? categoriaProductoValue;
  FormFieldController<String>? categoriaProductoValueController;
  
  // State field(s) for stockProducto widget.
  FocusNode? stockProductoFocusNode;
  TextEditingController? stockProductoTextController;
  String? Function(BuildContext, String?)? stockProductoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    nombreProductoFocusNode?.dispose();
    nombreProductoTextController?.dispose();

    descripcionProductoFocusNode?.dispose();
    descripcionProductoTextController?.dispose();

    precioProductoFocusNode?.dispose();
    precioProductoTextController?.dispose();

    stockProductoFocusNode?.dispose();
    stockProductoTextController?.dispose();
  }
}