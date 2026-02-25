import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'registro_vendedor_widget.dart' show RegistroVendedorWidget;
import 'package:flutter/material.dart';

class RegistroVendedorModel extends FlutterFlowModel<RegistroVendedorWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for NombreCompleto widget.
  FocusNode? nombreCompletoFocusNode;
  TextEditingController? nombreCompletoTextController;
  String? Function(BuildContext, String?)?
      nombreCompletoTextControllerValidator;
  // State field(s) for NombreDelNegocio widget.
  FocusNode? nombreDelNegocioFocusNode;
  TextEditingController? nombreDelNegocioTextController;
  String? Function(BuildContext, String?)?
      nombreDelNegocioTextControllerValidator;
  // State field(s) for Telefono widget.
  FocusNode? telefonoFocusNode;
  TextEditingController? telefonoTextController;
  String? Function(BuildContext, String?)? telefonoTextControllerValidator;
  // State field(s) for FullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmTextController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)?
      passwordConfirmTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    passwordConfirmVisibility = false;
  }

  @override
  void dispose() {
    nombreCompletoFocusNode?.dispose();
    nombreCompletoTextController?.dispose();

    nombreDelNegocioFocusNode?.dispose();
    nombreDelNegocioTextController?.dispose();

    telefonoFocusNode?.dispose();
    telefonoTextController?.dispose();

    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmTextController?.dispose();
  }
}
