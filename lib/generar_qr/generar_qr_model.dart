import '/flutter_flow/flutter_flow_util.dart';
import 'generar_qr_widget.dart' show GenerarQrWidget;
import 'package:flutter/material.dart';
import '/index.dart';

class GenerarQrModel extends FlutterFlowModel<GenerarQrWidget> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}