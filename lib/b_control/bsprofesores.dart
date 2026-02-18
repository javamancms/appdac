import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:flutter/material.dart';

class ControlListaProfesores extends ChangeNotifier {
  List<Profesor> profesores = [];

  Future<void> cargarProfesores(String idAdministrador) async {
    profesores.clear();
    RespuestaProfesores rprofesores = await ClienteProfesores().consultarProfesores(idAdministrador);
    for (Profesor profesor in rprofesores.profesores!) {
      profesores.add(profesor);
    }
    notifyListeners();
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
