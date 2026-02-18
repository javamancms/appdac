import 'dart:io';

import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intestudiantes.dart';
import 'package:appdac/config/log.dart';
import 'package:flutter/material.dart';

class ControlListaDeportes extends ChangeNotifier {
  static List<DeporteEstudiante> deportes = [];
  DeporteEstudiante? seleccionado;
  static bool recargado = false;

  void cargarDeportes(String idEstudiante) async {
    print('cargarDeportes...');
    if ((deportes.isEmpty) && (!recargado)) {
      recargado = true;
      RespuestaDeportesEstudiante rdeportes = await ClienteEstudiantes().consultarDeportes(idEstudiante);
      deportes.addAll(rdeportes.deportes ?? []);
      print('deportes cargados ${deportes.length}');
      notifyListeners();
    }
  }

  static void vaciarDeportes() {
    deportes.clear();
    recargado = false;
  }

  void seleccionarDeporte(DeporteEstudiante deporte) {
    seleccionado = deporte;
    notifyListeners();
  }
}

class ControlAsistencia extends ChangeNotifier {
  String asistencia = '';

  Future<String> cargarAsistencia(String idDeporte, idEstudiante) async {
    asistencia = await ClienteEstudiantes().consultarAsistenciaCSV(idDeporte: idDeporte, idEstudiante: idEstudiante) ?? '';
    notifyListeners();
    return asistencia;
  }
}

class ControlActualizarDocumentos extends ChangeNotifier {
  void enviarDocumentacion(String idEstudiante, File documento, File eps, File consentimiento) async {
    Map<String, dynamic> resultado = await ClienteEstudiantes.enviarDocumentacion(idEstudiante, documento, eps, consentimiento);
    notifyListeners();
  }
}

class ControlComunicados extends ChangeNotifier {
  String comunicados = '';

  Future<String> cargarComunicados(String idDeporte) async {
    comunicados = await ClienteEstudiantes().consultarComunicadosCSV(idDeporte: idDeporte) ?? '';

    notifyListeners();

    return comunicados;
  }
}

class ControlInscribirDeportes extends ChangeNotifier {
  List<Deporte> deportes = [];

  Future<void> cargarDeportes(String idEstudiante) async {
    DeportesResponse respuesta = await ClienteEstudiantes.consultarDeportesDisponibles(idEstudiante);
    deportes = respuesta.deportes;

    notifyListeners();
  }

  void actualizarDeporte(int index, bool existe) {
    // Verificar que no se supere el límite de 3
    if (existe) {
      final actualInscritos = deportes.where((d) => d.existe).length;
      if (actualInscritos >= 3) {
        return; // No permitir más de 3
      }
    }

    // Crear una nueva lista actualizada
    deportes[index] = Deporte(
      nombreDeporte: deportes[index].nombreDeporte,
      existe: existe,
    );

    notifyListeners();
  }

  static Future<bool> actualizarInscripcion(BuildContext context, List<Deporte> deportes) async {
    return await ClienteEstudiantes.actualizarInscripcionEstudiante(idEstudiante: ControlSesion.datosusuario!.idUsuario, deportes: deportes);
  }

  static Future<bool> actualizarInscripcionDesdeAdministrador(BuildContext context, String idEstudiante, List<Deporte> deportes) async {
    return await ClienteEstudiantes.actualizarInscripcionEstudiante(idEstudiante: idEstudiante, deportes: deportes);
  }
}

class ControlListaEstudiantesAdministrador extends ChangeNotifier {
  List<Estudiante> estudiantes = [];

  void cargarEstudiantes() async {
    if (estudiantes.isEmpty) {
      estudiantes = await ClienteEstudiantes().consultarEstudiantes();
      logear('estudiantes: ${estudiantes.length}');
      notifyListeners();
    }
  }

  Future<void> cambiarEstadoEstudiante(String codigoEstudiante) async {
    Estudiante modificado = estudiantes.firstWhere(
      (analizado) => analizado.idEstudiante == codigoEstudiante,
    );
    modificado.activo = !modificado.activo;
    
    logear('cambiando estado estudiante ${await ClienteEstudiantes().cambiarEstado(codigoEstudiante)}');

    notifyListeners();
  }

  void cambiarEstadoDeRevisionEstudiante(String idEstudiante, String estadoRevision, {String comentario = ''}) async {
    print('-->> CAMBIAR ESTADO ESTUDIANTE respuesta=${await ClienteEstudiantes().cambiarEstadoRevision(idEstudiante: idEstudiante, estadoRevision: estadoRevision, comentario: comentario)}');
  }
}
