import 'package:appdac/c_integracion/intmetodologo.dart';
import 'package:appdac/config/log.dart';
import 'package:flutter/material.dart';

class ControlListaMetodologos extends ChangeNotifier {
  List<Metodologo> metodologos = [];

  void cargarMetodologos(String idAdministrador) async {
    if (metodologos.isEmpty) {
      metodologos = await ClienteMetodologo().consultarMetodologos(idAdministrador);
      notifyListeners();
    }
  }

  Future<void> cambiarEstadoMetodologo(String codigoMetodologo) async {
    Metodologo modificado = metodologos.firstWhere(
      (analizado) => analizado.idMetodologo == codigoMetodologo,
    );
    modificado.activo = !modificado.activo;
    
    logear('-->> CAMBIAR ESTADO METODOLOGO ${await ClienteMetodologo().cambiarEstado(codigoMetodologo)}');
    
    notifyListeners();
  }

}
