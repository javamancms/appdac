import 'dart:convert';
import 'package:appdac/config/app_config.dart';
import 'package:appdac/config/log.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'dart:io';

class Credenciales {
  final String username;
  final String password;

  Credenciales({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

class RespuestaLogin {
  final bool ok;
  final String type;
  final String idUsuario;
  final String nombre;
  final bool actualizacionDatos;
  final String? error;
  final int? statusCode;
  final String? estadoDeRevision;

  RespuestaLogin({required this.ok, required this.type, required this.idUsuario, required this.nombre, required this.actualizacionDatos, this.error, this.statusCode, this.estadoDeRevision});

  factory RespuestaLogin.fromJson(Map<String, dynamic> json) {
    return RespuestaLogin(
      ok: json['ok'] ?? false,
      type: json['Type'] ?? '',
      idUsuario: json['id_administrador'] ?? json['id_profesor'] ?? json['id_estudiante'] ?? json['id_metodologo'],
      nombre: json['nombre'] ?? '',
      actualizacionDatos: (json['Actualizacion de datos'] ?? 'false').toString().toLowerCase() == 'true',
      estadoDeRevision: json['Estado de revision'] ?? '',
    );
  }

  factory RespuestaLogin.error({String? error, int? statusCode}) {
    return RespuestaLogin(
      ok: false,
      type: '',
      idUsuario: '',
      nombre: '',
      actualizacionDatos: false,
      error: error,
      statusCode: statusCode,
    );
  }
}

class ClienteLogin {
  Future<RespuestaLogin> autenticar(Credenciales credenciales) async {
    try {
      final config = AppConfig.instance;
      String urlLogin = config.parametros['urllogin'];
      logear('credenciales json: ${credenciales.toJson()}');
      final respuesta = await http.post(
        Uri.parse(urlLogin),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(credenciales.toJson()),
      );

      // Verificar si la respuesta es JSON exitoso
      if (respuesta.statusCode == 200) {
        try {
          final Map<String, dynamic> datos = jsonDecode(respuesta.body);
          return RespuestaLogin.fromJson(datos);
        } catch (e) {
          // Si no se puede decodificar como JSON, puede ser XML de error
          return _procesarError(respuesta);
        }
      } else {
        return _procesarError(respuesta);
      }
    } catch (e) {
      logear('error: ${e.toString()}');
      return RespuestaLogin.error(
        error: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  RespuestaLogin _procesarError(http.Response respuesta) {
    // Verificar si es respuesta XML (401)
    if (respuesta.statusCode == 401 || respuesta.body.contains('<html>')) {
      return RespuestaLogin.error(
        error: 'Credenciales inválidas',
        statusCode: respuesta.statusCode,
      );
    } else {
      return RespuestaLogin.error(
        error: 'Error del servidor (${respuesta.statusCode})',
        statusCode: respuesta.statusCode,
      );
    }
  }

  Future<bool> enviarInscripcion(String email) async {
    final String url = AppConfig.instance.parametros['urlincripcion'];

    try {
      // Crear el cuerpo de la petición
      final Map<String, dynamic> body = {
        'email': email,
      };

      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      // Verificar si la petición fue exitosa (código 200)
      if (response.statusCode == 200) {
        // Opcional: puedes decodificar la respuesta si necesitas validar algo más
        // final Map<String, dynamic> responseData = json.decode(response.body);
        // return responseData['success'] == true;

        return true;
      } else {
        print('Error en la inscripción. Código: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return false;
    }
  }
}

//****************************************************************************** */
//****************************************************************************** */

class RecuperacionRequest {
  final String usuario;

  RecuperacionRequest({
    required this.usuario,
  });

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
      };
}

class RespuestaRecuperacion {
  final bool exitoso;
  final String? mensaje;
  final int? statusCode;

  RespuestaRecuperacion({
    required this.exitoso,
    this.mensaje,
    this.statusCode,
  });

  factory RespuestaRecuperacion.exitoso() {
    return RespuestaRecuperacion(
      exitoso: true,
      mensaje: 'Solicitud de recuperación enviada exitosamente',
    );
  }

  factory RespuestaRecuperacion.error({String? mensaje, int? statusCode}) {
    return RespuestaRecuperacion(
      exitoso: false,
      mensaje: mensaje ?? 'Error desconocido',
      statusCode: statusCode,
    );
  }
}

class ClienteRecuperarContrasena {
  /*static const String _urlBase = 'http://xxxxx.com';
  final String _urlRecuperar = '$_urlBase/recuperarcontrasena';*/

  Future<RespuestaRecuperacion> recuperarContrasena(String usuario) async {
    try {
      final request = RecuperacionRequest(usuario: usuario);
      final String urlRecuperar = AppConfig.instance.parametros['urlRecupContrasena'];
      final respuesta = await http.post(
        Uri.parse(urlRecuperar),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      // Verificar el código de respuesta
      if (respuesta.statusCode == 200) {
        // Si el servicio responde con 200, consideramos exitosa la solicitud
        return RespuestaRecuperacion.exitoso();
      } else if (respuesta.statusCode == 401) {
        // Si es 401 (como en el ejemplo XML), es un error
        return RespuestaRecuperacion.error(
          mensaje: 'Usuario no encontrado o no autorizado',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500) {
        // Otros errores del cliente
        return RespuestaRecuperacion.error(
          mensaje: 'Error en la solicitud (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 500) {
        // Errores del servidor
        return RespuestaRecuperacion.error(
          mensaje: 'Error del servidor (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else {
        // Otros códigos no manejados
        return RespuestaRecuperacion.exitoso();
      }
    } catch (e) {
      // Error de conexión u otro error
      return RespuestaRecuperacion.error(
        mensaje: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

class NuevaContrasenaRequest {
  final String usuario;
  final String token;
  final String contrasena;

  NuevaContrasenaRequest({
    required this.usuario,
    required this.token,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "token": token,
        "contrasena": contrasena,
      };
}

class RespuestaNuevaContrasena {
  final bool exitoso;
  final String? mensaje;
  final int? statusCode;

  RespuestaNuevaContrasena({
    required this.exitoso,
    this.mensaje,
    this.statusCode,
  });

  factory RespuestaNuevaContrasena.exitoso() {
    return RespuestaNuevaContrasena(
      exitoso: true,
      mensaje: 'Contraseña actualizada exitosamente',
    );
  }

  factory RespuestaNuevaContrasena.error({String? mensaje, int? statusCode}) {
    return RespuestaNuevaContrasena(
      exitoso: false,
      mensaje: mensaje ?? 'Error al actualizar la contraseña',
      statusCode: statusCode,
    );
  }
}

class ClienteNuevaContrasena {
  Future<RespuestaNuevaContrasena> establecerContrasena({
    required String usuario,
    required String token,
    required String contrasena,
  }) async {
    try {
      final request = NuevaContrasenaRequest(
        usuario: usuario,
        token: token,
        contrasena: contrasena,
      );

      final String urlNuevaContrasena = AppConfig.instance.parametros['urlNuevaContrasena'];

      final respuesta = await http.post(
        Uri.parse(urlNuevaContrasena),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      // Analizar la respuesta
      return _procesarRespuesta(respuesta);
    } catch (e) {
      // Error de conexión u otro error
      return RespuestaNuevaContrasena.error(
        mensaje: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  RespuestaNuevaContrasena _procesarRespuesta(http.Response respuesta) {
    // Considerar exitoso si no hay errores de cliente (4xx)
    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return RespuestaNuevaContrasena.exitoso();
    } else if (respuesta.statusCode == 400) {
      return RespuestaNuevaContrasena.error(
        mensaje: 'Datos inválidos o token expirado',
        statusCode: respuesta.statusCode,
      );
    } else if (respuesta.statusCode == 401) {
      return RespuestaNuevaContrasena.error(
        mensaje: 'Token inválido o no autorizado',
        statusCode: respuesta.statusCode,
      );
    } else if (respuesta.statusCode == 404) {
      return RespuestaNuevaContrasena.error(
        mensaje: 'Usuario no encontrado',
        statusCode: respuesta.statusCode,
      );
    } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500) {
      return RespuestaNuevaContrasena.error(
        mensaje: 'Error en la solicitud (${respuesta.statusCode})',
        statusCode: respuesta.statusCode,
      );
    } else if (respuesta.statusCode >= 500) {
      return RespuestaNuevaContrasena.error(
        mensaje: 'Error del servidor (${respuesta.statusCode})',
        statusCode: respuesta.statusCode,
      );
    } else {
      // Para otros códigos, considerar exitoso
      return RespuestaNuevaContrasena.exitoso();
    }
  }
}
