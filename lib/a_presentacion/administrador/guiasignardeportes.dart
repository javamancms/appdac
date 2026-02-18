import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/config/log.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogoAsignarDeportes extends StatelessWidget {
  final ControlListaDeportesAdministrador controlListaDeportes;
  final Profesor profesor;

  const DialogoAsignarDeportes({Key? key, required this.controlListaDeportes, required this.profesor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cargar la lista de deportes
    controlListaDeportes.cargarListaDeportes();
    logear('nombre: profesor: ${profesor.nombre}');
    logear('nombre: deportes: ${profesor.nombreDeporte}');

    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Ocupa el 80% del ancho de la pantalla
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.sports, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Asignar deportes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Text(
                profesor.nombre,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center, // Centrar el texto horizontalmente
                softWrap: true,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: _buildContent(),
      ),
      //actions: _buildActions(context),
    );
  }

  Widget _buildContent() {
    return Consumer<ControlListaDeportesAdministrador>(
      builder: (context, controlListaDeportes, child) {
        if (controlListaDeportes.deportes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No hay deportes disponibles',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return _ListaDeportesConCheckbox(
          deportes: controlListaDeportes.deportes,
          deportesAsignados: profesor.nombreDeporte,
          profesor: profesor,
        );
      },
    );
  }

 
}

//***********************************************************************************

class _ListaDeportesConCheckbox extends StatefulWidget {

  final List<Deporte> deportes;
  final List<String> deportesAsignados;
  final Profesor profesor;

  const _ListaDeportesConCheckbox({Key? key, required this.deportes, required this.deportesAsignados, required this.profesor}) : super(key: key);

  @override
  __ListaDeportesConCheckboxState createState() => __ListaDeportesConCheckboxState();

  // Método estático para obtener el estado
  static __ListaDeportesConCheckboxState? of(BuildContext context) {
    return context.findAncestorStateOfType<__ListaDeportesConCheckboxState>();
  }
}

class __ListaDeportesConCheckboxState extends State<_ListaDeportesConCheckbox> {
  // Mapa para mantener el estado de los checkboxes
  late Map<String, bool> _seleccionados;

  // Getter público para acceder a los seleccionados
  Map<String, bool> get seleccionados => _seleccionados;

  @override
  void initState() {
    super.initState();
    _inicializarSeleccionados();
  }

  @override
  void didUpdateWidget(_ListaDeportesConCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si los deportes o deportes asignados cambiaron, actualizamos los seleccionados
    if (oldWidget.deportes != widget.deportes || oldWidget.deportesAsignados != widget.deportesAsignados) {
      _inicializarSeleccionados();
    }
  }

  void _inicializarSeleccionados() {
    _seleccionados = {};
    for (var deporte in widget.deportes) {
      // Verificar si el nombre del deporte está contenido en la lista de deportesAsignados
      _seleccionados[deporte.idDeporte] = widget.deportesAsignados.any((nombreAsignado) => nombreAsignado.contains(deporte.nombreDeporte));
    }
  }

  @override
  Widget build(BuildContext context) {
    ControlListaProfesores controllistaprofesores=context.watch<ControlListaProfesores>();

    return Column(
      children: [
        // Lista de deportes expandible
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.deportes.length,
            itemBuilder: (context, index) {
              final deporte = widget.deportes[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: _seleccionados[deporte.idDeporte] == true ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deporte.nombreDeporte,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              maxLines: null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${deporte.idDeporte}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.people_outline, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Edad: ${deporte.edadMinima} - ${deporte.edadMaxima} años',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Checkbox(
                            value: _seleccionados[deporte.idDeporte] ?? false,
                            onChanged: (bool? valor) {
                              setState(() {
                                _seleccionados[deporte.idDeporte] = valor!;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          const Text(
                            'Asociar',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Contenedor para los botones con fondo y sombra
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, -1), // Sombra hacia arriba
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            

                // Botones en fila compacta
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón Cancelar
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size(80, 36),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Botón Asignar
                    Consumer<ControlListaDeportesAdministrador>(
                      builder: (context, controlListaDeportes, child) {
                        final haySeleccionados = _seleccionados.values.contains(true);

                        return ElevatedButton(
                          onPressed: haySeleccionados
                              ? () async{
                                
                                  List<Deporte> deportesSeleccionados = controlListaDeportes.deportes.where((deporte) => _seleccionados[deporte.idDeporte] == true).toList();
                                  bool resultado=(await controllistaprofesores.asignarDeportesAProfesor('profesor',widget.profesor.idProfesor,deportesSeleccionados));
                                  mostrarMensajeInferior(context, resultado?'Asignacioón exitosa':'No se pudo realizar la asignación', colorFondo: resultado? AppColors.verde: AppColors.rojo);
                                  controllistaprofesores.cargarProfesores(ControlSesion.datosusuario!.idUsuario);
                                  Navigator.of(context).pop(deportesSeleccionados);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: const Size(80, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Asignar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
