import 'dart:convert';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/config/app_config.dart';
import 'package:http/http.dart' as http;

// Modelo interno para representar un metodólogo
class Metodologo {
  final String idMetodologo;
  final String nombre;
  final String usuario;
  bool activo;

  Metodologo({
    required this.idMetodologo,
    required this.nombre,
    required this.usuario,
    required this.activo,
  });

  // Factory constructor para crear una instancia desde JSON
  factory Metodologo.fromJson(Map<String, dynamic> json) {
    return Metodologo(
      idMetodologo: json['id_metodologo'] as String,
      nombre: json['nombre'] as String,
      usuario: json['usuario'] as String,
      activo: json['activo'] != null ? json['activo'] as bool : false,
    );
  }

  // Método para convertir a JSON (útil si necesitas enviar datos)
  Map<String, dynamic> toJson() {
    return {
      'id_metodologo': idMetodologo,
      'nombre': nombre,
      'usuario': usuario,
      'activo': activo,
    };
  }

  @override
  String toString() {
    return 'Metodologo{idMetodologo: $idMetodologo, nombre: $nombre, usuario: $usuario, activo: $activo}';
  }
}

// Clase para manejar errores personalizados
class MetodologoException implements Exception {
  final String message;
  final int? statusCode;

  MetodologoException(this.message, [this.statusCode]);

  @override
  String toString() => 'MetodologoException: $message${statusCode != null ? ' (Código: $statusCode)' : ''}';
}

class ClienteMetodologo {
  Future<List<Metodologo>> consultarMetodologos(String idAdministrador) async {
    String baseUrl = AppConfig.instance.parametros['urlvermetodologos'];
    try {
      if (idAdministrador.isEmpty) {
        throw MetodologoException('El ID del administrador no puede estar vacío');
      }

      // Crear el cuerpo de la petición
      final Map<String, String> body = {
        'id_administrador': idAdministrador,
      };

      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Verificar el código de respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Convertir cada elemento de la lista a un objeto Metodologo
        final List<Metodologo> metodologos = jsonResponse.map((item) => Metodologo.fromJson(item as Map<String, dynamic>)).toList();

        return metodologos;
      } else {
        // Manejar errores HTTP
        throw MetodologoException(
          'Error al consultar metodólogos',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      // Error de conexión
      throw MetodologoException('Error de conexión: ${e.message}');
    } on FormatException catch (e) {
      // Error al decodificar JSON
      throw MetodologoException('Error en el formato de la respuesta: ${e.message}');
    } catch (e) {
      // Cualquier otro error
      throw MetodologoException('Error inesperado: ${e.toString()}');
    }
  }

  Future<bool> cambiarEstado(String codigoMetodologo) async {
    try {
      String urlCambiarEstado = AppConfig.instance.parametros['urlcambiarestado'];
      final request = CambioEstadoRequest(
        codigo: codigoMetodologo,
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
}
