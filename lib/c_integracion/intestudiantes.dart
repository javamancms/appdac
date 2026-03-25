import 'dart:convert';
import 'dart:io';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/config/app_config.dart';
import 'package:appdac/config/log.dart';
import 'package:http/http.dart' as http;

class DeporteEstudiante {
  final String idDeporte;
  final String nombreDeporte;

  DeporteEstudiante({
    required this.idDeporte,
    required this.nombreDeporte,
  });

  factory DeporteEstudiante.fromJson(Map<String, dynamic> json) {
    return DeporteEstudiante(
      idDeporte: json['id_deporte'] ?? '',
      nombreDeporte: json['nombre_deporte'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_deporte': idDeporte,
        'nombre_deporte': nombreDeporte,
      };

  @override
  String toString() {
    return 'Deporte{id: $idDeporte, nombre: $nombreDeporte}';
  }
}

class ConsultaDeportesRequest {
  final String idEstudiante;

  ConsultaDeportesRequest({
    required this.idEstudiante,
  });

  Map<String, dynamic> toJson() => {
        "id_estudiante": idEstudiante,
      };
}

class RespuestaDeportesEstudiante {
  final bool exitoso;
  final List<DeporteEstudiante>? deportes;
  final String? mensaje;
  final int? statusCode;

  RespuestaDeportesEstudiante({
    required this.exitoso,
    this.deportes,
    this.mensaje,
    this.statusCode,
  });

  factory RespuestaDeportesEstudiante.exitoso(List<DeporteEstudiante> deportes) {
    return RespuestaDeportesEstudiante(
      exitoso: true,
      deportes: deportes,
    );
  }

  factory RespuestaDeportesEstudiante.error({String? mensaje, int? statusCode}) {
    return RespuestaDeportesEstudiante(
      exitoso: false,
      mensaje: mensaje ?? 'Error al consultar deportes del estudiante',
      statusCode: statusCode,
      deportes: null,
    );
  }
}

//******************************************************************************************************** */
// deporte_model.dart
class Deporte {
  final String nombreDeporte;
  final bool existe;

  Deporte({
    required this.nombreDeporte,
    required this.existe,
  });

  factory Deporte.fromJson(Map<String, dynamic> json) {
    return Deporte(
      nombreDeporte: json['nombre_deporte'],
      existe: json['existe'],
    );
  }
}

class DeportesResponse {
  final bool ok;
  final List<Deporte> deportes;
  final int total;

  DeportesResponse({
    required this.ok,
    required this.deportes,
    required this.total,
  });

  factory DeportesResponse.fromJson(Map<String, dynamic> json) {
    var deportesList = json['deportes'] as List;
    List<Deporte> deportes = deportesList.map((deporteJson) => Deporte.fromJson(deporteJson)).toList();

    return DeportesResponse(
      ok: json['ok'],
      deportes: deportes,
      total: json['total'],
    );
  }
}

//************************************************************************************
// actualizacion_estudiante_model.dart
class ActualizacionEstudianteRequest {
  final String tipo;
  final String idEstudiante;
  final List<Deporte> deportes;

  ActualizacionEstudianteRequest({
    required this.tipo,
    required this.idEstudiante,
    required this.deportes,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'id_estudiante': idEstudiante,
      'deportes': deportes
          .map((deporte) => {
                'nombre_deporte': deporte.nombreDeporte,
                'existe': deporte.existe,
              })
          .toList(),
    };
  }
}

class Estudiante {
  final String id;
  final DateTime createdTime;
  final String idEstudiante;
  final String nombre;
  final int documento;
  final String email;
  bool activo;
  final List<String> matriculas;
  final List<String> deporte;
  final List<String> usuario;
  final String passwordHash;
  final List<Archivo> identificacion;
  final String estadoRevision;
  final String? comentarios;
  final String eps;
  final String? alergias;
  final String? nombreMedicamento;
  final String? condicionesMedicas;
  final bool? actualizacionDatos;
  final String apellidosDeportista;
  final int consecutivo;
  final List<String> usuarioBuscado;
  final List<String> usuario2;
  final CreadoPor creadoPor;
  final List<Archivo>? consentimiento;
  final String nombresAcudiente1;
  final String apellidosAcudiente1;
  final String celularAcudiente1;
  final int documentoAcudiente1;
  final String lugarExpedicion;
  final String genero;
  final String lugarNacimiento;
  final String veredaSector;
  final String direccion;
  final String institucionEducativa;
  final String tipoInstitucion;
  final String gradoEscolar;
  final String tipoPoblacion;
  final String tipoRegimenEps;
  final String grupoSanguineo;
  final String enfermedadesPrevias;
  final String cirugiasPrevias;
  final String tomaMedicamentos;
  final String lesionesPrevias;
  final List<Archivo> copiaCertificadoEps;

  Estudiante({
    required this.id,
    required this.createdTime,
    required this.idEstudiante,
    required this.nombre,
    required this.documento,
    required this.email,
    required this.activo,
    required this.matriculas,
    required this.deporte,
    required this.usuario,
    required this.passwordHash,
    required this.identificacion,
    required this.estadoRevision,
    this.comentarios,
    required this.eps,
    this.alergias,
    this.nombreMedicamento,
    this.condicionesMedicas,
    this.actualizacionDatos,
    required this.apellidosDeportista,
    required this.consecutivo,
    required this.usuarioBuscado,
    required this.usuario2,
    required this.creadoPor,
    this.consentimiento,
    required this.nombresAcudiente1,
    required this.apellidosAcudiente1,
    required this.celularAcudiente1,
    required this.documentoAcudiente1,
    required this.lugarExpedicion,
    required this.genero,
    required this.lugarNacimiento,
    required this.veredaSector,
    required this.direccion,
    required this.institucionEducativa,
    required this.tipoInstitucion,
    required this.gradoEscolar,
    required this.tipoPoblacion,
    required this.tipoRegimenEps,
    required this.grupoSanguineo,
    required this.enfermedadesPrevias,
    required this.cirugiasPrevias,
    required this.tomaMedicamentos,
    required this.lesionesPrevias,
    required this.copiaCertificadoEps,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'] ?? '',
      createdTime: DateTime.parse(json['createdTime'] ?? DateTime.now().toIso8601String()),
      idEstudiante: json['Id_estudiante'] ?? '',
      nombre: json['Nombre'] ?? '',
      documento: json['Documento'] ?? 0,
      email: json['Email'] ?? '',
      activo: json['Activo'] ?? false,
      matriculas: List<String>.from(json['Matriculas'] ?? []),
      deporte: List<String>.from(json['Deporte (de Matriculas)'] ?? []),
      usuario: List<String>.from(json['Usuario'] ?? []),
      passwordHash: json['Password_hash'] ?? '',
      identificacion: (json['Identificacion'] as List?)?.map((item) => Archivo.fromJson(item)).toList() ?? [],
      estadoRevision: json['Estado de revision'] ?? '',
      comentarios: json['Comentarios'],
      eps: json['EPS'] ?? '',
      alergias: json['Alergias'],
      nombreMedicamento: json['NOMBRE DEL MEDICAMENTO'],
      condicionesMedicas: json['Condiciones medicas'],
      actualizacionDatos: json['Actualizacion de datos'],
      apellidosDeportista: json['APELLIDOS DEPORTISTA'] ?? '',
      consecutivo: json['Consecutivo'] ?? 0,
      usuarioBuscado: List<String>.from(json['Usuario buscado'] ?? []),
      usuario2: List<String>.from(json['Usuario2'] ?? []),
      creadoPor: CreadoPor.fromJson(json['Creado por'] ?? {}),
      consentimiento: json['Consentimiento'] != null ? (json['Consentimiento'] as List).map((item) => Archivo.fromJson(item)).toList() : null,
      nombresAcudiente1: json['NOMBRES DEL ACUDIENTE 1'] ?? '',
      apellidosAcudiente1: json['APELLIDOS DEL ACUDIENTE 1'] ?? '',
      celularAcudiente1: json['NÚMERO DE CELULAR DEL ACUDIENTE 1'] ?? '',
      documentoAcudiente1: json['NÚMERO DE DOCUMENTO DE IDENTIDAD DE ACUDIENTE 1'] ?? 0,
      lugarExpedicion: json['LUGAR DE EXPEDICIÓN DOCUMENTO DE IDENTIDAD DEPORTISTA'] ?? '',
      genero: json['GENERO DEL DEPORTISTA'] ?? '',
      lugarNacimiento: json['LUGAR DE NACIMIENTO DEL DEPORTISTA'] ?? '',
      veredaSector: json['VEREDA O SECTOR DE VIVIENDA DEL DEPORTISTA'] ?? '',
      direccion: json['DIRECCIÓN O CONJUNTO DE RESIDENCIA DEL DEPORTISTA'] ?? '',
      institucionEducativa: json['NOMBRE DE INSTITUCIÓN EDUCATIVA DEL DEPORTISTA'] ?? '',
      tipoInstitucion: json['TIPO DE INSTITUCIÓN EDUCATIVA DEL DEPORTISTA'] ?? '',
      gradoEscolar: json['GRADO ESCOLAR DEL DEPORTISTA'] ?? '',
      tipoPoblacion: json['TIPO DE POBLACIÓN'] ?? '',
      tipoRegimenEps: json['TIPO DE RÉGIMEN EPS'] ?? '',
      grupoSanguineo: json['GRUPO SANGUINEO RH'] ?? '',
      enfermedadesPrevias: json['ENFERMEDADES PREVIAS'] ?? '',
      cirugiasPrevias: json['CIRUGÍAS PREVIAS'] ?? '',
      tomaMedicamentos: json['TOMA MEDICAMENTOS'] ?? '',
      lesionesPrevias: json['LESIONES PREVIAS'] ?? '',
      copiaCertificadoEps: (json['COPIA DEL CERTIFICADO DE LA EPS ACTIVO, NO SE ACEPTA CERTIFICADO DE LA PLATAFORMA ADRES '] as List?)?.map((item) => Archivo.fromJson(item)).toList() ?? [],
    );
  }
}

class Archivo {
  final String id;
  final int? width;
  final int? height;
  final String url;
  final String filename;
  final int size;
  final String type;
  final Thumbnails? thumbnails;

  Archivo({
    required this.id,
    this.width,
    this.height,
    required this.url,
    required this.filename,
    required this.size,
    required this.type,
    this.thumbnails,
  });

  factory Archivo.fromJson(Map<String, dynamic> json) {
    return Archivo(
      id: json['id'] ?? '',
      width: json['width'],
      height: json['height'],
      url: json['url'] ?? '',
      filename: json['filename'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
      thumbnails: json['thumbnails'] != null ? Thumbnails.fromJson(json['thumbnails']) : null,
    );
  }
}

class Thumbnails {
  final Thumbnail small;
  final Thumbnail large;
  final Thumbnail full;

  Thumbnails({
    required this.small,
    required this.large,
    required this.full,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      small: Thumbnail.fromJson(json['small'] ?? {}),
      large: Thumbnail.fromJson(json['large'] ?? {}),
      full: Thumbnail.fromJson(json['full'] ?? {}),
    );
  }
}

class Thumbnail {
  final String url;
  final int width;
  final int height;

  Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

class CreadoPor {
  final String id;
  final String email;
  final String name;

  CreadoPor({
    required this.id,
    required this.email,
    required this.name,
  });

  factory CreadoPor.fromJson(Map<String, dynamic> json) {
    return CreadoPor(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

//************************************************************************************************************************ */

class ClienteEstudiantes {
  Future<RespuestaDeportesEstudiante> consultarDeportes(String idEstudiante) async {
    try {
      final request = ConsultaDeportesRequest(
        idEstudiante: idEstudiante,
      );

      final String urlVerEstudianteDeportes = AppConfig.instance.parametros['urlverDeportesEstudiante'];

      final respuesta = await http.post(
        Uri.parse(urlVerEstudianteDeportes),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      return _procesarRespuesta(respuesta);
    } catch (e) {
      // Error de conexión u otro error
      return RespuestaDeportesEstudiante.error(
        mensaje: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  RespuestaDeportesEstudiante _procesarRespuesta(http.Response respuesta) {
    try {
      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        final dynamic datos = jsonDecode(respuesta.body);

        if (datos is List) {
          final deportes = datos.map<DeporteEstudiante>((json) {
            return DeporteEstudiante.fromJson(json);
          }).toList();

          return RespuestaDeportesEstudiante.exitoso(deportes);
        } else {
          return RespuestaDeportesEstudiante.error(
            mensaje: 'Formato de respuesta inválido',
            statusCode: respuesta.statusCode,
          );
        }
      } else if (respuesta.statusCode == 401) {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'No autorizado. Verifique sus credenciales',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 400 && respuesta.statusCode < 500) {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'Error en la solicitud (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else if (respuesta.statusCode >= 500) {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'Error del servidor (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      } else {
        return RespuestaDeportesEstudiante.error(
          mensaje: 'Error desconocido (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      }
    } catch (e) {
      return RespuestaDeportesEstudiante.error(
        mensaje: 'Error procesando respuesta: ${e.toString()}',
        statusCode: respuesta.statusCode,
      );
    }
  }

  /// Método para enviar documentación PDF de un estudiante
  /// [idestudiante]: ID del estudiante (String)
  /// [documento]: Archivo PDF a subir (File)
  /// Retorna un Future<Map<String, dynamic>> con la respuesta del servidor

  static Future<Map<String, dynamic>> enviarDocumentacion(String idestudiante, File documento, File eps, File consentimiento) async {
    try {
      // Validar que el archivo sea PDF
      if (!_esArchivoPDF(documento) || !_esArchivoPDF(eps) || !_esArchivoPDF(consentimiento)) {
        return {'success': false, 'error': 'El archivo debe ser un PDF (.pdf)', 'actualizado': 'ERROR', 'mensaje': 'Solo se permiten archivos PDF'};
      }

      List<int> pdfBytesDocumento = await documento.readAsBytes();
      String pdfBase64Documento = base64Encode(pdfBytesDocumento);

      List<int> pdfBytesEps = await eps.readAsBytes();
      String pdfBase64Eps = base64Encode(pdfBytesEps);

      List<int> pdfBytesConsentimiento = await consentimiento.readAsBytes();
      String pdfBase64Consentimiento = base64Encode(pdfBytesConsentimiento);

      // 3. Crear el cuerpo JSON según especificaciones
      Map<String, dynamic> requestBody = {
        'idestudiante': idestudiante,
        'documento': pdfBase64Documento,
        'eps': pdfBase64Eps,
        'consentimiento': pdfBase64Consentimiento,
      };

      print("************************************************");
      print(json.encode(requestBody));
      print("************************************************");

      final String endpointUrl = AppConfig.instance.parametros['urlestudianteEnviarDocumentos'];

      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // 5. Procesar la respuesta
      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          Map<String, dynamic> jsonResponse = json.decode(response.body);

          return {
            'success': true,
            'actualizado': jsonResponse['actualizado'] ?? 'OK',
            'mensaje': jsonResponse['mensaje'] ?? 'Documento actualizado exitosamente',
            'statusCode': response.statusCode,
            'responseData': jsonResponse,
          };
        } catch (e) {
          // Si no se puede parsear como JSON
          return {
            'success': false,
            'error': 'Error al procesar respuesta del servidor: $e',
            'statusCode': response.statusCode,
            'rawResponse': response.body,
          };
        }
      } else {
        // Error HTTP
        return {
          'success': false,
          'error': 'Error HTTP ${response.statusCode}',
          'statusCode': response.statusCode,
          'responseBody': response.body,
        };
      }
    } on SocketException {
      // Error de conexión
      return {'success': false, 'error': 'Error de conexión. Verifica tu internet.', 'actualizado': 'ERROR', 'mensaje': 'No se pudo conectar al servidor'};
    } on http.ClientException catch (e) {
      // Error del cliente HTTP
      return {'success': false, 'error': 'Error del cliente HTTP: $e', 'actualizado': 'ERROR', 'mensaje': 'Error en la comunicación'};
    } catch (e) {
      // Error general
      return {'success': false, 'error': 'Error inesperado: $e', 'actualizado': 'ERROR', 'mensaje': 'Error al enviar el documento'};
    }
  }

  /// Método auxiliar para validar que el archivo sea PDF
  static bool _esArchivoPDF(File file) {
    String extension = file.path.toLowerCase().split('.').last;
    return extension == 'pdf';
  }

  /// Método alternativo con validación más estricta
  /* static Future<Map<String, dynamic>> enviarDocumentacionConValidacion(
    String idestudiante,
    File documento,
  ) async {
    // Validaciones previas
    if (idestudiante.isEmpty) {
      return {'success': false, 'error': 'El ID del estudiante es requerido', 'actualizado': 'ERROR', 'mensaje': 'ID de estudiante vacío'};
    }

    if (!await documento.exists()) {
      return {'success': false, 'error': 'El archivo no existe', 'actualizado': 'ERROR', 'mensaje': 'Archivo no encontrado'};
    }

    // Validar tamaño máximo (ej: 10MB)
    const maxSizeBytes = 10 * 1024 * 1024; // 10MB
    final fileSize = await documento.length();

    if (fileSize > maxSizeBytes) {
      return {'success': false, 'error': 'El archivo excede el tamaño máximo permitido (10MB)', 'actualizado': 'ERROR', 'mensaje': 'Archivo demasiado grande'};
    }

    // Llamar al método principal
    return await enviarDocumentacion(idestudiante, documento);
  }*/

  Future<String?> consultarAsistenciaCSV({
    required String idDeporte,
    required String idEstudiante,
  }) async {
    try {
      final String urlVerAsistenciaEstudiante = AppConfig.instance.parametros['urlestudianteVerAsistencia'];
      final respuesta = await http.post(
        Uri.parse(urlVerAsistenciaEstudiante),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'id_deporte': idDeporte,
          'id_estudiante': idEstudiante,
        }),
      );

      if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
        final datos = jsonDecode(respuesta.body);
        return datos['csv'] as String?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> consultarComunicadosCSV({required String idDeporte}) async {
    try {
      print('consultarComunicadosCSV: $idDeporte');
      String url = AppConfig.instance.parametros['urlestudianteVerComunicados'];

      // Headers para la petición
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Body de la petición
      final Map<String, String> body = {
        'id_deporte': idDeporte,
      };

      print('consultarComunicadosCSV paso 2: ${json.encode(body)}}');
      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      print('consultarComunicadosCSV paso 3: ${response.body}');
      // Verificar el código de estado
      if (response.statusCode == 200) {
        // Decodificar la respuesta
        final List<dynamic> responseData = json.decode(response.body);
        logear('********************************************');
        print(responseData);
        logear('********************************************');

        if (responseData.isNotEmpty) {
          final Map<String, dynamic> data = responseData[0];

          // Verificar si la respuesta es exitosa
          if (data['ok'] == true) {
            // Retornar los comunicados en formato CSV
            return data['comunicados'] as String?;
          } else {
            // El servidor respondió con ok: false
            print('Error en la respuesta del servidor: ok = false');
            return null;
          }
        } else {
          // Respuesta vacía
          print('Respuesta vacía del servidor');
          return null;
        }
      } else {
        // Error en la petición HTTP
        print('Error HTTP ${response.statusCode}: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      // Manejo de excepciones
      print('Error al consultar comunicados CSV: $e');
      return null;
    }
  }

  static Future<DeportesResponse> consultarDeportesDisponibles(String idEstudiante) async {
    logear('-->>$idEstudiante');
    try {
      String baseUrl = AppConfig.instance.parametros['urlconsultardeportesdisponibles'];

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_estudiante': idEstudiante,
        }),
      );

      if (response.statusCode == 200) {
        print('>>lista deportes: ${response.body}');

        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return DeportesResponse.fromJson(jsonResponse);
      } else {
        // Manejo de errores HTTP
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores de conexión
      print('Error al conectar con el servidor: $e');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

// Método para actualizar la inscripción del estudiante
  static Future<bool> actualizarInscripcionEstudiante({
    required String idEstudiante,
    required List<Deporte> deportes,
  }) async {
    try {
      // Crear el objeto de solicitud
      final request = ActualizacionEstudianteRequest(
        tipo: 'estudiante',
        idEstudiante: idEstudiante,
        deportes: deportes,
      );

      String baseUrl = AppConfig.instance.parametros['urlactualizarinscripcionestudiante'];

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      // Log para debugging

      print('XX------------------------------------------------------');
      for (var element in request.deportes) {
        print(element.nombreDeporte);
        print(element.existe);
      }
      print('XX------------------------------------------------------');
      print('Status Code: ${response.statusCode}');
      print('Request Body: ${jsonEncode(request.toJson())}');

      if (response.statusCode == 200) {
        print('Actualización exitosa para estudiante: $idEstudiante');
        return true;
      } else {
        print('Error en la actualización: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return false;
    }
  }

  Future<List<Estudiante>> consultarEstudiantes() async {
    try {
      String baseUrl = AppConfig.instance.parametros['urlverestudiantesadministrador'];
      // Realizar la petición POST sin body
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Verificar si la petición fue exitosa
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> jsonData = json.decode(response.body);

        // Convertir cada elemento de la lista a un objeto Estudiante
        return jsonData.map((item) => Estudiante.fromJson(item)).toList();
      } else {
        // Si hay error en la respuesta, lanzar excepción
        throw Exception('Error al consultar estudiantes. Código: ${response.statusCode}');
      }
    } catch (e) {
      // Capturar cualquier error de red o de procesamiento
      logear('Error en la petición: $e');
      return [];
    }
  }

  Future<bool> cambiarEstado(String codigoEstudiante) async {
    try {
      String urlCambiarEstado = AppConfig.instance.parametros['urlcambiarestado'];
      final request = CambioEstadoRequest(
        codigo: codigoEstudiante,
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

  Future<bool> cambiarEstadoRevision({
    required String idEstudiante,
    required String estadoRevision,
    String comentario = '',
  }) async {
    String baseUrl = AppConfig.instance.parametros['urlcambiarestadorevision'];
    try {
      // Crear el cuerpo de la petición
      final Map<String, dynamic> body = {
        'id_estudiante': idEstudiante,
        'Estado de revision': estadoRevision,
        'Comentario': comentario,
      };

      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      // Verificar si la petición fue exitosa (código 200)
      return response.statusCode == 200;
    } catch (e) {
      // En caso de error de red o de procesamiento, retornar false
      print('Error al cambiar estado de revisión: $e');
      return false;
    }
  }
}
