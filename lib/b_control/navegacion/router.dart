//mport 'package:control_recibos/integracion/dto/request_dto.dart';

import 'package:appdac/a_presentacion/administrador/guiadministrador.dart';
import 'package:appdac/a_presentacion/administrador/guiverdeportes.dart';
import 'package:appdac/a_presentacion/administrador/guiverestudiantes.dart';
import 'package:appdac/a_presentacion/administrador/guivermetodologos.dart';
import 'package:appdac/a_presentacion/administrador/guiverprofesores.dart';
import 'package:appdac/a_presentacion/estudiante/guiasistencia.dart';
import 'package:appdac/a_presentacion/estudiante/guicomunicados.dart';
import 'package:appdac/a_presentacion/estudiante/guiestudiante.dart';
import 'package:appdac/a_presentacion/estudiante/guihorario.dart';
import 'package:appdac/a_presentacion/estudiante/guiopcionesestudiantes.dart';
import 'package:appdac/a_presentacion/guilogin.dart';
import 'package:appdac/a_presentacion/metodologo/guimetodologo.dart';
import 'package:appdac/a_presentacion/profesor/guiprofesor.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: "Login",
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/Administrador',
      name: "Administrador",
      builder: (context, state) => AdministradorScreen(),
    ),
    
    
    GoRoute(
      path: '/Metodologo',
      name: "Metodologo",
      builder: (context, state) => MetodologoScreen(),
    ),
    GoRoute(
      path: '/Profesor',
      name: "Profesor",
      builder: (context, state) => ProfesorScreen(),
    ),
    GoRoute(
      path: '/VerProfesoresAdministrador',
      name: "VerProfesoresAdministrador",
      builder: (context, state) => ListaProfesoresScreen(),
    ),
    GoRoute(
      path: '/Estudiante',
      name: "Estudiante",
      builder: (context, state) => EstudianteScreen(),
    ),
    GoRoute(
      path: '/OpcionesEstudiante',
      name: "OpcionesEstudiante",
      builder: (context, state) => OpcionesEstudianteScreen(),
    ),
    GoRoute(
      path: '/VerAsistenciaEstudiante',
      name: "VerAsistenciaEstudiante",
      builder: (context, state) => AsistenciaScreen(),
    ),
    GoRoute(
      path: '/VerComunicadosEstudiante',
      name: "VerComunicadosEstudiante",
      builder: (context, state) => ComunicadosScreen(),
    ),
    GoRoute(
      path: '/VerHorario',
      name: "VerHorario",
      builder: (context, state) => HorarioScreen(),
    ),
    GoRoute(
      path: '/VerDeportesAdministrador',
      name: "VerDeportesAdministrador",
      builder: (context, state) => DeportesScreen(),
    ),
    GoRoute(
      path: '/VerEstudiantesAdministrador',
      name: "VerEstudiantesAdministrador",
      builder: (context, state) => EstudiantesScreen(),
    ),
    GoRoute(
      path: '/VerMetodologosAdministrador',
      name: "VerMetodologosAdministrador",
      builder: (context, state) => MetodologosScreen(),
    ),
  ],
);
