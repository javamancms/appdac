import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/c_integracion/intlogin.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ControlSesion extends ChangeNotifier {
  static Credenciales? credenciales;
  static RespuestaLogin? datosusuario;

  void login(BuildContext context, String usuario, String clave) async {
    credenciales = Credenciales(username: usuario, password: clave);
    datosusuario = await ClienteLogin().autenticar(credenciales!);

print('-----------------------------------------------------------------------');
print('-----------------------------------------------------------------------');
print('nombre ${datosusuario!.nombre}');
print('tipo ${datosusuario!.type}');

print('-----------------------------------------------------------------------');
print('-----------------------------------------------------------------------');

    if (datosusuario!.error == null) {
      
      context.push('/${datosusuario!.type}');
    } else {
      mostrarMensajeInferior(context, '${S.of(context).msj_errorlogin} ${datosusuario!.error}');
    }
  }

  void enviarCorreoInscripcion(BuildContext context, String email) async {
   
    bool resultado = await ClienteLogin().enviarInscripcion(email);

    if (resultado) {
      mostrarMensajeInferior(context, S.of(context).msj_inscripcionenviada);
    } else {
      mostrarMensajeInferior(context, S.of(context).msj_inscripcionerror);
      
    }
  }
}
