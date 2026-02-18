import 'dart:convert';
import 'package:appdac/config/app_config.dart';
import 'package:appdac/config/log.dart';
import 'package:http/http.dart' as http;

class Profesor {
  final String idProfesor;
  final String nombre;
  final String email;
  final String telefono;
  final String usuario;
  bool activo;
  final List<String> nombreDeporte;

  Profesor({
    required this.idProfesor,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.usuario,
    required this.activo,
    required this.nombreDeporte,
  });

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
      idProfesor: json['id_profesor'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      usuario: json['usuario'] ?? '',
      activo: json['activo'] ?? false,
      nombreDeporte: json['nombre_deporte'] != null ? List<String>.from(json['nombre_deporte'].map((x) => x.toString())) : <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_profesor': idProfesor,
        'nombre': nombre,
        'email': email,
        'telefono': telefono,
        'usuario': usuario,
        'activo': activo,
        'nombre_deporte': nombreDeporte,
      };

  @override
  String toString() {
    return 'Profesor{id: $idProfesor, nombre: $nombre, email: $email, activo: $activo}';
  }
}

class ConsultaProfesoresRequest {
  final String idAdministrador;

  ConsultaProfesoresRequest({
    required this.idAdministrador,
  });

  Map<String, dynamic> toJson() => {
        "id_administrador": idAdministrador,
      };
}

class RespuestaProfesores {
  final bool exitoso;
  final List<Profesor>? profesores;
  final String? mensaje;
  final int? statusCode;

  RespuestaProfesores({
    required this.exitoso,
    this.profesores,
    this.mensaje,
    this.statusCode,
  });

  factory RespuestaProfesores.exitoso(List<Profesor> profesores) {
    return RespuestaProfesores(
      exitoso: true,
      profesores: profesores,
    );
  }

  factory RespuestaProfesores.error({String? mensaje, int? statusCode}) {
    return RespuestaProfesores(
      exitoso: false,
      mensaje: mensaje ?? 'Error al consultar profesores',
      statusCode: statusCode,
      profesores: null,
    );
  }
}

class CambioEstadoRequest {
  final String codigo;

  CambioEstadoRequest({
    required this.codigo,
  });

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
      };
}

class ClienteProfesores {
  Future<RespuestaProfesores> consultarProfesores(String idAdministrador) async {
    try {
      final request = ConsultaProfesoresRequest(
        idAdministrador: idAdministrador,
      );

      AppConfig config = AppConfig.instance;

      String urlVerProfesores = config.parametros['urlverProfesoresAdministrador'];

      final respuesta = await http.post(
        Uri.parse(urlVerProfesores),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      return _procesarRespuesta(respuesta);
    } catch (e) {
      // Error de conexión u otro error
      return RespuestaProfesores.error(
        mensaje: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  RespuestaProfesores _procesarRespuesta(http.Response respuesta) {
    try {
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        final dynamic datos = jsonDecode(respuesta.body);

        if (datos is List) {
          final profesores = datos.map<Profesor>((json) {
            return Profesor.fromJson(json);
          }).toList();

          return RespuestaProfesores.exitoso(profesores);
        } else {
          return RespuestaProfesores.error(
            mensaje: 'Formato de respuesta inválido',
            statusCode: respuesta.statusCode,
          );
        }
      } else if (respuesta.statusCode == 401) {
        return RespuestaProfesores.error(
          mensaje: 'No autorizado. Verifique sus credenciales',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500) {
        return RespuestaProfesores.error(
          mensaje: 'Error en la solicitud (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 500) {
        return RespuestaProfesores.error(
          mensaje: 'Error del servidor (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else {
        return RespuestaProfesores.error(
          mensaje: 'Error desconocido (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      }
    } catch (e) {
      return RespuestaProfesores.error(
        mensaje: 'Error procesando respuesta: ${e.toString()}',
        statusCode: respuesta.statusCode,
      );
    }
  }

  Future<bool> cambiarEstado(String codigoProfesor) async {
    logear('codigo recibido en el servicio $codigoProfesor');
    try {
      String urlCambiarEstado = AppConfig.instance.parametros['urlcambiarestado'];
      final request = CambioEstadoRequest(
        codigo: codigoProfesor,
      );

      final respuesta = await http.post(
        Uri.parse(urlCambiarEstado),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      // Verificar el código de respuesta
      if (respuesta.statusCode == 200) {
        return true;
      } else if (respuesta.statusCode == 401) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> asignarDeportesAProfesor({
    required String tipo,
    required String idProfesor,
    required List<String> nombreDeporte,
  }) async {
    try {
      logear('--->>>> $tipo $idProfesor $nombreDeporte');
      // Construir el cuerpo de la petición
      Map<String, dynamic> body = {
        "tipo": tipo,
        "id_profesor": idProfesor,
        "nombre_deporte": nombreDeporte,
      };

      logear('paso 2');
      // URL del servicio
      final url = Uri.parse(AppConfig.instance.parametros['asignardeportesaprofesor']);
      logear('paso 3');
      // Realizar la petición POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      logear('paso 4');
      logear('paso 5 ${response.statusCode}');
      // Retornar true si el estado es 200, false en caso contrario
      return response.statusCode == 200;
    } catch (e) {
      // En caso de error (sin conexión, timeout, etc.), retornar false
      print('Error al asignar deportes: $e');
      return false;
    }
  }
}
