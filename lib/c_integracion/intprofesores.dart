import 'dart:convert';
import 'package:appdac/c_integracion/intdeportes.dart';
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

class DeporteProfesor {
  final String idDeporte;
  final String nombreDeporte;

  DeporteProfesor({
    required this.idDeporte,
    required this.nombreDeporte,
  });

  factory DeporteProfesor.fromJson(Map<String, dynamic> json) {
    return DeporteProfesor(
      idDeporte: json['id_deporte'] as String,
      nombreDeporte: json['nombre_deporte'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_deporte': idDeporte,
      'nombre_deporte': nombreDeporte,
    };
  }

  @override
  String toString() => 'Deporte(idDeporte: $idDeporte, nombreDeporte: $nombreDeporte)';
}

class EstudianteDeporte {
  final String id;
  final DateTime createdTime;
  final String idEstudiante;
  final String nombre;
  final int documento;
  final String email;
  final bool activo;
  final List<String> matriculas;
  final List<String> deporteDeMatriculas;
  final List<String> usuario;
  final String passwordHash;
  final List<dynamic> identificacion;
  final String estadoRevision;
  final String comentarios;
  final String eps;
  final bool actualizacionDatos;
  final String nombresAcudiente1;
  final String apellidosAcudiente1;
  final String numeroCelularAcudiente1;
  final int numeroDocumentoAcudiente1;
  final String lugarExpedicionDocumentoDeportista;
  final String generoDeportista;
  final String lugarNacimientoDeportista;
  final String veredaSectorVivienda;
  final String direccionResidencia;
  final String nombreInstitucionEducativa;
  final String tipoInstitucionEducativa;
  final String gradoEscolar;
  final String tipoPoblacion;
  final String tipoRegimenEps;
  final String grupoSanguineoRh;
  final String enfermedadesPrevias;
  final String cirugiasPrevias;
  final String tomaMedicamentos;
  final String lesionesPrevias;
  final String tratamientosPsicologicos;
  final bool certificaInformacion;
  final bool manifiestaResponsabilidad;
  final List<dynamic> copiaCertificadoEps;
  final String autorizaDatosPersonales;
  final String aceptaManualConvivencia;
  final String apellidosDeportista;
  final String tipoDocumentoDeportista;
  final String nombresAcudiente2;
  final String apellidosAcudiente2;
  final String numeroCelularAcudiente2;
  final int numeroDocumentoAcudiente2;
  final String tipoDocumentoAcudiente1;
  final String tipoDocumentoAcudiente2;
  final String correoAcudiente1;
  final String correoAcudiente2;
  final bool debeCambiarClave;
  final int consecutivo;
  final List<String> usuarioBuscado;
  final List<String> usuario2;
  final CreadoPor creadoPor;
  final String tipoFamilia;
  final String discapacidad;
  final DateTime fechaNacimiento;
  final String esVictimaConflicto;
  final String deportesWeb;
  final DateTime creada;
  final List<dynamic>? consentimiento;
  final List<dynamic>? condicionesMedicas;
  final List<dynamic>? alergias;
  final String? nombreMedicamento;
  String status;

  EstudianteDeporte({
    required this.id,
    required this.createdTime,
    required this.idEstudiante,
    required this.nombre,
    required this.documento,
    required this.email,
    required this.activo,
    required this.matriculas,
    required this.deporteDeMatriculas,
    required this.usuario,
    required this.passwordHash,
    required this.identificacion,
    required this.estadoRevision,
    required this.comentarios,
    required this.eps,
    required this.actualizacionDatos,
    required this.nombresAcudiente1,
    required this.apellidosAcudiente1,
    required this.numeroCelularAcudiente1,
    required this.numeroDocumentoAcudiente1,
    required this.lugarExpedicionDocumentoDeportista,
    required this.generoDeportista,
    required this.lugarNacimientoDeportista,
    required this.veredaSectorVivienda,
    required this.direccionResidencia,
    required this.nombreInstitucionEducativa,
    required this.tipoInstitucionEducativa,
    required this.gradoEscolar,
    required this.tipoPoblacion,
    required this.tipoRegimenEps,
    required this.grupoSanguineoRh,
    required this.enfermedadesPrevias,
    required this.cirugiasPrevias,
    required this.tomaMedicamentos,
    required this.lesionesPrevias,
    required this.tratamientosPsicologicos,
    required this.certificaInformacion,
    required this.manifiestaResponsabilidad,
    required this.copiaCertificadoEps,
    required this.autorizaDatosPersonales,
    required this.aceptaManualConvivencia,
    required this.apellidosDeportista,
    required this.tipoDocumentoDeportista,
    required this.nombresAcudiente2,
    required this.apellidosAcudiente2,
    required this.numeroCelularAcudiente2,
    required this.numeroDocumentoAcudiente2,
    required this.tipoDocumentoAcudiente1,
    required this.tipoDocumentoAcudiente2,
    required this.correoAcudiente1,
    required this.correoAcudiente2,
    required this.debeCambiarClave,
    required this.consecutivo,
    required this.usuarioBuscado,
    required this.usuario2,
    required this.creadoPor,
    required this.tipoFamilia,
    required this.discapacidad,
    required this.fechaNacimiento,
    required this.esVictimaConflicto,
    required this.deportesWeb,
    required this.creada,
    this.consentimiento,
    this.condicionesMedicas,
    this.alergias,
    this.nombreMedicamento,
    required this.status,
  });

  factory EstudianteDeporte.fromJson(Map<String, dynamic> json) {
    return EstudianteDeporte(
      id: json['id'] ?? '',
      createdTime: DateTime.parse(json['createdTime'] ?? ''),
      idEstudiante: json['Id_estudiante'] ?? '',
      nombre: json['Nombre'] ?? '',
      documento: json['Documento'] ?? 0,
      email: json['Email'] ?? '',
      activo: json['Activo'] ?? false,
      matriculas: List<String>.from(json['Matriculas'] ?? []),
      deporteDeMatriculas: List<String>.from(json['Deporte (de Matriculas)'] ?? []),
      usuario: List<String>.from(json['Usuario'] ?? []),
      passwordHash: json['Password_hash'] ?? '',
      identificacion: json['Identificacion'] ?? [],
      estadoRevision: json['Estado de revision'] ?? '',
      comentarios: json['Comentarios'] ?? '',
      eps: json['EPS'] ?? '',
      actualizacionDatos: json['Actualizacion de datos'] ?? false,
      nombresAcudiente1: json['NOMBRES DEL ACUDIENTE 1'] ?? '',
      apellidosAcudiente1: json['APELLIDOS DEL ACUDIENTE 1'] ?? '',
      numeroCelularAcudiente1: json['NÚMERO DE CELULAR DEL ACUDIENTE 1'] ?? '',
      numeroDocumentoAcudiente1: json['NÚMERO DE DOCUMENTO DE IDENTIDAD DE ACUDIENTE 1'] ?? 0,
      lugarExpedicionDocumentoDeportista: json['LUGAR DE EXPEDICIÓN DOCUMENTO DE IDENTIDAD DEPORTISTA'] ?? '',
      generoDeportista: json['GENERO DEL DEPORTISTA'] ?? '',
      lugarNacimientoDeportista: json['LUGAR DE NACIMIENTO DEL DEPORTISTA'] ?? '',
      veredaSectorVivienda: json['VEREDA O SECTOR DE VIVIENDA DEL DEPORTISTA'] ?? '',
      direccionResidencia: json['DIRECCIÓN O CONJUNTO DE RESIDENCIA DEL DEPORTISTA'] ?? '',
      nombreInstitucionEducativa: json['NOMBRE DE INSTITUCIÓN EDUCATIVA DEL DEPORTISTA'] ?? '',
      tipoInstitucionEducativa: json['TIPO DE INSTITUCIÓN EDUCATIVA DEL DEPORTISTA'] ?? '',
      gradoEscolar: json['GRADO ESCOLAR DEL DEPORTISTA'] ?? '',
      tipoPoblacion: json['TIPO DE POBLACIÓN'] ?? '',
      tipoRegimenEps: json['TIPO DE RÉGIMEN EPS'] ?? '',
      grupoSanguineoRh: json['GRUPO SANGUINEO RH'] ?? '',
      enfermedadesPrevias: json['ENFERMEDADES PREVIAS'] ?? '',
      cirugiasPrevias: json['CIRUGÍAS PREVIAS'] ?? '',
      tomaMedicamentos: json['TOMA MEDICAMENTOS'] ?? '',
      lesionesPrevias: json['LESIONES PREVIAS'] ?? '',
      tratamientosPsicologicos: json['TRATAMIENTOS PSICOLÓGICOS O PSIQUIATRICOS'] ?? '',
      certificaInformacion:
          json['YO CERTIFICO QUE HE LEÍDO Y DILIGENCIADO CORRECTAMENTE EL CUESTIONARIO Y MIS RESPUESTAS SON VERDADERAS, ASÍ COMO AUTORIZO LA REVISIÓN DE LA INFORMACIÓN POR PARTE DEL IMRD DE COTA.'] ??
              false,
      manifiestaResponsabilidad: json['MANIFIESTO QUE ENTIENDO Y RECONOZCO LA PARTICIPACIÓN DE LA ACTIVIDAD EN MI RESPONSABILIDAD COMO PADRE DE FAMILIA Y/O ACUDIENTE.'] ?? false,
      copiaCertificadoEps: json['COPIA DEL CERTIFICADO DE LA EPS ACTIVO, NO SE ACEPTA CERTIFICADO DE LA PLATAFORMA ADRES '] ?? [],
      autorizaDatosPersonales: json['¿AUTORIZA LA RECOLECCIÓN Y TRATAMIENTO DE DATOS PERSONALES, CONFORME A LA LEY 1581 DE 2012? '] ?? '',
      aceptaManualConvivencia: json['HE LEÍDO Y ACEPTO LAS NORMAS ESTABLECIDAS EN EL MANUAL DE CONVIVENCIA. '] ?? '',
      apellidosDeportista: json['APELLIDOS DEPORTISTA'] ?? '',
      tipoDocumentoDeportista: json['TIPO DE DOCUMENTO DE IDENTIDAD DEL DEPORTISTA'] ?? '',
      nombresAcudiente2: json['NOMBRES DEL ACUDIENTE 2'] ?? '',
      apellidosAcudiente2: json['APELLIDOS DEL ACUDIENTE 2'] ?? '',
      numeroCelularAcudiente2: json['NÚMERO DE CELULAR DEL ACUDIENTE 2'] ?? '',
      numeroDocumentoAcudiente2: json['NÚMERO DE DOCUMENTO DE IDENTIDAD DE ACUDIENTE 2'] ?? 0,
      tipoDocumentoAcudiente1: json['TIPO DE DOCUMENTO DE IDENTIDAD DEL ACUDIENTE 1'] ?? '',
      tipoDocumentoAcudiente2: json['TIPO DE DOCUMENTO DE IDENTIDAD DEL ACUDIENTE 2'] ?? '',
      correoAcudiente1: json['CORREO ELECTRÓNICO ACUDIENTE 1'] ?? '',
      correoAcudiente2: json['CORREO ELECTRÓNICO ACUDIENTE 2'] ?? '',
      debeCambiarClave: json['Debe_cambiar_clave'] ?? false,
      consecutivo: json['Consecutivo'] ?? 0,
      usuarioBuscado: List<String>.from(json['Usuario buscado'] ?? []),
      usuario2: List<String>.from(json['Usuario2'] ?? []),
      creadoPor: CreadoPor.fromJson(json['Creado por'] ?? {}),
      tipoFamilia: json['TIPO DE FAMILIA'] ?? '',
      discapacidad: json['DISCAPACIDAD'] ?? '',
      fechaNacimiento: DateTime.parse(json['Fecha de nacimiento'] ?? ''),
      esVictimaConflicto: json['ES VÍCTIMA DEL CONFLICTO'] ?? '',
      deportesWeb: json['deportesWeb'] ?? '',
      creada: DateTime.parse(json['Creada'] ?? ''),
      consentimiento: json['Consentimiento'],
      condicionesMedicas: json['Condiciones medicas'],
      alergias: json['Alergias'],
      nombreMedicamento: json['NOMBRE DEL MEDICAMENTO'],
      status: json['status'] ?? 'Asistió',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdTime': createdTime.toIso8601String(),
      'Id_estudiante': idEstudiante,
      'Nombre': nombre,
      'Documento': documento,
      'Email': email,
      'Activo': activo,
      'Matriculas': matriculas,
      'Deporte (de Matriculas)': deporteDeMatriculas,
      'Usuario': usuario,
      'Password_hash': passwordHash,
      'Identificacion': identificacion,
      'Estado de revision': estadoRevision,
      'Comentarios': comentarios,
      'EPS': eps,
      'Actualizacion de datos': actualizacionDatos,
      'NOMBRES DEL ACUDIENTE 1': nombresAcudiente1,
      'APELLIDOS DEL ACUDIENTE 1': apellidosAcudiente1,
      'NÚMERO DE CELULAR DEL ACUDIENTE 1': numeroCelularAcudiente1,
      'NÚMERO DE DOCUMENTO DE IDENTIDAD DE ACUDIENTE 1': numeroDocumentoAcudiente1,
      'LUGAR DE EXPEDICIÓN DOCUMENTO DE IDENTIDAD DEPORTISTA': lugarExpedicionDocumentoDeportista,
      'GENERO DEL DEPORTISTA': generoDeportista,
      'LUGAR DE NACIMIENTO DEL DEPORTISTA': lugarNacimientoDeportista,
      'VEREDA O SECTOR DE VIVIENDA DEL DEPORTISTA': veredaSectorVivienda,
      'DIRECCIÓN O CONJUNTO DE RESIDENCIA DEL DEPORTISTA': direccionResidencia,
      'NOMBRE DE INSTITUCIÓN EDUCATIVA DEL DEPORTISTA': nombreInstitucionEducativa,
      'TIPO DE INSTITUCIÓN EDUCATIVA DEL DEPORTISTA': tipoInstitucionEducativa,
      'GRADO ESCOLAR DEL DEPORTISTA': gradoEscolar,
      'TIPO DE POBLACIÓN': tipoPoblacion,
      'TIPO DE RÉGIMEN EPS': tipoRegimenEps,
      'GRUPO SANGUINEO RH': grupoSanguineoRh,
      'ENFERMEDADES PREVIAS': enfermedadesPrevias,
      'CIRUGÍAS PREVIAS': cirugiasPrevias,
      'TOMA MEDICAMENTOS': tomaMedicamentos,
      'LESIONES PREVIAS': lesionesPrevias,
      'TRATAMIENTOS PSICOLÓGICOS O PSIQUIATRICOS': tratamientosPsicologicos,
      'YO CERTIFICO QUE HE LEÍDO Y DILIGENCIADO CORRECTAMENTE EL CUESTIONARIO Y MIS RESPUESTAS SON VERDADERAS, ASÍ COMO AUTORIZO LA REVISIÓN DE LA INFORMACIÓN POR PARTE DEL IMRD DE COTA.':
          certificaInformacion,
      'MANIFIESTO QUE ENTIENDO Y RECONOZCO LA PARTICIPACIÓN DE LA ACTIVIDAD EN MI RESPONSABILIDAD COMO PADRE DE FAMILIA Y/O ACUDIENTE.': manifiestaResponsabilidad,
      'COPIA DEL CERTIFICADO DE LA EPS ACTIVO, NO SE ACEPTA CERTIFICADO DE LA PLATAFORMA ADRES ': copiaCertificadoEps,
      '¿AUTORIZA LA RECOLECCIÓN Y TRATAMIENTO DE DATOS PERSONALES, CONFORME A LA LEY 1581 DE 2012? ': autorizaDatosPersonales,
      'HE LEÍDO Y ACEPTO LAS NORMAS ESTABLECIDAS EN EL MANUAL DE CONVIVENCIA. ': aceptaManualConvivencia,
      'APELLIDOS DEPORTISTA': apellidosDeportista,
      'TIPO DE DOCUMENTO DE IDENTIDAD DEL DEPORTISTA': tipoDocumentoDeportista,
      'NOMBRES DEL ACUDIENTE 2': nombresAcudiente2,
      'APELLIDOS DEL ACUDIENTE 2': apellidosAcudiente2,
      'NÚMERO DE CELULAR DEL ACUDIENTE 2': numeroCelularAcudiente2,
      'NÚMERO DE DOCUMENTO DE IDENTIDAD DE ACUDIENTE 2': numeroDocumentoAcudiente2,
      'TIPO DE DOCUMENTO DE IDENTIDAD DEL ACUDIENTE 1': tipoDocumentoAcudiente1,
      'TIPO DE DOCUMENTO DE IDENTIDAD DEL ACUDIENTE 2': tipoDocumentoAcudiente2,
      'CORREO ELECTRÓNICO ACUDIENTE 1': correoAcudiente1,
      'CORREO ELECTRÓNICO ACUDIENTE 2': correoAcudiente2,
      'Debe_cambiar_clave': debeCambiarClave,
      'Consecutivo': consecutivo,
      'Usuario buscado': usuarioBuscado,
      'Usuario2': usuario2,
      'Creado por': creadoPor.toJson(),
      'TIPO DE FAMILIA': tipoFamilia,
      'DISCAPACIDAD': discapacidad,
      'Fecha de nacimiento': fechaNacimiento.toIso8601String(),
      'ES VÍCTIMA DEL CONFLICTO': esVictimaConflicto,
      'deportesWeb': deportesWeb,
      'Creada': creada.toIso8601String(),
      'status': status
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}

// Modelo para Asistencia
class Asistencia {
  final String documento;
  final String nombre;
  final String status;
  final String matricula;
  final String codigoDeporte;

  Asistencia({
    required this.documento,
    required this.nombre,
    required this.status,
    required this.matricula,
    required this.codigoDeporte,
  });

  Map<String, dynamic> toJson() => {
        'documento': documento,
        'nombre': nombre,
        'status': status,
        'matricula': matricula,
        'codigo_deporte': codigoDeporte,
      };
}

// Modelo para la petición completa
class AsistenciaRequest {
  final String idDeporte;
  final String idProfesor;
  final String observaciones;
  final String lugar;
  final String fecha;
  final List<Asistencia> asistencias;

  AsistenciaRequest({
    required this.idDeporte,
    required this.idProfesor,
    required this.observaciones,
    required this.lugar,
    required this.fecha,
    required this.asistencias,
  });

  Map<String, dynamic> toJson() => {
        'id_deporte': idDeporte,
        'id_profesor': idProfesor,
        'observaciones': observaciones,
        'lugar': lugar,
        'fecha': fecha,
        'asistencias': asistencias.map((a) => a.toJson()).toList(),
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

  Future<List<DeporteProfesor>> verDeportesProfesor(String idProfesor) async {
    String baseUrl = AppConfig.instance.parametros['urldeportesprofesor'];
    try {
      // Validar que el idProfesor no sea nulo o vacío
      if (idProfesor.isEmpty) {
        throw ArgumentError('El id del profesor no puede estar vacío');
      }

      // Preparar el cuerpo de la petición
      final Map<String, dynamic> requestBody = {
        'id_profesor': idProfesor,
      };

      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Verificar el código de respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Convertir cada elemento de la lista a un objeto Deporte
        final List<DeporteProfesor> deportes = jsonResponse.map((deporteJson) => DeporteProfesor.fromJson(deporteJson as Map<String, dynamic>)).toList();

        return deportes;
      } else {
        // Manejar errores HTTP
        throw Exception('Error al consultar deportes: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Re-lanzar la excepción para que el llamador la maneje
      throw Exception('Error en la consulta de deportes: $e');
    }
  }

  Future<String?> consultarAsistenciaCSV({
    required String idDeporte,
  }) async {
    try {
      final String urlVerAsistenciaEstudiante = AppConfig.instance.parametros['urlprofesorVerAsistencia'];
      final respuesta = await http.post(
        Uri.parse(urlVerAsistenciaEstudiante),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'id_deporte': idDeporte,
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

  Future<List<EstudianteDeporte>> consultarEstudiantesDeporte(String idDeporte) async {
    String url = AppConfig.instance.parametros['urlprofesorVerEstudiantesDeporte'];
    try {
      // Crear el cuerpo de la petición
      final Map<String, dynamic> requestBody = {
        'id_deporte': idDeporte,
      };

      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Verificar el código de respuesta
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Convertir cada elemento de la lista a un objeto Estudiante
        final List<EstudianteDeporte> estudiantes = jsonResponse.map((estudianteJson) => EstudianteDeporte.fromJson(estudianteJson)).toList();

        return estudiantes;
      } else {
        print('error consumiendo $url : codigo diferente a 200');
        // Si hay error en la respuesta
        return [];
      }
    } catch (e) {
      // Manejar errores de conexión o parsing
      print('error consumiendo $url : $e');
      return [];
    }
  }

  Future<bool> enviarComunicado({
    required String idDeporte,
    required String titulo,
    required String mensaje,
  }) async {
    try {
      // Crear el cuerpo de la petición
      final Map<String, dynamic> requestBody = {
        'id_deporte': idDeporte,
        'titulo': titulo,
        'mensaje': mensaje,
      };

      // Realizar la petición POST
      final response = await http
          .post(
        Uri.parse(AppConfig.instance.parametros['urlprofesorEnviarComunicados']),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          // Si hay timeout, retornamos una respuesta vacía con código 408 (Request Timeout)
          return http.Response('Error: Timeout', 408);
        },
      );

      // Retornar true si el código es 200, false en cualquier otro caso
      return response.statusCode == 200;
    } catch (e) {
      // En caso de error (sin conexión, etc.), retornamos false
      print('Error al enviar comunicado: $e');
      return false;
    }
  }

  Future<bool> llenarAsistencia(AsistenciaRequest request) async {
    final url = Uri.parse(AppConfig.instance.parametros['urlprofesorLlenarAsistencia']);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error al enviar la asistencia: $e');
      return false;
    }
  }
}
