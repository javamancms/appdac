import 'package:appdac/a_presentacion/widgetspersonalizados/panelprofesorlista.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaProfesoresScreen extends StatelessWidget {
  const ListaProfesoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaProfesores controllistaprofesores = context.watch<ControlListaProfesores>();

    List<ProfesorCard> lprofesores = [];
    for (Profesor profesor in controllistaprofesores.profesores) {
      lprofesores.add(ProfesorCard(
        icon: Icons.person,
        profesor: profesor,
        /*onActivoChanged: (value) async {
          logear('click ${profesor.idProfesor}');
          controllistaprofesores.cambiarEstadoProfesor(profesor.idProfesor);
          controllistaprofesores.cargarProfesores(ControlSesion.datosusuario!.idUsuario);
        },*/
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Profesores'),
      ),
      body: Column(
        children: lprofesores,
      ),
    );
  }
}
