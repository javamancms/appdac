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

// Modelo para representar un deporte
class Deporte {
  final String idDeporte;
  final String nombreDeporte;
  final bool ofrecidoALosPadres;
  final int cantidadEstudiantesPermitidos;
  final int edadMinima;
  final int edadMaxima;
  final String genero;
  final bool paraFormularioWeb;

  Deporte({
    required this.idDeporte,
    required this.nombreDeporte,
    required this.ofrecidoALosPadres,
    required this.cantidadEstudiantesPermitidos,
    required this.edadMinima,
    required this.edadMaxima,
    required this.genero,
    required this.paraFormularioWeb,
  });

  // Factory constructor para crear un Deporte desde JSON
  factory Deporte.fromJson(Map<String, dynamic> json) {
    return Deporte(
      idDeporte: json['id_deporte'] ?? '',
      nombreDeporte: json['nombre_deporte'] ?? '',
      ofrecidoALosPadres: json['ofrecido_a_los_padres'] ?? false,
      cantidadEstudiantesPermitidos: json['cantidad_estudiantes_permitidos'] ?? 0,
      edadMinima: json['edad_minima'] ?? 0,
      edadMaxima: json['edad_maxima'] ?? 0,
      genero: json['genero'] ?? '',
      paraFormularioWeb: json['para_formulario_web'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Deporte{idDeporte: $idDeporte, nombreDeporte: $nombreDeporte}';
  }
}

// Clase para manejar errores de la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode)';
}

Future<List<Deporte>> consultarDeportesMetodologo(String idMetodologo) async {
  final url = Uri.parse(AppConfig.instance.parametros['urlmetodologoVerDeportes']);

  try {
    // Crear el cuerpo de la petición
    final Map<String, dynamic> requestBody = {
      'id_metodologo': idMetodologo,
    };

    // Realizar la petición POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('status code ${response.statusCode}');
    print('req body ${requestBody}');
    print('resp body ${response.body}');
    // Verificar si la petición fue exitosa
    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      print('paso 1');
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Verificar si la respuesta indica éxito
      if (responseData['ok'] == true && responseData['deportes'] != null) {
        print('paso 2');
        final List<dynamic> deportesJson = responseData['deportes'];

        print('paso 3');
        // Convertir cada elemento de la lista a un objeto Deporte
        return deportesJson.map((json) => Deporte.fromJson(json)).toList();
      } else {
        print('paso 4');
        throw ApiException('La respuesta de la API indica que no fue exitosa');
      }
    } else {
      print('paso 5');
      // Si el status code no es 200, lanzar una excepción
      throw ApiException(
        'Error al consultar los deportes',
        response.statusCode,
      );
    }
  } catch (e) {
    // Re-lanzar la excepción con un mensaje más claro si es necesario
    print('error consultado deportes metodologo: $e');
    return [];
  }
}

class DocumentoAsistenciaResponse {
  final bool ok;
  final String mensaje;
  final String nombre;
  final String spreadsheetUrl;
  final String descargaXlsx;
  final String descargaCsv;

  DocumentoAsistenciaResponse({
    required this.ok,
    required this.mensaje,
    required this.nombre,
    required this.spreadsheetUrl,
    required this.descargaXlsx,
    required this.descargaCsv,
  });

  factory DocumentoAsistenciaResponse.fromJson(Map<String, dynamic> json) {
    return DocumentoAsistenciaResponse(
      ok: json['ok'] ?? false,
      mensaje: json['mensaje'] ?? '',
      nombre: json['nombre'] ?? '',
      spreadsheetUrl: json['spreadsheet_url'] ?? '',
      descargaXlsx: json['descarga_xlsx'] ?? '',
      descargaCsv: json['descarga_csv'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'mensaje': mensaje,
      'nombre': nombre,
      'spreadsheet_url': spreadsheetUrl,
      'descarga_xlsx': descargaXlsx,
      'descarga_csv': descargaCsv,
    };
  }
}

Future<DocumentoAsistenciaResponse> verDocumentoAsistencia(String idDeporte) async {
  try {
    final Map<String, String> body = {
      'id_deporte': idDeporte,
    };

    final response = await http.post(
      Uri.parse(AppConfig.instance.parametros['urlmetodologoDocumentoAsistencia']),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return DocumentoAsistenciaResponse.fromJson(responseData);
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al conectar con el servicio: $e');
  }
}


Future<bool> enviarComentario(String idDeporte, String comentario) async {
  try {
    final url = Uri.parse(AppConfig.instance.parametros['urlmetodologoAgregarComentario']);
    
    final Map<String, dynamic> body = {
      'id_deporte': idDeporte,
      'comentario': comentario,
    };
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    
    return response.statusCode == 200;
  } catch (e) {
    // En caso de error (timeout, sin conexión, etc.)
    print('Error al enviar comentario: $e');
    return false;
  }
}
