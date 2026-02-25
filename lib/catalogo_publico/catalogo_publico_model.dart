import '/flutter_flow/flutter_flow_util.dart';
import 'catalogo_publico_widget.dart' show CatalogoPublicoWidget;
import 'package:flutter/material.dart';

class CatalogoPublicoModel extends FlutterFlowModel<CatalogoPublicoWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}