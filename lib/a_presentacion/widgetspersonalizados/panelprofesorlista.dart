import 'package:appdac/a_presentacion/administrador/guiasignardeportes.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfesorCard extends StatefulWidget {
  final IconData icon;
  final Profesor profesor;

  const ProfesorCard({
    required this.icon,
    required this.profesor,
  });

  @override
  State<ProfesorCard> createState() => _ProfesorCardState();
}

class _ProfesorCardState extends State<ProfesorCard> {
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    ControlListaDeportesAdministrador controllistadeportesadministrador = 
        context.watch<ControlListaDeportesAdministrador>();
    
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Columna izquierda: Icono
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // Columna central: Nombre y ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.profesor.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${widget.profesor.idProfesor}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      else
                        Checkbox(
                          value: widget.profesor.activo,
                          onChanged: _procesando ? null : (value) => _cambiarEstadoActivo(value),
                        ),
                      const SizedBox(width: 4),
                      const Text('Activo'),
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
            backgroundColor: Colors.red,
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