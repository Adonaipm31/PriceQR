import '/components/nav_bar_invitado_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_user_invitado_widget.dart' show ProfileUserInvitadoWidget;
import 'package:flutter/material.dart';

class ProfileUserInvitadoModel
    extends FlutterFlowModel<ProfileUserInvitadoWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for navBarInvitado component.
  late NavBarInvitadoModel navBarInvitadoModel;

  @override
  void initState(BuildContext context) {
    navBarInvitadoModel = createModel(context, () => NavBarInvitadoModel());
  }

  @override
  void dispose() {
    navBarInvitadoModel.dispose();
  }
}
