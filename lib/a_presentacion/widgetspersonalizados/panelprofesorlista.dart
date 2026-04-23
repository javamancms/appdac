import 'package:appdac/a_presentacion/administrador/guiasignardeportes.dart';
import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfesorCard extends StatefulWidget {
  final Profesor profesor;

  const ProfesorCard({
    required this.profesor,
  });

  @override
  State<ProfesorCard> createState() => _ProfesorCardState();
}

class _ProfesorCardState extends State<ProfesorCard> {
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    ControlListaDeportesAdministrador controllistadeportesadministrador = context.watch<ControlListaDeportesAdministrador>();

    return GestureDetector(
      onTap: () async {
        final deportesSeleccionados = await showDialog<List<Deporte>>(
          context: context,
          builder: (BuildContext context) {
            return DialogoAsignarDeportes(
              controlListaDeportes: controllistadeportesadministrador,
              profesor: widget.profesor,
            );
          },
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white, // Fondo blanco
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Columna izquierda: Icono
              Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconoProfesor(
                    backgroundColor: AppColors.blanco,
                    color: AppColors.verde,
                    borderRadius: 10,
                    size: 40,
                  )),

              // Columna central: Nombre y ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.profesor.nombre,
                      style: AppColors.textosubtitulonegro,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${widget.profesor.idProfesor}',
                      style: AppColors.textosecundarionegro,
                    ),
                  ],
                ),
              ),

              // Columna derecha: Checkbox "Activo"
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (_procesando)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.verde), // Indicador verde
                          ),
                        )
                      else
                        Theme(
                          data: Theme.of(context).copyWith(
                            checkboxTheme: CheckboxThemeData(
                              fillColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.green; // Checkbox seleccionado verde
                                  }
                                  return null; // Mantener el color por defecto para no seleccionado
                                },
                              ),
                            ),
                          ),
                          child: Checkbox(
                            value: widget.profesor.activo,
                            onChanged: _procesando ? null : (value) => _cambiarEstadoActivo(value),
                            activeColor: AppColors.verde, // Color del checkbox cuando está activo
                            checkColor: AppColors.blanco, // Color del checkmark
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text(
                        S.of(context).label_activo,
                        style: AppColors.textosecundarionegro,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método separado para manejar el cambio de estado
  Future<void> _cambiarEstadoActivo(bool? value) async {
    // Evitar múltiples ejecuciones
    if (_procesando) return;

    // Verificar que value no sea null
    if (value == null) return;

    setState(() {
      _procesando = true;
    });

    // Guardar el estado anterior para posible reversión
    final estadoAnterior = widget.profesor.activo;

    try {
      // Actualizar UI inmediatamente
      widget.profesor.activo = value;
      setState(() {});

      // Obtener los controladores usando context.read
      final controllistaprofesores = context.read<ControlListaProfesores>();

      // Llamar a los servicios
      await controllistaprofesores.cambiarEstadoProfesor(widget.profesor.idProfesor);
      await controllistaprofesores.cargarProfesores(ControlSesion.datosusuario!.idUsuario);
    } catch (e) {
      // Manejar error si es necesario
      print('Error al cambiar estado: $e');

      // Revertir cambio en caso de error usando el estado anterior
      widget.profesor.activo = estadoAnterior;
      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar estado: $e'),
            backgroundColor: AppColors.rojo,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _procesando = false;
        });
      }
    }
  }
}
