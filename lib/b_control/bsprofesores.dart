import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ControlListaProfesores extends ChangeNotifier {
  List<Profesor> profesores = [];

  Future<void> cargarProfesores(String idAdministrador) async {
    profesores.clear();
    RespuestaProfesores rprofesores = await ClienteProfesores().consultarProfesores(idAdministrador);
    print('xxxxxx');
    print(rprofesores.profesores);
    if (rprofesores.profesores != null) {
      for (Profesor profesor in rprofesores.profesores!) {
        profesores.add(profesor);
      }
      notifyListeners();
    }
  }

  Future<void> cambiarEstadoProfesor(String codigoProfesor) async {
    await ClienteProfesores().cambiarEstado(codigoProfesor);
    //notifyListeners();
  }

  Future<bool> asignarDeportesAProfesor(String tipo, String idprofesor, List<Deporte> deportes) async {
    List<String> nombresdeportes = [];
    for (Deporte deporte in deportes) {
      nombresdeportes.add(deporte.nombreDeporte);
    }

    return await ClienteProfesores().asignarDeportesAProfesor(tipo: tipo, idProfesor: idprofesor, nombreDeporte: nombresdeportes);

    //await ClienteProfesores().cambiarEstado(codigoProfesor);
    //notifyListeners();
  }
}

class ControlAsistenciaProfesor extends ChangeNotifier {
  String asistencia = '';

  Future<String> cargarAsistencia(String idDeporte) async {
    asistencia = await ClienteProfesores().consultarAsistenciaCSV(idDeporte: idDeporte) ?? '';
    notifyListeners();
    return asistencia;
  }
}

class ControlListaDeporte extends ChangeNotifier {
  List<EstudianteDeporte> estudiantes = [];

  Future<void> cargarEstudiantes(String idDeporte) async {
    estudiantes = await ClienteProfesores().consultarEstudiantesDeporte(idDeporte);
    notifyListeners();
  }

  Future<void> guardarAsistencia(BuildContext context, String idDeporte, String idProfesor, String observaciones, String lugar, List<EstudianteDeporte> estudiantes) async {

    List<Asistencia> lasistencia=[];
    for (var estudiante in estudiantes) {
      lasistencia.add(Asistencia(
        documento: '${estudiante.documento}', 
        nombre: estudiante.nombre, 
        status: estudiante.status, 
        matricula: estudiante.matriculas[0], 
        codigoDeporte: idDeporte
      ));
    }

    DateTime ahora = DateTime.now();
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(ahora);

    AsistenciaRequest asistencia=AsistenciaRequest(idDeporte: idDeporte,idProfesor: idProfesor,lugar: lugar, observaciones: observaciones,fecha: fechaFormateada, asistencias: lasistencia);
    if(await ClienteProfesores().llenarAsistencia(asistencia)){
      mostrarMensajeInferior(context, 'Asistencia registrada',colorFondo: AppColors.verde, colorFuente: AppColors.blanco);
    }else{
      mostrarMensajeInferior(context, 'Asistencia registrada',colorFondo: AppColors.rojo, colorFuente: AppColors.negro);
    }
  }
}

class ControlComunicadosProfesores extends ChangeNotifier {
  Future<void> enviarComunicado(BuildContext context, String idDeporte, String titulo, String mensaje) async {
    if (await ClienteProfesores().enviarComunicado(idDeporte: idDeporte, titulo: titulo, mensaje: mensaje)) {
      mostrarMensajeInferior(context, S.of(context).msj_enviocomunicadoexitoso, colorFondo: AppColors.verde, colorFuente: AppColors.blanco);
    } else {
      mostrarMensajeInferior(context, S.of(context).msj_enviocomunicadoerror, colorFondo: AppColors.rojo, colorFuente: AppColors.blanco);
    }
  }
}
