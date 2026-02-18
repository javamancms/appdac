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

  /// `usuario:`
  String get label_usuario {
    return Intl.message('usuario:', name: 'label_usuario', desc: '', args: []);
  }

  /// `clave:`
  String get label_clave {
    return Intl.message('clave:', name: 'label_clave', desc: '', args: []);
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

  /// `Enviar`
  String get label_enviar {
    return Intl.message('Enviar', name: 'label_enviar', desc: '', args: []);
  }

  /// `Cancelar`
  String get label_cancelar {
    return Intl.message('Cancelar', name: 'label_cancelar', desc: '', args: []);
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

  /// `Título:`
  String get label_titulo {
    return Intl.message('Título:', name: 'label_titulo', desc: '', args: []);
  }

  /// `Mensaje:`
  String get label_mensaje {
    return Intl.message('Mensaje:', name: 'label_mensaje', desc: '', args: []);
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

  /// `el Token se enviará a tu correo`
  String get label_nueva_contrasenaexp {
    return Intl.message(
      'el Token se enviará a tu correo',
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
