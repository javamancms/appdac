import 'package:flutter/material.dart';

class AppColors {
  // Colores principales

  static const String fuenteNombre = 'AcuminVariableConcept';
  static const double fuenteTamanoTitulo = 24;
  static const double fuenteTamanoSubtitulo = 16;
  static const double fuenteTamanoSecundario = 12;

  static const Color verde = Color.fromARGB(255, 66, 128, 65);

  static const Color rojo = Color.fromARGB(255, 232, 74, 74);
  static const Color azul = Color.fromARGB(255, 17, 184, 235);
  static const Color azulrey = Colors.blue;
  static const Color amarillo = Color.fromARGB(255, 255, 207, 6);
  static const Color cafe = Color.fromARGB(255, 130, 72, 15);
  static const Color blanco = Colors.white;

//colores viejos
  static const Color verdeclaro = Color.fromARGB(255, 101, 187, 103);

  static const Color naranja = Color(0xFFFF9800);
  static const Color negro = Colors.black;
  static const Color gris = Color.fromARGB(255, 119, 119, 119);
  static const Color grisclaro = Color.fromARGB(255, 192, 192, 192);

  static ButtonStyle botonverde = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.blanco; // Fondo blanco cuando se presiona
        }
        return AppColors.verde; // Fondo naranja por defecto
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.verde; // Texto verde cuando se presiona
        }
        return AppColors.blanco; // Texto blanco por defecto
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevation: MaterialStateProperty.all<double>(2),
  );

  static ButtonStyle botonblanco = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.verde; // Fondo blanco cuando se presiona
        }
        return AppColors.blanco; // Fondo naranja por defecto
      },
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColors.blanco; // Texto verde cuando se presiona
        }
        return AppColors.verde; // Texto blanco por defecto
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevation: MaterialStateProperty.all<double>(2),
  );

  static TextStyle textotituloverde = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoTitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.verde,
  );

  static TextStyle textosubtitulonegro = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSubtitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.negro,
  );

  static TextStyle textosubtituloverde = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSubtitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.verde,
  );

  static TextStyle textosubtitulogris = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSubtitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.gris,
  );

  static TextStyle textosubtitulorojo = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSubtitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.rojo,
  );

  static TextStyle textotitulonegro = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoTitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.negro,
  );

  static TextStyle textosecundarionegro = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSecundario,
    fontWeight: FontWeight.bold,
    color: AppColors.negro,
  );

  static TextStyle textosecundarioblanco = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSecundario,
    fontWeight: FontWeight.bold,
    color: AppColors.blanco,
  );
  
  static TextStyle textosecundariogris = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSecundario,
    fontWeight: FontWeight.bold,
    color: AppColors.gris,
  );

  static TextStyle textosecundarioverde = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSecundario,
    fontWeight: FontWeight.bold,
    color: AppColors.verde,
  );

  static TextStyle textosubtituloblanco = TextStyle(
    fontFamily: fuenteNombre,
    fontSize: fuenteTamanoSubtitulo,
    fontWeight: FontWeight.bold,
    color: AppColors.blanco,
  );

  static TextStyle textoinformativogris = TextStyle(
    fontSize: fuenteTamanoSecundario,
    color: AppColors.gris,
    fontFamily: AppColors.fuenteNombre,
    fontWeight: FontWeight.bold,
  );
}

class DecoracionCampoVerde extends InputDecoration {
  DecoracionCampoVerde({letrero, hintLetrero, IconData? icono})
      : super(
          labelText: letrero,
          hintText: hintLetrero,
          prefixIcon: icono != null ? Icon(icono) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.verde), // Borde por defecto verde
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.verde), // Borde cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.verde, width: 2), // Borde cuando está enfocado
          ),
          filled: true,
          fillColor: AppColors.blanco,
          //labelStyle: TextStyle(color: AppColors.verde, fontFamily: AppColors.fuenteNombre, fontSize: AppColors.fuenteTamanoSubtitulo, fontWeight: FontWeight.bold), // Color del label
          labelStyle: TextStyle(color: AppColors.verde, fontWeight: FontWeight.bold, fontFamily: AppColors.fuenteNombre, fontSize: AppColors.fuenteTamanoSecundario), // Color del label siempre rojo
          hintStyle: TextStyle(color: AppColors.grisclaro, fontWeight: FontWeight.bold, fontFamily: AppColors.fuenteNombre, fontSize: AppColors.fuenteTamanoSecundario), // Colo
        );
}

class DecoracionCampoVerdeFondoGris extends InputDecoration {
  DecoracionCampoVerdeFondoGris({letrero, hintLetrero, IconData? icono})
      : super(
          labelText: letrero,
          hintText: hintLetrero,
          
          prefixIcon: icono != null ? Icon(icono) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.verde), // Borde por defecto verde
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.verde), // Borde cuando está habilitado
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.verde, width: 2), // Borde cuando está enfocado
          ),
          filled: true,
          fillColor: AppColors.grisclaro.withOpacity(0.3),
          //labelStyle: TextStyle(color: AppColors.verde, fontFamily: AppColors.fuenteNombre, fontSize: AppColors.fuenteTamanoSubtitulo, fontWeight: FontWeight.bold), // Color del label
          labelStyle: TextStyle(color: AppColors.verde, fontWeight: FontWeight.bold, fontFamily: AppColors.fuenteNombre, fontSize: AppColors.fuenteTamanoSecundario), // Color del label siempre rojo
          hintStyle: TextStyle(color: AppColors.grisclaro, fontWeight: FontWeight.bold, fontFamily: AppColors.fuenteNombre, fontSize: AppColors.fuenteTamanoSecundario), // Colo
        );
}
