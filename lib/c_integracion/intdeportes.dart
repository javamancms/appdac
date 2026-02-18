import 'dart:convert';
import 'package:appdac/config/app_config.dart';
import 'package:http/http.dart' as http;

class Deporte {
  final String idDeporte;
  final String nombreDeporte;
  final bool ofrecidoALosPadres;
  final int cantidadEstudiantesPermitidos;
  final int edadMinima;
  final int edadMaxima;

  Deporte({
    required this.idDeporte,
    required this.nombreDeporte,
    required this.ofrecidoALosPadres,
    required this.cantidadEstudiantesPermitidos,
    required this.edadMinima,
    required this.edadMaxima,
  });

  factory Deporte.fromJson(Map<String, dynamic> json) {
    return Deporte(
      idDeporte: json['id_deporte'] ?? '',
      nombreDeporte: json['nombre_deporte'] ?? '',
      ofrecidoALosPadres: json['ofrecido_a_los_padres'] ?? false,
      cantidadEstudiantesPermitidos: json['cantidad_estudiantes_permitidos'] ?? 0,
      edadMinima: json['edad_minima'] ?? 0,
      edadMaxima: json['edad_maxima'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_deporte': idDeporte,
    'nombre_deporte': nombreDeporte,
    'ofrecido_a_los_padres': ofrecidoALosPadres,
    'cantidad_estudiantes_permitidos': cantidadEstudiantesPermitidos,
    'edad_minima': edadMinima,
    'edad_maxima': edadMaxima,
  };

  @override
  String toString() {
    return 'Deporte{id: $idDeporte, nombre: $nombreDeporte, edad: $edadMinima-$edadMaxima}';
  }
}

class RespuestaDeportes {
  final bool ok;
  final List<Deporte> deportes;
  final String? mensaje;
  final int? statusCode;

  RespuestaDeportes({
    required this.ok,
    required this.deportes,
    this.mensaje,
    this.statusCode,
  });

  factory RespuestaDeportes.fromJson(Map<String, dynamic> json) {
    final deportesList = json['deportes'] as List? ?? [];
    
    return RespuestaDeportes(
      ok: json['ok'] ?? false,
      deportes: deportesList.map((item) => Deporte.fromJson(item)).toList(),
    );
  }

  factory RespuestaDeportes.error({String? mensaje, int? statusCode}) {
    return RespuestaDeportes(
      ok: false,
      deportes: [],
      mensaje: mensaje,
      statusCode: statusCode,
    );
  }
}



class ServicioDeportes {
  
  

  /// Consulta la lista de deportes para un administrador
  /// Retorna un objeto RespuestaDeportes con la lista de deportes o error
  Future<RespuestaDeportes> consultarDeportes(String idAdministrador) async {
    String urlDeportes = AppConfig.instance.parametros['urlconsultardeportes'];
    try {
      final requestBody = {
        "id_administrador": idAdministrador,
      };
      
     

      final respuesta = await http.post(
        Uri.parse(urlDeportes),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Respuesta status: ${respuesta.statusCode}');
      print('📥 Respuesta body: ${respuesta.body}');

      // Verificar el código de respuesta
      if (respuesta.statusCode == 200) {
        final Map<String, dynamic> datos = jsonDecode(respuesta.body);
        
        if (datos['ok'] == true) {
          final deportes = RespuestaDeportes.fromJson(datos);
          print('✅ Deportes cargados: ${deportes.deportes.length}');
          return deportes;
        } else {
          return RespuestaDeportes.error(
            mensaje: 'El servicio respondió con ok: false',
            statusCode: respuesta.statusCode,
          );
        }
      } else if (respuesta.statusCode == 401) {
        return RespuestaDeportes.error(
          mensaje: 'No autorizado. Verifique el ID del administrador',
          statusCode: respuesta.statusCode,
        );
      } else {
        return RespuestaDeportes.error(
          mensaje: 'Error del servidor (${respuesta.statusCode})',
          statusCode: respuesta.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      return RespuestaDeportes.error(
        mensaje: 'Error de conexión: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<bool> modificarDeporte({
    required String tipo,
    required String idDeporte,
    required int cantidadEstudiantesPermitidos,
    required bool ofrecidoALosPadres,
    required int edadMinima,
    required int edadMaxima,
  }) async {
    String url = AppConfig.instance.parametros['urlmodificardeporte'];
    try {
      // Construir el cuerpo de la petición
      final Map<String, dynamic> requestBody = {
        "tipo": tipo,
        "id_deporte": idDeporte,
        "cantidad_estudiantes_permitidos": cantidadEstudiantesPermitidos,
        "ofrecido_a_los_padres": ofrecidoALosPadres,
        "edad_minima": edadMinima,
        "edad_maxima": edadMaxima,
      };

      print('📤 Enviando solicitud a: $url');
      print('📦 Body: $requestBody');

      final respuesta = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Respuesta status: ${respuesta.statusCode}');
      
      // Verificar si la respuesta es exitosa (código 200)
      if (respuesta.statusCode == 200) {
        print('✅ Deporte actualizado exitosamente');
        return true;
      } else {
        print('❌ Error al actualizar deporte. Código: ${respuesta.statusCode}');
        return false;
      }
    } catch (e) {
      // Error de conexión u otro error
      print('❌ Error de conexión: ${e.toString()}');
      return false;
    }
  }

}