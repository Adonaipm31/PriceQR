import '/components/nav_bar_invitado_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_invitado_widget.dart' show HomeInvitadoWidget;
import 'package:flutter/material.dart';

class HomeInvitadoModel extends FlutterFlowModel<HomeInvitadoWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for navBarInvitado component.
  late NavBarInvitadoModel navBarInvitadoModel;

  @override
  void initState(BuildContext context) {
    navBarInvitadoModel = createModel(context, () => NavBarInvitadoModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    tabBarController?.dispose();
    navBarInvitadoModel.dispose();
  }
}
