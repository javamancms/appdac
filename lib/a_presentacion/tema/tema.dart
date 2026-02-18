import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color verde = Color.fromARGB(255, 64, 148, 67);
  static const Color verdeclaro = Color.fromARGB(255, 101, 187, 103);
  static const Color blanco = Colors.white;
  static const Color naranja = Color(0xFFFF9800);
  static const Color negro = Colors.black;
  static const Color gris = Color.fromARGB(255, 119, 119, 119);
  static const Color rojo = Colors.red;


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
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.verde,
  );

  static TextStyle textoinformativogris = TextStyle(
    fontSize: 14,
    color: AppColors.gris,
  );

}

class DecoracionCampoVerde extends InputDecoration {
  DecoracionCampoVerde({letrero, hintLetrero})
      : super(
          labelText: letrero,
          hintText: hintLetrero,
          prefixIcon: const Icon(Icons.lock),
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
          labelStyle: TextStyle(color: AppColors.verde), // Color del label
        );
}
