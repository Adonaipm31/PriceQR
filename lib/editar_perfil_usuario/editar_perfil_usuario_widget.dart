import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _EditarPerfilUsuarioWidgetState
    extends State<EditarPerfilUsuarioWidget> {
  late EditarPerfilUsuarioModel _model;

  File? _profileImage;
  bool _isUploading = false;
  String? _photoUrl;

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

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();

        setState(() {
          _photoUrl = data?['photoUrl'];

          _model.yourNameTextController?.text =
              data?['name'] ?? '';

          _model.emailAddressTextController?.text =
              data?['email'] ?? '';
        });
      }
    } catch (e) {
      print("Error cargando usuario: $e");
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _changeProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();

      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'Galería',
                      style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Seleccionar desde fotos',
                    ),
                    onTap: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  ),

                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.orange,
                      ),
                    ),
                    title: Text(
                      'Cámara',
                      style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Tomar una foto',
                    ),
                    onTap: () =>
                        Navigator.pop(context, ImageSource.camera),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (source == null) return;

      PermissionStatus permission;

      if (source == ImageSource.camera) {
        permission = await Permission.camera.request();
      } else {
        permission = await Permission.storage.request();
      }

      if (!permission.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Permiso denegado"),
          ),
        );
        return;
      }

      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1080,
      );

      if (pickedFile == null) return;

      setState(() {
        _profileImage = File(pickedFile.path);
        _isUploading = true;
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_profileImage!);

      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'photoUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        _photoUrl = downloadUrl;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Foto actualizada correctamente",
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name':
            _model.yourNameTextController.text,
        'email':
            _model.emailAddressTextController.text,
        'photoUrl': _photoUrl,
        'updatedAt':
            FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Perfil actualizado correctamente",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FA),

      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF111827),
                  Color(0xFF1F2937),
                  Color(0xFFF5F7FA),
                  Color(0xFFF5F7FA),
                ],
                stops: [0, .30, .30, 1],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.12),
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 16,
                            borderWidth: 0,
                            buttonSize: 48,
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () async {
                              context.safePop();
                            },
                          ),
                        ),

                        const Spacer(),

                        Text(
                          "Edit Profile",
                          style: GoogleFonts.karla(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
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
                                  radius: 58,
                                  backgroundColor:
                                      Colors.grey.shade200,
                                  backgroundImage:
                                      _profileImage != null
                                          ? FileImage(
                                              _profileImage!)
                                          : (_photoUrl != null
                                                  ? NetworkImage(
                                                      _photoUrl!)
                                                  : null)
                                              as ImageProvider?,
                                  child: (_profileImage ==
                                              null &&
                                          _photoUrl ==
                                              null)
                                      ? const Icon(
                                          Icons.person,
                                          size: 55,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              ),

                              InkWell(
                                onTap: _isUploading
                                    ? null
                                    : _changeProfilePhoto,
                                borderRadius:
                                    BorderRadius.circular(30),
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient:
                                        const LinearGradient(
                                      colors: [
                                        Color(0xFF4F46E5),
                                        Color(0xFF6366F1),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: _isUploading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color:
                                                Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.camera_alt,
                                          color:
                                              Colors.white,
                                          size: 20,
                                        ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 35),

                          _modernInputField(
                            controller:
                                _model
                                    .yourNameTextController!,
                            label: "Full Name",
                            icon:
                                Icons.person_outline,
                          ),

                          const SizedBox(height: 20),

                          _modernInputField(
                            controller:
                                _model
                                    .emailAddressTextController!,
                            label: "Email Address",
                            icon:
                                Icons.email_outlined,
                          ),

                          const SizedBox(height: 35),

                          Container(
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(0xFF4F46E5),
                                  Color(0xFF6366F1),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                            child: FFButtonWidget(
                              onPressed: _saveProfile,
                              text: 'Save Changes',
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              options:
                                  FFButtonOptions(
                                width: double.infinity,
                                height: 58,
                                color:
                                    Colors.transparent,
                                elevation: 0,
                                borderRadius:
                                    BorderRadius
                                        .circular(18),
                                textStyle:
                                    GoogleFonts.karla(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(.12),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.karla(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 20,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade700,
          ),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}