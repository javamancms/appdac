import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/c_integracion/intlogin.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';

void mostrarMensajeInferior(
  BuildContext context,
  String mensaje, {
  Color? colorFondo,
  Color? colorFuente,
  double? tamanoFuente,
  FontWeight fontWeight = FontWeight.w500,
  IconData? icono,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  final theme = Theme.of(context);

  // Crear estilo de texto con mejores valores por defecto
  TextStyle estiloTexto = TextStyle(
    color: colorFuente ?? Colors.white,
    fontSize: tamanoFuente ?? 14.0,
    fontWeight: fontWeight,
    letterSpacing: 0.25,
  );

  // Determinar color de fondo con fallback
  final Color backgroundColor = colorFondo ?? 
    theme.snackBarTheme.backgroundColor ?? 
    theme.primaryColor.withOpacity(0.95);

  // Configurar contenido
  Widget contenido = icono != null
      ? Row(
          children: [
            Icon(
              icono,
              color: colorFuente ?? Colors.white,
              size: (tamanoFuente ?? 14.0) * 1.1,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensaje,
                style: estiloTexto,
              ),
            ),
          ],
        )
      : Text(mensaje, style: estiloTexto);

  // Mostrar SnackBar mejorado
  scaffold.showSnackBar(
    SnackBar(
      content: contenido,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.08,
        left: 16,
        right: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: backgroundColor,
      elevation: 8,
      showCloseIcon: true,
      closeIconColor: colorFuente?.withOpacity(0.8) ?? Colors.white.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  );
}


Future<String?> mostrarDialogoRecuperarContrasena(BuildContext context) async {
  String? usuarioRecuperado;
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título en negrilla
                Text(
                  S.of(context).label_recuperarcontrasena,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.verde,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtítulo sin negrilla
                Text(
                  S.of(context).label_recuperarcontrasenaexp,
                  style: AppColors.textoinformativogris,
                ),

                const SizedBox(height: 24),

                // Campo de texto para el usuario
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: S.of(context).label_usuario,
                      hintText: S.of(context).label_usuario,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.verde), // Borde por defecto verde
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.verde), // Borde cuando está habilitado
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.verde, width: 2), // Borde cuando está enfocado
                      ),
                      filled: true,
                      fillColor: AppColors.blanco,
                      labelStyle: TextStyle(color: AppColors.verde), // Color del label
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).label_ingrese_usuario;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),

                const SizedBox(height: 32),

                // Botones alineados a la derecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Botón Cancelar
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      style: AppColors.botonblanco,
                      child: Text(
                        S.of(context).label_cancelar,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Botón Enviar
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          usuarioRecuperado = controller.text.trim();
                          Navigator.of(context).pop(usuarioRecuperado);
                        }
                      },
                      style: AppColors.botonverde,
                      child: Text(
                        S.of(context).label_enviar,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void mostrarDialogoNuevaContrasenaValidacion(BuildContext context, String usuario) {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmacionController = TextEditingController();

  bool contrasenasCoinciden = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void validarContrasenas() {
            setState(() {
              contrasenasCoinciden = contrasenaController.text.isNotEmpty && contrasenaController.text == confirmacionController.text;
            });
          }

          return AlertDialog(
            title: Text(
              S.of(context).label_nueva_contrasena,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).label_nueva_contrasenaexp),
                  const SizedBox(height: 20),
                  TextField(
                    controller: tokenController,
                    decoration: InputDecoration(
                      labelText: S.of(context).label_token,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contrasenaController,
                    obscureText: true,
                    onChanged: (_) => validarContrasenas(),
                    decoration: InputDecoration(
                      labelText: S.of(context).label_nueva_contrasena,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmacionController,
                    obscureText: true,
                    onChanged: (_) => validarContrasenas(),
                    decoration: InputDecoration(
                      labelText: S.of(context).label_nueva_contrasenaconfirmar,
                      border: OutlineInputBorder(),
                      errorText: contrasenasCoinciden || confirmacionController.text.isEmpty ? null : S.of(context).msj_contrasenas_diferentes,
                    ),
                  ),
                  if (contrasenasCoinciden && contrasenaController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context).msj_contrasenas_iguales,
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).label_cancelar),
              ),
              ElevatedButton(
                onPressed: contrasenasCoinciden && tokenController.text.isNotEmpty
                    ? () async {
                        RespuestaNuevaContrasena respuesta = await ClienteNuevaContrasena().establecerContrasena(usuario: usuario, token: tokenController.text, contrasena: contrasenaController.text);

                        Navigator.pop(context);
                        mostrarMensajeInferior(context, respuesta.mensaje!);
                      }
                    : null,
                child: Text(S.of(context).label_enviar),
              ),
            ],
          );
        },
      );
    },
  );
}
