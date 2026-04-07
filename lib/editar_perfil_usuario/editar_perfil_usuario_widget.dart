import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'editar_perfil_usuario_model.dart';
export 'editar_perfil_usuario_model.dart';

class EditarPerfilUsuarioWidget extends StatefulWidget {
  const EditarPerfilUsuarioWidget({super.key});

  static String routeName = 'EditarPerfilUsuario';
  static String routePath = '/editarPerfilUsuario';

  @override
  State<EditarPerfilUsuarioWidget> createState() =>
      _EditarPerfilUsuarioWidgetState();
}

class _EditarPerfilUsuarioWidgetState extends State<EditarPerfilUsuarioWidget> {
  late EditarPerfilUsuarioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditarPerfilUsuarioModel());

    _model.yourNameTextController ??= TextEditingController();
    _model.yourNameFocusNode ??= FocusNode();

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController1 ??= TextEditingController();
    _model.passwordFocusNode1 ??= FocusNode();

    _model.passwordTextController2 ??= TextEditingController();
    _model.passwordFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextFormField(
        controller: controller,
        obscureText: !visible,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: InkWell(
            onTap: onTap,
            child: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 0,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 50,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30,
          ),
          onPressed: () async {
            context.safePop();
          },
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.karla(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E1E2D),
                      Color(0xFF2D2D44),
                      Color(0xFF3A3A55),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -60),
                child: Column(
                  children: [

                    /// FOTO PERFIL
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber,
                                Colors.orange,
                              ],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor:
                                FlutterFlowTheme.of(context).alternate,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    _inputField(
                      controller: _model.yourNameTextController!,
                      label: "Your Name",
                      icon: Icons.person,
                    ),

                    _inputField(
                      controller: _model.emailAddressTextController!,
                      label: "Email",
                      icon: Icons.email,
                    ),

                    _passwordField(
                      controller: _model.passwordTextController1!,
                      label: "Password",
                      visible: _model.passwordVisibility1,
                      onTap: () => safeSetState(
                        () => _model.passwordVisibility1 =
                            !_model.passwordVisibility1,
                      ),
                    ),

                    _passwordField(
                      controller: _model.passwordTextController2!,
                      label: "Confirm Password",
                      visible: _model.passwordVisibility2,
                      onTap: () => safeSetState(
                        () => _model.passwordVisibility2 =
                            !_model.passwordVisibility2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// BOTON GUARDAR
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4E5AE8),
                            Color(0xFF6A7BFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: FFButtonWidget(
                        onPressed: () {
                          print("Save pressed");
                        },
                        text: 'Save Changes',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 55,
                          color: Colors.transparent,
                          elevation: 0,
                          borderRadius: BorderRadius.circular(14),
                          textStyle: GoogleFonts.karla(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}