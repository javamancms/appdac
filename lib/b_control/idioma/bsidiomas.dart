import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdiomaInfo {
  final String codigo;
  final String nombre;
  
  IdiomaInfo({required this.codigo, required this.nombre});
}

class IdiomaHelper extends ChangeNotifier {
  static final IdiomaHelper _instance = IdiomaHelper._internal();
  factory IdiomaHelper() => _instance;
  IdiomaHelper._internal();

  static const String _idiomaKey = 'idioma_seleccionado';
  static const String idiomaPorDefecto = 'es';
  
  // Lista de idiomas disponibles
  static List<IdiomaInfo> idiomasDisponibles = [
    IdiomaInfo(codigo: 'es', nombre: 'Español'),
    IdiomaInfo(codigo: 'en', nombre: 'English'),
  ];
  
  String _idiomaActual = idiomaPorDefecto;
  
  // Getter para obtener el código del idioma actual
  String get idiomaActualCodigo => _idiomaActual;
  
  // Getter para obtener el idioma actual como Locale
  Locale get idiomaActualLocale => Locale(_idiomaActual);
  
  // Inicializar el helper cargando el idioma guardado
  static Future<void> inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    _instance._idiomaActual = prefs.getString(_idiomaKey) ?? idiomaPorDefecto;
  }
  
  // Guardar el idioma seleccionado y notificar a los listeners
  static Future<void> guardarIdioma(String codigoIdioma) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idiomaKey, codigoIdioma);
    _instance._idiomaActual = codigoIdioma;
    _instance.notifyListeners(); // Notificar a los widgets que escuchan
  }
}