// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Bienvenido`
  String get label_bienvenido {
    return Intl.message(
      'Bienvenido',
      name: 'label_bienvenido',
      desc: '',
      args: [],
    );
  }

  /// `usuario`
  String get label_usuario {
    return Intl.message('usuario', name: 'label_usuario', desc: '', args: []);
  }

  /// `clave`
  String get label_clave {
    return Intl.message('clave', name: 'label_clave', desc: '', args: []);
  }

  /// `Iniciar Sesion`
  String get label_boton_login {
    return Intl.message(
      'Iniciar Sesion',
      name: 'label_boton_login',
      desc: '',
      args: [],
    );
  }

  /// `¿Olvidaste tu contraseña`
  String get label_link_olvidaste_contrasena {
    return Intl.message(
      '¿Olvidaste tu contraseña',
      name: 'label_link_olvidaste_contrasena',
      desc: '',
      args: [],
    );
  }

  /// `Quiero Inscribirme`
  String get label_link_quiero_inscribirme {
    return Intl.message(
      'Quiero Inscribirme',
      name: 'label_link_quiero_inscribirme',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa tu correo electrónico para inscribirte`
  String get label_link_quiero_inscribirmeexp {
    return Intl.message(
      'Ingresa tu correo electrónico para inscribirte',
      name: 'label_link_quiero_inscribirmeexp',
      desc: '',
      args: [],
    );
  }

  /// `Enviar`
  String get label_enviar {
    return Intl.message('Enviar', name: 'label_enviar', desc: '', args: []);
  }

  /// `Cancelar`
  String get label_cancelar {
    return Intl.message('Cancelar', name: 'label_cancelar', desc: '', args: []);
  }

  /// `Guardar`
  String get label_guardar {
    return Intl.message('Guardar', name: 'label_guardar', desc: '', args: []);
  }

  /// `Ingrese su usuario para recuperar la contraseña`
  String get label_recuperarcontrasenaexp {
    return Intl.message(
      'Ingrese su usuario para recuperar la contraseña',
      name: 'label_recuperarcontrasenaexp',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar Contraseña`
  String get label_recuperarcontrasena {
    return Intl.message(
      'Recuperar Contraseña',
      name: 'label_recuperarcontrasena',
      desc: '',
      args: [],
    );
  }

  /// `Ejemplo: juan.perez`
  String get label_ejemplo_usuario {
    return Intl.message(
      'Ejemplo: juan.perez',
      name: 'label_ejemplo_usuario',
      desc: '',
      args: [],
    );
  }

  /// `Por favor ingrese su usuario`
  String get label_ingrese_usuario {
    return Intl.message(
      'Por favor ingrese su usuario',
      name: 'label_ingrese_usuario',
      desc: '',
      args: [],
    );
  }

  /// `Administrador`
  String get label_perfil_administrador {
    return Intl.message(
      'Administrador',
      name: 'label_perfil_administrador',
      desc: '',
      args: [],
    );
  }

  /// `Profesores`
  String get label_profesores {
    return Intl.message(
      'Profesores',
      name: 'label_profesores',
      desc: '',
      args: [],
    );
  }

  /// `Deportes`
  String get label_deportes {
    return Intl.message('Deportes', name: 'label_deportes', desc: '', args: []);
  }

  /// `Deporte`
  String get label_deporte {
    return Intl.message('Deporte', name: 'label_deporte', desc: '', args: []);
  }

  /// `Estudiantes`
  String get label_estudiantes {
    return Intl.message(
      'Estudiantes',
      name: 'label_estudiantes',
      desc: '',
      args: [],
    );
  }

  /// `Metodologos`
  String get label_metodologos {
    return Intl.message(
      'Metodologos',
      name: 'label_metodologos',
      desc: '',
      args: [],
    );
  }

  /// `Actualizar Documentos`
  String get label_tituloactudocs {
    return Intl.message(
      'Actualizar Documentos',
      name: 'label_tituloactudocs',
      desc: '',
      args: [],
    );
  }

  /// `Documentación requerida`
  String get label_docrequerida {
    return Intl.message(
      'Documentación requerida',
      name: 'label_docrequerida',
      desc: '',
      args: [],
    );
  }

  /// `Suba los siguientes documentos en formato PDF`
  String get label_subdocspdf {
    return Intl.message(
      'Suba los siguientes documentos en formato PDF',
      name: 'label_subdocspdf',
      desc: '',
      args: [],
    );
  }

  /// `Archivo Documento`
  String get label_arcdocumento {
    return Intl.message(
      'Archivo Documento',
      name: 'label_arcdocumento',
      desc: '',
      args: [],
    );
  }

  /// `Certificado de la EPS`
  String get label_certeps {
    return Intl.message(
      'Certificado de la EPS',
      name: 'label_certeps',
      desc: '',
      args: [],
    );
  }

  /// `Consentimiento Informado`
  String get label_consentimiento {
    return Intl.message(
      'Consentimiento Informado',
      name: 'label_consentimiento',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar PDF`
  String get label_selectpdf {
    return Intl.message(
      'Seleccionar PDF',
      name: 'label_selectpdf',
      desc: '',
      args: [],
    );
  }

  /// `Estudiante`
  String get label_estudiante {
    return Intl.message(
      'Estudiante',
      name: 'label_estudiante',
      desc: '',
      args: [],
    );
  }

  /// `Curso`
  String get label_curso {
    return Intl.message('Curso', name: 'label_curso', desc: '', args: []);
  }

  /// `Ver historial de asistencias`
  String get label_verhistorialdeasistencias {
    return Intl.message(
      'Ver historial de asistencias',
      name: 'label_verhistorialdeasistencias',
      desc: '',
      args: [],
    );
  }

  /// `Comunicados`
  String get label_comunicados {
    return Intl.message(
      'Comunicados',
      name: 'label_comunicados',
      desc: '',
      args: [],
    );
  }

  /// `Ver anuncios grupo`
  String get label_veranunciosgrupo {
    return Intl.message(
      'Ver anuncios grupo',
      name: 'label_veranunciosgrupo',
      desc: '',
      args: [],
    );
  }

  /// `Historial de Asistencias`
  String get label_histasistencias {
    return Intl.message(
      'Historial de Asistencias',
      name: 'label_histasistencias',
      desc: '',
      args: [],
    );
  }

  /// `Título`
  String get label_titulo {
    return Intl.message('Título', name: 'label_titulo', desc: '', args: []);
  }

  /// `Mensaje`
  String get label_mensaje {
    return Intl.message('Mensaje', name: 'label_mensaje', desc: '', args: []);
  }

  /// `Inscribir Deportes`
  String get label_insdeportes {
    return Intl.message(
      'Inscribir Deportes',
      name: 'label_insdeportes',
      desc: '',
      args: [],
    );
  }

  /// `Deportes disponibles:`
  String get label_deportesdisponibles {
    return Intl.message(
      'Deportes disponibles:',
      name: 'label_deportesdisponibles',
      desc: '',
      args: [],
    );
  }

  /// `SELECCIONAR`
  String get label_seleccionar {
    return Intl.message(
      'SELECCIONAR',
      name: 'label_seleccionar',
      desc: '',
      args: [],
    );
  }

  /// `INSCRITO`
  String get label_yainscrito {
    return Intl.message(
      'INSCRITO',
      name: 'label_yainscrito',
      desc: '',
      args: [],
    );
  }

  /// `seleccionados`
  String get label_seleccionados {
    return Intl.message(
      'seleccionados',
      name: 'label_seleccionados',
      desc: '',
      args: [],
    );
  }

  /// `Mis Deportes`
  String get label_titmisdeportes {
    return Intl.message(
      'Mis Deportes',
      name: 'label_titmisdeportes',
      desc: '',
      args: [],
    );
  }

  /// `Horarios`
  String get label_horario {
    return Intl.message('Horarios', name: 'label_horario', desc: '', args: []);
  }

  /// `Consultar horario`
  String get label_horarioexp {
    return Intl.message(
      'Consultar horario',
      name: 'label_horarioexp',
      desc: '',
      args: [],
    );
  }

  /// `No hay horario`
  String get label_nohorario {
    return Intl.message(
      'No hay horario',
      name: 'label_nohorario',
      desc: '',
      args: [],
    );
  }

  /// `Horarios por definir`
  String get label_nohorarioexp {
    return Intl.message(
      'Horarios por definir',
      name: 'label_nohorarioexp',
      desc: '',
      args: [],
    );
  }

  /// `Enviar comunicados`
  String get label_enviarcomunicados {
    return Intl.message(
      'Enviar comunicados',
      name: 'label_enviarcomunicados',
      desc: '',
      args: [],
    );
  }

  /// `Lista de Estudiantes`
  String get label_listaestudiantes {
    return Intl.message(
      'Lista de Estudiantes',
      name: 'label_listaestudiantes',
      desc: '',
      args: [],
    );
  }

  /// `Lista de Profesores`
  String get label_listaprofesores {
    return Intl.message(
      'Lista de Profesores',
      name: 'label_listaprofesores',
      desc: '',
      args: [],
    );
  }

  /// `Lista de Deportes`
  String get label_listadeportes {
    return Intl.message(
      'Lista de Deportes',
      name: 'label_listadeportes',
      desc: '',
      args: [],
    );
  }

  /// `Buscar por nombre o deporte`
  String get label_buscarnombredeporte {
    return Intl.message(
      'Buscar por nombre o deporte',
      name: 'label_buscarnombredeporte',
      desc: '',
      args: [],
    );
  }

  /// `Busca por nombre del profesor o por deporte asignado`
  String get label_buscarnombredeporteexp {
    return Intl.message(
      'Busca por nombre del profesor o por deporte asignado',
      name: 'label_buscarnombredeporteexp',
      desc: '',
      args: [],
    );
  }

  /// `Buscar deporte por nombre`
  String get label_buscardeporte {
    return Intl.message(
      'Buscar deporte por nombre',
      name: 'label_buscardeporte',
      desc: '',
      args: [],
    );
  }

  /// `Busca deporte por nombre o parte`
  String get label_buscardeporteexp {
    return Intl.message(
      'Busca deporte por nombre o parte',
      name: 'label_buscardeporteexp',
      desc: '',
      args: [],
    );
  }

  /// `Buscar estudiante por nombre`
  String get label_buscarestudiante {
    return Intl.message(
      'Buscar estudiante por nombre',
      name: 'label_buscarestudiante',
      desc: '',
      args: [],
    );
  }

  /// `Padres`
  String get label_ofrecidoapadres {
    return Intl.message(
      'Padres',
      name: 'label_ofrecidoapadres',
      desc: '',
      args: [],
    );
  }

  /// `deportes encontrados`
  String get label_deportesencontrados {
    return Intl.message(
      'deportes encontrados',
      name: 'label_deportesencontrados',
      desc: '',
      args: [],
    );
  }

  /// `Enviar anuncios al grupo`
  String get label_enviaranunciosgrupo {
    return Intl.message(
      'Enviar anuncios al grupo',
      name: 'label_enviaranunciosgrupo',
      desc: '',
      args: [],
    );
  }

  /// `Ver todos los alumnos inscritos`
  String get label_veralumnosinscritos {
    return Intl.message(
      'Ver todos los alumnos inscritos',
      name: 'label_veralumnosinscritos',
      desc: '',
      args: [],
    );
  }

  /// `correo electrónico`
  String get label_correoelectronico {
    return Intl.message(
      'correo electrónico',
      name: 'label_correoelectronico',
      desc: '',
      args: [],
    );
  }

  /// `ejemplo@emcorreo.com`
  String get label_correoelectronicoejemplo {
    return Intl.message(
      'ejemplo@emcorreo.com',
      name: 'label_correoelectronicoejemplo',
      desc: '',
      args: [],
    );
  }

  /// `Configuración`
  String get label_configuracion {
    return Intl.message(
      'Configuración',
      name: 'label_configuracion',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar sesión`
  String get label_cerrarsesion {
    return Intl.message(
      'Cerrar sesión',
      name: 'label_cerrarsesion',
      desc: '',
      args: [],
    );
  }

  /// `Enviar Comunicado`
  String get label_enviarcomunicado {
    return Intl.message(
      'Enviar Comunicado',
      name: 'label_enviarcomunicado',
      desc: '',
      args: [],
    );
  }

  /// `Activo`
  String get label_activo {
    return Intl.message('Activo', name: 'label_activo', desc: '', args: []);
  }

  /// `Inactivo`
  String get label_inactivo {
    return Intl.message('Inactivo', name: 'label_inactivo', desc: '', args: []);
  }

  /// `Editar Deporte`
  String get label_editardeporte {
    return Intl.message(
      'Editar Deporte',
      name: 'label_editardeporte',
      desc: '',
      args: [],
    );
  }

  /// `Editar cursos`
  String get label_editarcursos {
    return Intl.message(
      'Editar cursos',
      name: 'label_editarcursos',
      desc: '',
      args: [],
    );
  }

  /// `Edad mínima:`
  String get label_edadminima {
    return Intl.message(
      'Edad mínima:',
      name: 'label_edadminima',
      desc: '',
      args: [],
    );
  }

  /// `Edad máxima:`
  String get label_edadmaxima {
    return Intl.message(
      'Edad máxima:',
      name: 'label_edadmaxima',
      desc: '',
      args: [],
    );
  }

  /// `Estudiantes permitidos:`
  String get label_estudiantespermitidos {
    return Intl.message(
      'Estudiantes permitidos:',
      name: 'label_estudiantespermitidos',
      desc: '',
      args: [],
    );
  }

  /// `Ofrecido a padres:`
  String get label_ofrecidopadres {
    return Intl.message(
      'Ofrecido a padres:',
      name: 'label_ofrecidopadres',
      desc: '',
      args: [],
    );
  }

  /// `Sí`
  String get label_si {
    return Intl.message('Sí', name: 'label_si', desc: '', args: []);
  }

  /// `No`
  String get label_no {
    return Intl.message('No', name: 'label_no', desc: '', args: []);
  }

  /// `Todos`
  String get label_todos {
    return Intl.message('Todos', name: 'label_todos', desc: '', args: []);
  }

  /// `En revisión`
  String get label_revision {
    return Intl.message(
      'En revisión',
      name: 'label_revision',
      desc: '',
      args: [],
    );
  }

  /// `Verificado`
  String get label_verificado {
    return Intl.message(
      'Verificado',
      name: 'label_verificado',
      desc: '',
      args: [],
    );
  }

  /// `Devuelto`
  String get label_devuelto {
    return Intl.message('Devuelto', name: 'label_devuelto', desc: '', args: []);
  }

  /// `Documento`
  String get label_documento {
    return Intl.message(
      'Documento',
      name: 'label_documento',
      desc: '',
      args: [],
    );
  }

  /// `Salud`
  String get label_salud {
    return Intl.message('Salud', name: 'label_salud', desc: '', args: []);
  }

  /// `Identificación`
  String get label_identificacion {
    return Intl.message(
      'Identificación',
      name: 'label_identificacion',
      desc: '',
      args: [],
    );
  }

  /// `Familia`
  String get label_familia {
    return Intl.message('Familia', name: 'label_familia', desc: '', args: []);
  }

  /// `EPS`
  String get label_eps {
    return Intl.message('EPS', name: 'label_eps', desc: '', args: []);
  }

  /// `Régimen EPS`
  String get label_regimaneps {
    return Intl.message(
      'Régimen EPS',
      name: 'label_regimaneps',
      desc: '',
      args: [],
    );
  }

  /// `Grupo Sanguíneo`
  String get label_gruposanguineo {
    return Intl.message(
      'Grupo Sanguíneo',
      name: 'label_gruposanguineo',
      desc: '',
      args: [],
    );
  }

  /// `Toma Medicamentos`
  String get label_tomamedicamentos {
    return Intl.message(
      'Toma Medicamentos',
      name: 'label_tomamedicamentos',
      desc: '',
      args: [],
    );
  }

  /// `Enfermedades Previas`
  String get label_enfermedadesprevias {
    return Intl.message(
      'Enfermedades Previas',
      name: 'label_enfermedadesprevias',
      desc: '',
      args: [],
    );
  }

  /// `Cirugías Previas`
  String get label_cirugiasprevias {
    return Intl.message(
      'Cirugías Previas',
      name: 'label_cirugiasprevias',
      desc: '',
      args: [],
    );
  }

  /// `Lesiones Previas`
  String get label_lesionesprevias {
    return Intl.message(
      'Lesiones Previas',
      name: 'label_lesionesprevias',
      desc: '',
      args: [],
    );
  }

  /// `Certificado EPS`
  String get label_certificadoeps {
    return Intl.message(
      'Certificado EPS',
      name: 'label_certificadoeps',
      desc: '',
      args: [],
    );
  }

  /// `Alergias`
  String get label_alergias {
    return Intl.message('Alergias', name: 'label_alergias', desc: '', args: []);
  }

  /// `Condiciones Médicas`
  String get label_condicionesmedicas {
    return Intl.message(
      'Condiciones Médicas',
      name: 'label_condicionesmedicas',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get label_email {
    return Intl.message('Email', name: 'label_email', desc: '', args: []);
  }

  /// `Género`
  String get label_genero {
    return Intl.message('Género', name: 'label_genero', desc: '', args: []);
  }

  /// `Lugar Nacimiento`
  String get label_lugarnacimiento {
    return Intl.message(
      'Lugar Nacimiento',
      name: 'label_lugarnacimiento',
      desc: '',
      args: [],
    );
  }

  /// `Lugar Expedición`
  String get label_lugarexpedicion {
    return Intl.message(
      'Lugar Expedición',
      name: 'label_lugarexpedicion',
      desc: '',
      args: [],
    );
  }

  /// `Dirección`
  String get label_direccion {
    return Intl.message(
      'Dirección',
      name: 'label_direccion',
      desc: '',
      args: [],
    );
  }

  /// `Vereda/Sector`
  String get label_veredasector {
    return Intl.message(
      'Vereda/Sector',
      name: 'label_veredasector',
      desc: '',
      args: [],
    );
  }

  /// `Institución Educativa`
  String get label_instieducativa {
    return Intl.message(
      'Institución Educativa',
      name: 'label_instieducativa',
      desc: '',
      args: [],
    );
  }

  /// `Grado Escolar`
  String get label_gradoescolar {
    return Intl.message(
      'Grado Escolar',
      name: 'label_gradoescolar',
      desc: '',
      args: [],
    );
  }

  /// `DOCUMENTO ID`
  String get label_documentoid {
    return Intl.message(
      'DOCUMENTO ID',
      name: 'label_documentoid',
      desc: '',
      args: [],
    );
  }

  /// `CONSENTIMIENTO`
  String get label_consentimientodoc {
    return Intl.message(
      'CONSENTIMIENTO',
      name: 'label_consentimientodoc',
      desc: '',
      args: [],
    );
  }

  /// `Tipo Población`
  String get label_tipopoblacion {
    return Intl.message(
      'Tipo Población',
      name: 'label_tipopoblacion',
      desc: '',
      args: [],
    );
  }

  /// `Nombres Acudiente`
  String get label_nombresacudiente {
    return Intl.message(
      'Nombres Acudiente',
      name: 'label_nombresacudiente',
      desc: '',
      args: [],
    );
  }

  /// `Apellidos Acudiente`
  String get label_apellidosacudiente {
    return Intl.message(
      'Apellidos Acudiente',
      name: 'label_apellidosacudiente',
      desc: '',
      args: [],
    );
  }

  /// `Documento Acudiente`
  String get label_documentoacudiente {
    return Intl.message(
      'Documento Acudiente',
      name: 'label_documentoacudiente',
      desc: '',
      args: [],
    );
  }

  /// `Celular Acudiente`
  String get label_celularacudiente {
    return Intl.message(
      'Celular Acudiente',
      name: 'label_celularacudiente',
      desc: '',
      args: [],
    );
  }

  /// `Lista Metodólogos`
  String get label_listametodologos {
    return Intl.message(
      'Lista Metodólogos',
      name: 'label_listametodologos',
      desc: '',
      args: [],
    );
  }

  /// `metodólogos encontrados`
  String get label_metodologosencontrados {
    return Intl.message(
      'metodólogos encontrados',
      name: 'label_metodologosencontrados',
      desc: '',
      args: [],
    );
  }

  /// `buscar metodólogo por nombre`
  String get label_buscarmetodologo {
    return Intl.message(
      'buscar metodólogo por nombre',
      name: 'label_buscarmetodologo',
      desc: '',
      args: [],
    );
  }

  /// `Motivo Devolución`
  String get label_motivodevolucion {
    return Intl.message(
      'Motivo Devolución',
      name: 'label_motivodevolucion',
      desc: '',
      args: [],
    );
  }

  /// `Por favor ingrese el motivo de la devolución`
  String get label_motivodevolucionexp {
    return Intl.message(
      'Por favor ingrese el motivo de la devolución',
      name: 'label_motivodevolucionexp',
      desc: '',
      args: [],
    );
  }

  /// `COMUNICADO #`
  String get label_comunicado {
    return Intl.message(
      'COMUNICADO #',
      name: 'label_comunicado',
      desc: '',
      args: [],
    );
  }

  /// `Tomar Asistencia`
  String get label_tomarasistencia {
    return Intl.message(
      'Tomar Asistencia',
      name: 'label_tomarasistencia',
      desc: '',
      args: [],
    );
  }

  /// `Estado Revisión`
  String get label_estadoderevision {
    return Intl.message(
      'Estado Revisión',
      name: 'label_estadoderevision',
      desc: '',
      args: [],
    );
  }

  /// `Matrícula`
  String get label_matricula {
    return Intl.message(
      'Matrícula',
      name: 'label_matricula',
      desc: '',
      args: [],
    );
  }

  /// `Estado`
  String get label_estado {
    return Intl.message('Estado', name: 'label_estado', desc: '', args: []);
  }

  /// `Detalles Asistencia`
  String get label_detallesasistencia {
    return Intl.message(
      'Detalles Asistencia',
      name: 'label_detallesasistencia',
      desc: '',
      args: [],
    );
  }

  /// `Lugar:`
  String get label_lugar {
    return Intl.message('Lugar:', name: 'label_lugar', desc: '', args: []);
  }

  /// `Observaciones:`
  String get label_observaciones {
    return Intl.message(
      'Observaciones:',
      name: 'label_observaciones',
      desc: '',
      args: [],
    );
  }

  /// `Ingrese observaciones adicionales...`
  String get label_observacionesadicionales {
    return Intl.message(
      'Ingrese observaciones adicionales...',
      name: 'label_observacionesadicionales',
      desc: '',
      args: [],
    );
  }

  /// `Se registrará la asistencia para todos los estudiantes mostrados`
  String get label_observacionesadicionalesexp {
    return Intl.message(
      'Se registrará la asistencia para todos los estudiantes mostrados',
      name: 'label_observacionesadicionalesexp',
      desc: '',
      args: [],
    );
  }

  /// `Metodólogo`
  String get label_metodologo {
    return Intl.message(
      'Metodólogo',
      name: 'label_metodologo',
      desc: '',
      args: [],
    );
  }

  /// `Cupo máx`
  String get label_cupomax {
    return Intl.message('Cupo máx', name: 'label_cupomax', desc: '', args: []);
  }

  /// `Edades`
  String get label_edades {
    return Intl.message('Edades', name: 'label_edades', desc: '', args: []);
  }

  /// `Años`
  String get label_anos {
    return Intl.message('Años', name: 'label_anos', desc: '', args: []);
  }

  /// `Agregar Comentario`
  String get label_agregarcomentario {
    return Intl.message(
      'Agregar Comentario',
      name: 'label_agregarcomentario',
      desc: '',
      args: [],
    );
  }

  /// `Comentario`
  String get label_comentario {
    return Intl.message(
      'Comentario',
      name: 'label_comentario',
      desc: '',
      args: [],
    );
  }

  /// `Escribe tu comentario aquí...`
  String get label_escribecomentario {
    return Intl.message(
      'Escribe tu comentario aquí...',
      name: 'label_escribecomentario',
      desc: '',
      args: [],
    );
  }

  /// `Descargar Documentos`
  String get label_descargardocumentos {
    return Intl.message(
      'Descargar Documentos',
      name: 'label_descargardocumentos',
      desc: '',
      args: [],
    );
  }

  /// `Seleccione el formato de descarga:`
  String get label_seleccioneformato {
    return Intl.message(
      'Seleccione el formato de descarga:',
      name: 'label_seleccioneformato',
      desc: '',
      args: [],
    );
  }

  /// `Ver hoja de calculo`
  String get label_verhojacalculo {
    return Intl.message(
      'Ver hoja de calculo',
      name: 'label_verhojacalculo',
      desc: '',
      args: [],
    );
  }

  /// `Ver CSV`
  String get label_vercsv {
    return Intl.message('Ver CSV', name: 'label_vercsv', desc: '', args: []);
  }

  /// `Nueva Contraseña`
  String get label_nueva_contrasena {
    return Intl.message(
      'Nueva Contraseña',
      name: 'label_nueva_contrasena',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar Contraseña`
  String get label_nueva_contrasenaconfirmar {
    return Intl.message(
      'Confirmar Contraseña',
      name: 'label_nueva_contrasenaconfirmar',
      desc: '',
      args: [],
    );
  }

  /// `El token será enviado a tu correo`
  String get label_nueva_contrasenaexp {
    return Intl.message(
      'El token será enviado a tu correo',
      name: 'label_nueva_contrasenaexp',
      desc: '',
      args: [],
    );
  }

  /// `token`
  String get label_token {
    return Intl.message('token', name: 'label_token', desc: '', args: []);
  }

  /// `un token se ha enviado a su correo asociado`
  String get msj_token_enviado {
    return Intl.message(
      'un token se ha enviado a su correo asociado',
      name: 'msj_token_enviado',
      desc: '',
      args: [],
    );
  }

  /// `Las contraseñas coinciden`
  String get msj_contrasenas_iguales {
    return Intl.message(
      'Las contraseñas coinciden',
      name: 'msj_contrasenas_iguales',
      desc: '',
      args: [],
    );
  }

  /// `Las contraseñas no coinciden`
  String get msj_contrasenas_diferentes {
    return Intl.message(
      'Las contraseñas no coinciden',
      name: 'msj_contrasenas_diferentes',
      desc: '',
      args: [],
    );
  }

  /// `Error al seleccionar archivo`
  String get msj_errorseleccarchivo {
    return Intl.message(
      'Error al seleccionar archivo',
      name: 'msj_errorseleccarchivo',
      desc: '',
      args: [],
    );
  }

  /// `Debe seleccionar los tres documentos para enviar`
  String get msj_errorselecctresarchivos {
    return Intl.message(
      'Debe seleccionar los tres documentos para enviar',
      name: 'msj_errorselecctresarchivos',
      desc: '',
      args: [],
    );
  }

  /// `Documentos enviados exitosamente`
  String get msj_docsenviados {
    return Intl.message(
      'Documentos enviados exitosamente',
      name: 'msj_docsenviados',
      desc: '',
      args: [],
    );
  }

  /// `Error al enviar documentos:`
  String get msj_errorenvdocs {
    return Intl.message(
      'Error al enviar documentos:',
      name: 'msj_errorenvdocs',
      desc: '',
      args: [],
    );
  }

  /// `Inscripción exitosa, próximante te contactaremos para que selecciones tu talla de uniforme`
  String get msj_inscexitosa {
    return Intl.message(
      'Inscripción exitosa, próximante te contactaremos para que selecciones tu talla de uniforme',
      name: 'msj_inscexitosa',
      desc: '',
      args: [],
    );
  }

  /// `inscripción no exitosa`
  String get msj_inscnoexitosa {
    return Intl.message(
      'inscripción no exitosa',
      name: 'msj_inscnoexitosa',
      desc: '',
      args: [],
    );
  }

  /// `Usuario o Clave erronea... intente de nuevo`
  String get msj_errorlogin {
    return Intl.message(
      'Usuario o Clave erronea... intente de nuevo',
      name: 'msj_errorlogin',
      desc: '',
      args: [],
    );
  }

  /// `Revisa tu correo electronico, hemos enviado un mensaje`
  String get msj_inscripcionenviada {
    return Intl.message(
      'Revisa tu correo electronico, hemos enviado un mensaje',
      name: 'msj_inscripcionenviada',
      desc: '',
      args: [],
    );
  }

  /// `No pudimos enviar el mensaje a tu correo, intenta más tarde`
  String get msj_inscripcionerror {
    return Intl.message(
      'No pudimos enviar el mensaje a tu correo, intenta más tarde',
      name: 'msj_inscripcionerror',
      desc: '',
      args: [],
    );
  }

  /// `Se ha enviado el comunicado`
  String get msj_enviocomunicadoexitoso {
    return Intl.message(
      'Se ha enviado el comunicado',
      name: 'msj_enviocomunicadoexitoso',
      desc: '',
      args: [],
    );
  }

  /// `No se pudo enviar el comunicado`
  String get msj_enviocomunicadoerror {
    return Intl.message(
      'No se pudo enviar el comunicado',
      name: 'msj_enviocomunicadoerror',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa un correo electrónico válido`
  String get msj_correoinvalido {
    return Intl.message(
      'Ingresa un correo electrónico válido',
      name: 'msj_correoinvalido',
      desc: '',
      args: [],
    );
  }

  /// `Los cambios se aplicarán al deporte seleccionado`
  String get msj_deporteseleccionado {
    return Intl.message(
      'Los cambios se aplicarán al deporte seleccionado',
      name: 'msj_deporteseleccionado',
      desc: '',
      args: [],
    );
  }

  /// `Asignación exitosa`
  String get msj_asignacionexitosa {
    return Intl.message(
      'Asignación exitosa',
      name: 'msj_asignacionexitosa',
      desc: '',
      args: [],
    );
  }

  /// `No se pudo realizar la asignación`
  String get msj_asignacionerronea {
    return Intl.message(
      'No se pudo realizar la asignación',
      name: 'msj_asignacionerronea',
      desc: '',
      args: [],
    );
  }

  /// `El deporte se actualizó con éxito`
  String get msj_deporteactualizadoconexito {
    return Intl.message(
      'El deporte se actualizó con éxito',
      name: 'msj_deporteactualizadoconexito',
      desc: '',
      args: [],
    );
  }

  /// `El deporte no se pudo actualizar`
  String get msj_deporteactualizadoconerror {
    return Intl.message(
      'El deporte no se pudo actualizar',
      name: 'msj_deporteactualizadoconerror',
      desc: '',
      args: [],
    );
  }

  /// `URL no válida`
  String get msj_urlinvalida {
    return Intl.message(
      'URL no válida',
      name: 'msj_urlinvalida',
      desc: '',
      args: [],
    );
  }

  /// `No se encontró una aplicación para abrir este archivo`
  String get msj_noencontreaplicacion {
    return Intl.message(
      'No se encontró una aplicación para abrir este archivo',
      name: 'msj_noencontreaplicacion',
      desc: '',
      args: [],
    );
  }

  /// `Mensaje enviado con éxito`
  String get msj_mensajeenviadoexito {
    return Intl.message(
      'Mensaje enviado con éxito',
      name: 'msj_mensajeenviadoexito',
      desc: '',
      args: [],
    );
  }

  /// `Mensaje no se pudo enviar`
  String get msj_mensajeenviadoerror {
    return Intl.message(
      'Mensaje no se pudo enviar',
      name: 'msj_mensajeenviadoerror',
      desc: '',
      args: [],
    );
  }

  /// `Asistencia registrada`
  String get msj_asistenciaregistrada {
    return Intl.message(
      'Asistencia registrada',
      name: 'msj_asistenciaregistrada',
      desc: '',
      args: [],
    );
  }

  /// `No se pudo registrar la asistencia`
  String get msj_asistencianoregistrada {
    return Intl.message(
      'No se pudo registrar la asistencia',
      name: 'msj_asistencianoregistrada',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
