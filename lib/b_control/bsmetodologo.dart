import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/c_integracion/intmetodologo.dart';
import 'package:appdac/config/log.dart';
import 'package:appdac/generated/l10n.dart';
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

class ControlListaDeportesMetodologos extends ChangeNotifier {
  List<Deporte> deportes = [];
  Future<void> verDeportes(String idMetodologo) async {
    if (deportes.isEmpty) {
      deportes = await consultarDeportesMetodologo(idMetodologo);
      notifyListeners();
    }
  }
}

class ControlVerDocumentoAsistencia extends ChangeNotifier {

  Future<DocumentoAsistenciaResponse> verDocumentosAsistencia(String idDeporte) async {
    DocumentoAsistenciaResponse documentoasistencia = await verDocumentoAsistencia(idDeporte);
    return documentoasistencia;
  }
  
}

class ControlComentarios extends ChangeNotifier {

  Future<void> enviarComentarioCurso(BuildContext context, String idDeporte, String comentario) async {
      if(await enviarComentario(idDeporte, comentario)){
        mostrarMensajeInferior(context, S.of(context).msj_mensajeenviadoexito, colorFondo: AppColors.verde, colorFuente: AppColors.blanco);
      }else{
        mostrarMensajeInferior(context, S.of(context).msj_mensajeenviadoerror, colorFondo: AppColors.rojo, colorFuente: AppColors.blanco);
      }
    
  }
  
}

