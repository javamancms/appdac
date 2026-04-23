import 'package:flutter/material.dart';

class IconoProfesor extends StatelessWidget {
  final double size;
  final Color? color; // Color del ícono
  final Color? backgroundColor; // Color de fondo
  final double? borderRadius; // Radio del borde (opcional)

  const IconoProfesor({
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    print('icono profesor');
    
    Widget icon = Image.asset(
      'assets/img/IcoProfesor.png',
      width: size,
      height: size,
      color: color,
    );

    // Si hay color de fondo, envolver en Container
    if (backgroundColor != null) {
      icon = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius != null 
              ? BorderRadius.circular(borderRadius!)
              : null, // Si no hay borderRadius, no aplica borde redondeado
        ),
        child: Center(
          child: icon,
        ),
      );
    }
    
    return icon;
  }
}

class IconoDeporte extends StatelessWidget {
  final double size;
  final Color? color; // Color del ícono
  final Color? backgroundColor; // Color de fondo
  final double? borderRadius; // Radio del borde (opcional)

  const IconoDeporte({
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    print('icono profesor');
    
    Widget icon = Image.asset(
      'assets/img/IcoDeporte.png',
      width: size,
      height: size,
      color: color,
    );

    // Si hay color de fondo, envolver en Container
    if (backgroundColor != null) {
      icon = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius != null 
              ? BorderRadius.circular(borderRadius!)
              : null, // Si no hay borderRadius, no aplica borde redondeado
        ),
        child: Center(
          child: icon,
        ),
      );
    }
    
    return icon;
  }
}


class IconoMetodologo extends StatelessWidget {
  final double size;
  final Color? color; // Color del ícono
  final Color? backgroundColor; // Color de fondo
  final double? borderRadius; // Radio del borde (opcional)

  const IconoMetodologo({
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    print('icono metodologo');
    
    Widget icon = Image.asset(
      'assets/img/icoMetodologo.png',
      width: size,
      height: size,
      color: color,
    );

    // Si hay color de fondo, envolver en Container
    if (backgroundColor != null) {
      icon = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius != null 
              ? BorderRadius.circular(borderRadius!)
              : null, // Si no hay borderRadius, no aplica borde redondeado
        ),
        child: Center(
          child: icon,
        ),
      );
    }
    
    return icon;
  }
}

class IconoAsistencia extends StatelessWidget {
  final double size;
  final Color? color; // Color del ícono
  final Color? backgroundColor; // Color de fondo
  final double? borderRadius; // Radio del borde (opcional)

  const IconoAsistencia({
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    print('icono asistencia');
    
    Widget icon = Image.asset(
      'assets/img/IcoAsistencia.png',
      width: size,
      height: size,
      color: color,
    );

    // Si hay color de fondo, envolver en Container
    if (backgroundColor != null) {
      icon = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius != null 
              ? BorderRadius.circular(borderRadius!)
              : null, // Si no hay borderRadius, no aplica borde redondeado
        ),
        child: Center(
          child: icon,
        ),
      );
    }
    
    return icon;
  }
}