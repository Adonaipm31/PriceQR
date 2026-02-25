// 📄 mi_catalogo_model.dart
import '/flutter_flow/flutter_flow_util.dart';
import 'mi_catalogo_widget.dart' show MiCatalogoWidget;
import 'package:flutter/material.dart';
import '/index.dart';

class MiCatalogoModel extends FlutterFlowModel<MiCatalogoWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}