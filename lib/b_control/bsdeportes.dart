import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:flutter/material.dart';

class ControlListaDeportesAdministrador extends ChangeNotifier {
  List<Deporte> deportes = [];

  void cargarListaDeportes() async {
    if (deportes.isEmpty) {
      deportes = (await ServicioDeportes().consultarDeportes(ControlSesion.datosusuario!.idUsuario)).deportes;
      notifyListeners();
    }
  }

  Future<bool> modificarDeporte(String tipo, String idDeporte, int cantidadEstudiantesPermitidos, bool ofrecidoALosPadres, int edadMinima, int edadMaxima) async {
    bool resultado = await ServicioDeportes().modificarDeporte(
        tipo: tipo, idDeporte: idDeporte, cantidadEstudiantesPermitidos: cantidadEstudiantesPermitidos, ofrecidoALosPadres: ofrecidoALosPadres, edadMinima: edadMinima, edadMaxima: edadMaxima);
    deportes.clear();
    cargarListaDeportes();
    return resultado;
  }
}
