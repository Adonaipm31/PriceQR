import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'editar_perfil_vendedor_model.dart';

export 'editar_perfil_vendedor_model.dart';

class EditarPerfilVendedorWidget extends StatefulWidget {
  const EditarPerfilVendedorWidget({super.key});

  static String routeName = 'EditarPerfilVendedor';
  static String routePath = '/editarPerfilVendedor';

  @override
  State<EditarPerfilVendedorWidget> createState() =>
      _EditarPerfilVendedorWidgetState();
}

class _EditarPerfilVendedorWidgetState
    extends State<EditarPerfilVendedorWidget> {
  late EditarPerfilVendedorModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditarPerfilVendedorModel());

    _model.yourNameTextController ??= TextEditingController();
    _model.emailAddressTextController ??= TextEditingController();
    _model.passwordTextController1 ??= TextEditingController();
    _model.passwordTextController2 ??= TextEditingController();

    _model.passwordVisibility1 = false;
    _model.passwordVisibility2 = false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final name = _model.yourNameTextController.text.trim();
    final email = _model.emailAddressTextController.text.trim();
    final pass1 = _model.passwordTextController1.text;
    final pass2 = _model.passwordTextController2.text;

    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado correctamente")),
    );

    print("Name: $name");
    print("Email: $email");
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
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'Editar perfil',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.karla(),
                fontSize: 22,
              ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // AVATAR
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Función de foto próximamente")),
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          FlutterFlowTheme.of(context).alternate,
                      child: const Icon(Icons.add_a_photo, size: 40),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // NAME
                  TextFormField(
                    controller: _model.yourNameTextController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        v!.isEmpty ? "Ingresa tu nombre" : null,
                  ),

                  const SizedBox(height: 15),

                  // EMAIL
                  TextFormField(
                    controller: _model.emailAddressTextController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Ingresa email";
                      if (!v.contains("@")) return "Email inválido";
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // PASSWORD
                  TextFormField(
                    controller: _model.passwordTextController1,
                    obscureText: !_model.passwordVisibility1,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_model.passwordVisibility1
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(() =>
                            _model.passwordVisibility1 =
                                !_model.passwordVisibility1),
                      ),
                    ),
                    validator: (v) =>
                        v!.length < 6 ? "Mínimo 6 caracteres" : null,
                  ),

                  const SizedBox(height: 15),

                  // CONFIRM PASSWORD
                  TextFormField(
                    controller: _model.passwordTextController2,
                    obscureText: !_model.passwordVisibility2,
                    decoration: InputDecoration(
                      labelText: "Confirmar contraseña",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_model.passwordVisibility2
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(() =>
                            _model.passwordVisibility2 =
                                !_model.passwordVisibility2),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Confirma contraseña" : null,
                  ),

                  const SizedBox(height: 30),

                  // BUTTON
                  FFButtonWidget(
                    onPressed: _saveChanges,
                    text: "Guardar cambios",
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: const TextStyle(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}