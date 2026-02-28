import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/b_control/util/metodos.dart';
import 'package:appdac/c_integracion/intlogin.dart';
import 'package:appdac/config/app_config.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ControlSesion controlsesion = context.watch<ControlSesion>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icono de balón de fútbol
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/img/logo.jpg',
                  width: 100, // Ajusta el tamaño según necesites
                  height: 100,
                  fit: BoxFit.contain, // Ajusta cómo se adapta la imagen
                ),
              ),

              // Texto "Bienvenido" en negrilla
              Text(
                S.of(context).label_bienvenido,
                style: AppColors.textotituloverde,
              ),

              const SizedBox(height: 8),

              const SizedBox(height: 40),

              // Campo de texto para nombre de usuario
              TextField(
                controller: _usernameController,
                decoration: DecoracionCampoVerde(
                  letrero: S.of(context).label_usuario,
                  hintLetrero: S.of(context).label_usuario,
                ),
              ),

              const SizedBox(height: 20),

              // Campo de texto para contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: DecoracionCampoVerde(
                  letrero: S.of(context).label_clave,
                  hintLetrero: S.of(context).label_clave,
                ),
              ),

              const SizedBox(height: 30),

              // Botón para Iniciar Sesión
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //controlsesion.login(context, 'ag.giraldo', '12345');//EST00001
                    //controlsesion.login(context, 's.martinez', '12345');//EST00003
                    //controlsesion.login(context, 'm.cifuentes', '12345');//EST00008

                    //controlsesion.login(context, 'js.castrogaray', '12345'); //ADM001

                    //controlsesion.login(context, 'j.perez', '12345'); //PROF001

                    controlsesion.login(context, _usernameController.text, _passwordController.text);
                  },
                  style: AppColors.botonverde,
                  child: Text(
                    S.of(context).label_boton_login,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Link "¿Olvidaste tu contraseña?"
              TextButton(
                onPressed: () async {
                  String? usuario = await mostrarDialogoRecuperarContrasena(context);
                  if (usuario != null) {
                    await ClienteRecuperarContrasena().recuperarContrasena(usuario);
                    // ignore: use_build_context_synchronously
                    mostrarMensajeInferior(context, S.of(context).msj_token_enviado);
                    // ignore: use_build_context_synchronously
                    mostrarDialogoNuevaContrasenaValidacion(context, usuario);
                  }
                },
                child: Text(
                  S.of(context).label_link_olvidaste_contrasena,
                  style: TextStyle(
                    color: AppColors.verde,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Link "Quiero Inscribirme"
              TextButton(
                onPressed: () async {
                  //await abrirNavegador(AppConfig.instance.parametros['urlinscripcion']);
                  String? email = await _mostrarDialogoInscripcion(context);
                  if (email != null && email.isNotEmpty) {
                    controlsesion.enviarCorreoInscripcion(context, email);
                  }
                },
                child: Text(
                  S.of(context).label_link_quiero_inscribirme,
                  style: TextStyle(
                    color: AppColors.verde,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _mostrarDialogoInscripcion(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).label_link_quiero_inscribirme),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ingresa tu correo electrónico para inscribirte:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'ejemplo@correo.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un correo electrónico';
                    }
                    // Validación básica de email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, emailController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.verde,
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
