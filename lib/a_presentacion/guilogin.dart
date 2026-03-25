import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intlogin.dart';
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
      backgroundColor: AppColors.blanco,
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
                  //icono: Icons.person
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
                  //icono: Icons.lock
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

                    //controlsesion.login(context, 'c.morales', '12345'); //MET001

                    controlsesion.login(context, _usernameController.text, _passwordController.text);
                  },
                  style: AppColors.botonverde,
                  child: Text(
                    S.of(context).label_boton_login,
                    style: TextStyle(
                      fontFamily: AppColors.fuenteNombre,
                      fontSize: AppColors.fuenteTamanoSubtitulo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

// ... (código anterior)

              const SizedBox(height: 40),

// En lugar de tener los TextButtons separados en el Column principal,
// agrupa ambos en una Column separada con espaciado cero:

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Link "¿Olvidaste tu contraseña?"
                  TextButton(
                    onPressed: () async {
                      String? usuario = await mostrarDialogoRecuperarContrasena(context);
                      if (usuario != null) {
                        await ClienteRecuperarContrasena().recuperarContrasena(usuario);
                        mostrarMensajeInferior(context, S.of(context).msj_token_enviado);
                        mostrarDialogoNuevaContrasenaValidacion(context, usuario);
                      }
                    },
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact, // Reduce el espacio alrededor
                      padding: EdgeInsets.zero, // Elimina el padding interno
                      minimumSize: Size(50, 20), // Tamaño mínimo (ancho, alto)
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce el área de toque
                    ),
                    child: Text(
                      S.of(context).label_link_olvidaste_contrasena,
                      style: TextStyle(
                        color: AppColors.verde,
                        fontSize: AppColors.fuenteTamanoSecundario,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact, // Reduce el espacio alrededor
                      padding: EdgeInsets.zero, // Elimina el padding interno
                      minimumSize: Size(50, 20), // Tamaño mínimo (ancho, alto)
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce el área de toque
                    ),
                    onPressed: () async {
                      String? email = await _mostrarDialogoInscripcion(context);
                      if (email != null && email.isNotEmpty) {
                        controlsesion.enviarCorreoInscripcion(context, email);
                      }
                    },
                    child: Text(
                      S.of(context).label_link_quiero_inscribirme,
                      style: TextStyle(
                        color: AppColors.verde,
                        fontSize: AppColors.fuenteTamanoSecundario,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

// Espacio después del segundo TextButton
              const SizedBox(height: 40),

// ... (resto del código)
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
          title: Text(
            S.of(context).label_link_quiero_inscribirme,
            style: TextStyle(
              fontSize: AppColors.fuenteTamanoSubtitulo,
              fontWeight: FontWeight.bold, // Esto ya hace el texto en negrita
              color: AppColors.verde,
              fontFamily: AppColors.fuenteNombre,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).label_link_quiero_inscribirmeexp,
                  style: AppColors.textoinformativogris
                ),
                const SizedBox(height: 16),
                TextFormField(
                  
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  /*decoration: InputDecoration(
                    labelText: S.of(context).label_correoelectronico,
                    hintText: S.of(context).label_correoelectronicoejemplo,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    //prefixIcon: const Icon(Icons.email),
                  ),*/
                  decoration: DecoracionCampoVerde(
                    letrero: S.of(context).label_correoelectronico,
                    hintLetrero: S.of(context).label_correoelectronicoejemplo,
                    
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un correo electrónico';
                    }
                    // Validación básica de email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return S.of(context).msj_correoinvalido;
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
              style: AppColors.botonblanco,
              child: Text(
                S.of(context).label_cancelar,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, emailController.text.trim());
                }
              },
              style: AppColors.botonverde,
              child: Text(S.of(context).label_enviar),
            ),
          ],
        );
      },
    );
  }
}
