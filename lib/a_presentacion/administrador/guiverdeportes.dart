import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeportesScreen extends StatefulWidget {
  const DeportesScreen({super.key});

  @override
  State<DeportesScreen> createState() => _DeportesScreenState();
}

class _DeportesScreenState extends State<DeportesScreen> {
  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  // Variable para almacenar el texto de búsqueda
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ControlListaDeportesAdministrador controlListaDeportes = context.watch<ControlListaDeportesAdministrador>();
    controlListaDeportes.cargarListaDeportes();
    List<Deporte> deportes = controlListaDeportes.deportes;

    // Filtrar deportes según la búsqueda
    List<Deporte> deportesFiltrados = deportes.where((deporte) {
      return deporte.nombreDeporte.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deportes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Cuadro de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar deporte...',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Contador de resultados
          if (deportesFiltrados.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                '${deportesFiltrados.length} deporte${deportesFiltrados.length != 1 ? 's' : ''} encontrado${deportesFiltrados.length != 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Lista de deportes
          Expanded(
            child: deportesFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.sports_soccer : Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No hay deportes disponibles' : 'No se encontraron deportes para "${_searchQuery}"',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: const Text('Limpiar búsqueda'),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: deportesFiltrados.length,
                    itemBuilder: (context, index) {
                      final deporte = deportesFiltrados[index];

                      return GestureDetector(
                        onTap: () {
                          _mostrarDialogoDetalles(context, deporte, controlListaDeportes);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: deporte.ofrecidoALosPadres ? Colors.green : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Fila superior: Nombre del deporte y checkbox
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nombre del deporte (expandido)
                                    Expanded(
                                      child: Text(
                                        deporte.nombreDeporte,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                        maxLines: null,
                                      ),
                                    ),

                                    // Checkbox y etiqueta
                                    Column(
                                      children: [
                                        Checkbox(
                                          value: deporte.ofrecidoALosPadres,
                                          onChanged: null, // Solo lectura
                                          activeColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        const Text(
                                          'Ofrecido a\npadres',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Línea divisoria decorativa
                                Container(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),

                                const SizedBox(height: 12),

                                // Grid de información
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: [
                                    // ID
                                    _buildInfoChip(
                                      icon: Icons.tag,
                                      label: 'ID: ${deporte.idDeporte}',
                                      color: Colors.blue,
                                    ),

                                    // Edad mínima
                                    _buildInfoChip(
                                      icon: Icons.arrow_downward,
                                      label: 'Mín: ${deporte.edadMinima} años',
                                      color: Colors.orange,
                                    ),

                                    // Edad máxima
                                    _buildInfoChip(
                                      icon: Icons.arrow_upward,
                                      label: 'Máx: ${deporte.edadMaxima} años',
                                      color: Colors.orange,
                                    ),

                                    // Estudiantes permitidos
                                    _buildInfoChip(
                                      icon: Icons.people,
                                      label: '${deporte.cantidadEstudiantesPermitidos} estudiantes',
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Botón flotante para agregar
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAgregarDeporte(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),*/
    );
  }

  // Widget auxiliar para crear chips de información
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoDetalles(BuildContext context, Deporte deporte, ControlListaDeportesAdministrador controllistadeportes) {
    // Controladores para los campos editables
    final TextEditingController _edadMinimaController = TextEditingController(text: deporte.edadMinima.toString());
    final TextEditingController _edadMaximaController = TextEditingController(text: deporte.edadMaxima.toString());
    final TextEditingController _estudiantesController = TextEditingController(text: deporte.cantidadEstudiantesPermitidos.toString());

    // Variable para el checkbox de ofrecido a padres
    bool _ofrecidoALosPadres = deporte.ofrecidoALosPadres;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.sports, color: AppColors.verde),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Editar Deporte',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.verde,
                      ),
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del deporte destacado (no editable)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.verde.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.verde.withOpacity(0.3)),
                        ),
                        child: Text(
                          deporte.nombreDeporte,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.verde,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ID (solo lectura)
                      _buildDetalleRow(Icons.tag, 'ID:', deporte.idDeporte),
                      const Divider(),

                      // Edad mínima (editable)
                      _buildCampoEditable(
                        icon: Icons.arrow_downward,
                        label: 'Edad mínima:',
                        controller: _edadMinimaController,
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(),

                      // Edad máxima (editable)
                      _buildCampoEditable(
                        icon: Icons.arrow_upward,
                        label: 'Edad máxima:',
                        controller: _edadMaximaController,
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(),

                      // Estudiantes permitidos (editable)
                      _buildCampoEditable(
                        icon: Icons.people,
                        label: 'Estudiantes permitidos:',
                        controller: _estudiantesController,
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(),

                      // Ofrecido a padres (checkbox editable)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.family_restroom,
                              size: 20,
                              color: _ofrecidoALosPadres ? AppColors.verde : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Ofrecido a padres:',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _ofrecidoALosPadres,
                                  onChanged: (bool? valor) {
                                    setState(() {
                                      _ofrecidoALosPadres = valor ?? false;
                                    });
                                  },
                                  activeColor: AppColors.verde,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                      color: AppColors.verde.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Text(
                                  _ofrecidoALosPadres ? 'Sí' : 'No',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _ofrecidoALosPadres ? AppColors.verde : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Nota informativa
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.verde.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, size: 16, color: AppColors.verde),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Los cambios se aplicarán al deporte seleccionado',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.verde,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // Fila de botones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Botón Cancelar
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            minimumSize: const Size(80, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: AppColors.verde,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botón Guardar cambios
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            
                            bool resultado = await controllistadeportes.modificarDeporte('deporte', deporte.idDeporte, int.tryParse(_estudiantesController.text)!, _ofrecidoALosPadres??false,
                                int.tryParse(_edadMinimaController.text)!, int.tryParse(_edadMaximaController.text)!);
                            if (resultado) {
                              mostrarMensajeInferior(context, 'El deporte se actualizó con éxito', colorFondo: AppColors.verde);
                              
                            } else {
                              mostrarMensajeInferior(context, 'El deporte no se pudo actualizar', colorFondo: AppColors.rojo);
                            }
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.verde,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            minimumSize: const Size(80, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Widget auxiliar para campos editables con AppColors.verde
  Widget _buildCampoEditable({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.verde),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.verde.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.verde, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.verde.withOpacity(0.3)),
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.verde,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Widget auxiliar para filas de detalles (solo lectura)
  Widget _buildDetalleRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.verde),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.verde,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Función para mostrar diálogo de agregar deporte
  /*void _mostrarDialogoAgregarDeporte(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Deporte'),
          content: const Text('Funcionalidad en desarrollo'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí iría la lógica para agregar
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }*/
}
