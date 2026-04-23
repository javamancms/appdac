import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TomarAsistenciaScreen extends StatefulWidget {
  const TomarAsistenciaScreen({super.key});

  @override
  State<TomarAsistenciaScreen> createState() => _TomarAsistenciaScreenState();
}

class _TomarAsistenciaScreenState extends State<TomarAsistenciaScreen> {
  List<EstudianteDeporte> todosLosEstudiantes = [];
  List<EstudianteDeporte> estudiantesFiltrados = [];
  ControlListaDeporte? controllistadeporte;
  ControlListaDeportesProfesor? controllistadeporteprofesor;

  // Mapa para almacenar el estado de asistencia de cada estudiante
  late Map<String, String> estadosAsistencia;

  // Opciones de asistencia
  final List<String> opcionesAsistencia = ['Asistió', 'Faltó', 'Tarde'];

  // Opciones de lugar
  final List<String> opcionesLugar = ['Campus', 'Cancha central', 'Gimnasio', 'Sala audiovisuales', 'Laboratorio de computación'];

  // Controlador para búsqueda
  final TextEditingController searchController = TextEditingController();
  String filtroBusqueda = '';

  @override
  void initState() {
    super.initState();
    estadosAsistencia = {};
  }

  // Método para actualizar el filtro de búsqueda
  void _actualizarFiltro(String query) {
    setState(() {
      filtroBusqueda = query.toLowerCase();
    });
  }

  // Método para filtrar estudiantes
  List<EstudianteDeporte> _filtrarEstudiantes(List<EstudianteDeporte> estudiantes) {
    if (filtroBusqueda.isEmpty) {
      return estudiantes;
    }
    return estudiantes.where((estudiante) {
      return estudiante.nombre.toLowerCase().contains(filtroBusqueda);
    }).toList();
  }

  // Método para mostrar el diálogo de detalles de asistencia
  Future<void> _mostrarDialogoDetalles() async {
    String lugarSeleccionado = 'Campus';
    final TextEditingController observacionesController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.blanco,
              title: Text(
                S.of(context).label_detallesasistencia,
                style: AppColors.textotituloverde,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selector de lugar
                    Text(
                      S.of(context).label_lugar,
                      style: AppColors.textosubtitulonegro,
                    ),
                    const SizedBox(height: 8),

                    // DropdownButton simplificado y con padding interno
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.gris.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.verde,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12), // 👈 SEPARACIÓN DEL MARGEN IZQUIERDO
                        child: DropdownButton<String>(
                          value: lugarSeleccionado,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          underline: const SizedBox(),
                          onChanged: (String? nuevoValor) {
                            setState(() {
                              lugarSeleccionado = nuevoValor!;
                            });
                          },
                          items: opcionesLugar.map<DropdownMenuItem<String>>((String valor) {
                            return DropdownMenuItem<String>(
                              value: valor,
                              child: Text(
                                valor,
                                style: AppColors.textosecundarionegro,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo de observaciones
                    Text(
                      S.of(context).label_observaciones,
                      style: AppColors.textosubtitulonegro,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: observacionesController,
                      maxLines: 3,
                      decoration: DecoracionCampoVerdeFondoGris(
                        letrero: S.of(context).label_observacionesadicionales,
                      ),
                    ),

                    // Resumen de estudiantes
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 20,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).label_estudiantes}: ${estudiantesFiltrados.length}',
                          style: AppColors.textosubtitulonegro,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).label_observacionesadicionalesexp,
                      style: AppColors.textoinformativogris,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                // Botón Cancelar
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: AppColors.botonblanco,
                  child: Text(
                    S.of(context).label_cancelar,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Botón Guardar
                ElevatedButton(
                  onPressed: () async {
                    await _guardarAsistencia(
                      context,
                      controllistadeporte!,
                      controllistadeporteprofesor!,
                      lugar: lugarSeleccionado,
                      observaciones: observacionesController.text,
                    );
                    Navigator.of(context).pop();
                  },
                  style: AppColors.botonverde,
                  child: Text(S.of(context).label_enviar),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Método para guardar la asistencia
  Future<void> _guardarAsistencia(BuildContext context, ControlListaDeporte controllistadeporte, ControlListaDeportesProfesor controllistadeporteprofesor,
      {required String lugar, required String observaciones}) async {
    await controllistadeporte.guardarAsistencia(context, controllistadeporteprofesor.seleccionado!.idDeporte, ControlSesion.datosusuario!.idUsuario, observaciones, lugar, todosLosEstudiantes);
  }

  @override
  Widget build(BuildContext context) {
    controllistadeporte = context.watch<ControlListaDeporte>();
    controllistadeporteprofesor = context.watch<ControlListaDeportesProfesor>();
    todosLosEstudiantes = controllistadeporte!.estudiantes;
    estudiantesFiltrados = _filtrarEstudiantes(todosLosEstudiantes);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blanco,
        title: SizedBox(
          width: double.infinity,
          child: Text(
            S.of(context).label_tomarasistencia,
            style: AppColors.textotitulonegro,
            maxLines: 2, // Permite hasta 2 líneas
            overflow: TextOverflow.ellipsis, // Muestra "..." si es muy largo
            textAlign: TextAlign.center,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.verde,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconoAsistencia(
              color: AppColors.blanco,
              backgroundColor: AppColors.verde,
              size: 30,
              borderRadius: 10,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _actualizarFiltro,
              decoration: DecoracionCampoVerde(icono: Icons.search, letrero: S.of(context).label_buscarestudiante),
              style: AppColors.textosubtitulonegro,
            ),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            color: AppColors.blanco,
            image: DecorationImage(
              image: AssetImage('assets/img/logoirdcotafondo.png'),
              fit: BoxFit.contain, // La imagen se muestra completa sin recortarse
              alignment: Alignment.center, // Centrada en la pantalla
              opacity: 0.3,
              // Opcional: color de fondo si la imagen no cubre toda el área
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstOver),
            ),
          ),
          child: estudiantesFiltrados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        filtroBusqueda.isEmpty ? Icons.people_outline : Icons.search_off,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        filtroBusqueda.isEmpty ? 'No hay estudiantes registrados' : 'No se encontraron estudiantes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: estudiantesFiltrados.length,
                  itemBuilder: (context, index) {
                    EstudianteDeporte estudiante = estudiantesFiltrados[index];

                    // Inicializar estado si no existe
                    if (!estadosAsistencia.containsKey(estudiante.id)) {
                      estadosAsistencia[estudiante.id] = 'Asistió';
                    }

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            // Icono de estudiante

                            const SizedBox(width: 12),

                            // Nombre del estudiante
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    estudiante.nombre,
                                    style: AppColors.textosubtitulonegro,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${S.of(context).label_matricula}: ${estudiante.matriculas[0]}',
                                    style: AppColors.textosecundariogris,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${S.of(context).label_estado}: ${estudiante.status}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Selector de asistencia compacto
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: estudiante.status,
                                icon: const Icon(Icons.arrow_drop_down, size: 20),
                                elevation: 8,
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontSize: 14,
                                ),
                                underline: const SizedBox(),
                                onChanged: (String? nuevoValor) {
                                  setState(() {
                                    estudiante.status = nuevoValor!;
                                  });
                                },
                                items: opcionesAsistencia.map<DropdownMenuItem<String>>((String valor) {
                                  return DropdownMenuItem<String>(
                                    value: valor,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getIconForEstado(valor),
                                          size: 16,
                                          color: _getColorForEstado(valor),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          valor,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: SizedBox(
          width: 180,
          height: 45,
          child: ElevatedButton(
            onPressed: estudiantesFiltrados.isEmpty ? null : _mostrarDialogoDetalles,
            style: AppColors.botonverde,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon(Icons.save, size: 18),
                SizedBox(width: 6),
                Text(
                  S.of(context).label_enviar,
                  style: AppColors.textosubtituloblanco,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Método auxiliar para obtener el icono según el estado
  IconData _getIconForEstado(String estado) {
    switch (estado) {
      case 'Asistió':
        return Icons.check_circle;
      case 'Faltó':
        return Icons.cancel;
      case 'Tarde':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  // Método auxiliar para obtener el color según el estado
  Color _getColorForEstado(String estado) {
    switch (estado) {
      case 'Asistió':
        return Colors.green;
      case 'Faltó':
        return Colors.red;
      case 'Tarde':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
