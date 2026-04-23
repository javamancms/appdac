import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/c_integracion/intdeportes.dart';
import 'package:appdac/generated/l10n.dart';
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
        backgroundColor: AppColors.blanco,
        title: Center(
          child: Text(
            S.of(context).label_listadeportes,
            style: AppColors.textotitulonegro,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.verde,
        ),
        actions: [
          IconoDeporte(
            color: AppColors.blanco,
            backgroundColor: AppColors.verde,
            size: 60,
            borderRadius: 10,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: S.of(context).label_buscardeporte,
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                helperText: S.of(context).label_buscardeporteexp,
                helperStyle: AppColors.textoinformativogris,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.blanco, 
          image: DecorationImage(
            image: AssetImage('assets/img/logoirdcotafondo.png'),
            fit: BoxFit.contain,
            alignment: Alignment.center,
            opacity: 0.3,
          ),
        ),
        child: Column(
          children: [
            // Contador de resultados
            if (deportesFiltrados.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${deportesFiltrados.length} ${S.of(context).label_deportesencontrados}',
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
                                color: AppColors.blanco,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Fila superior: Nombre del deporte a la izquierda y checkbox a la derecha
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Columna izquierda: Nombre del deporte
                                      Expanded(
                                        child: Text(
                                          deporte.nombreDeporte,
                                          style: AppColors.textosubtitulonegro,
                                          softWrap: true,
                                          maxLines: null,
                                        ),
                                      ),
                                      // Columna derecha: Checkbox y etiqueta en fila
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            value: deporte.ofrecidoALosPadres,
                                            onChanged: null,
                                            activeColor: AppColors.verde,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          Text(
                                            S.of(context).label_ofrecidoapadres,
                                            style: AppColors.textosecundarionegro,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // ID del deporte
                                  Text(
                                    'ID: ${deporte.idDeporte}',
                                    style: AppColors.textosubtitulogris,
                                  ),

                                  const SizedBox(height: 12),

                                  // Línea divisoria decorativa
                                  Container(
                                    height: 1,
                                    color: Colors.grey[200],
                                  ),

                                  const SizedBox(height: 12),

                                  // Fila de información: Estudiantes, Edad mínima, Edad máxima - CORREGIDO CON WRAP
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 8,
                                    children: [
                                      // Cantidad de estudiantes
                                      _buildInfoItem(
                                        icon: Icons.people,
                                        label: '${deporte.cantidadEstudiantesPermitidos} estudiantes',
                                      ),
                                      // Edad mínima
                                      _buildInfoItem(
                                        icon: Icons.arrow_downward,
                                        label: 'Mín: ${deporte.edadMinima} años',
                                      ),
                                      // Edad máxima
                                      _buildInfoItem(
                                        icon: Icons.arrow_upward,
                                        label: 'Máx: ${deporte.edadMaxima} años',
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
      ),
    );
  }

  // Widget auxiliar para crear elementos de información en fila
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.verde,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppColors.textosecundarionegro,
        ),
      ],
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
                  IconoDeporte(backgroundColor: AppColors.verde, color: AppColors.blanco,borderRadius: 10,size: 30,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      S.of(context).label_editardeporte,
                      style: AppColors.textotitulonegro,
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
                          border: Border.all(color: AppColors.verde),
                        ),
                        child: Text(
                          deporte.nombreDeporte,
                          style: AppColors.textosubtituloverde,
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
                        label: S.of(context).label_edadminima,
                        controller: _edadMinimaController,
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(),

                      // Edad máxima (editable)
                      _buildCampoEditable(
                        icon: Icons.arrow_upward,
                        label: S.of(context).label_edadmaxima,
                        controller: _edadMaximaController,
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(),

                      // Estudiantes permitidos (editable)
                      _buildCampoEditable(
                        icon: Icons.people,
                        label: S.of(context).label_estudiantespermitidos,
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
                              color: _ofrecidoALosPadres ? AppColors.verde : AppColors.grisclaro,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                S.of(context).label_ofrecidoapadres,
                                style: AppColors.textosecundarionegro,
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
                                  _ofrecidoALosPadres ? S.of(context).label_si : S.of(context).label_no,
                                  style: AppColors.textosecundarionegro,
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
                                S.of(context).msj_deporteseleccionado,
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
                          style: AppColors.botonblanco,
                          child: Text(
                            S.of(context).label_cancelar,
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
                            bool resultado = await controllistadeportes.modificarDeporte('deporte', deporte.idDeporte, int.tryParse(_estudiantesController.text)!, _ofrecidoALosPadres ?? false,
                                int.tryParse(_edadMinimaController.text)!, int.tryParse(_edadMaximaController.text)!);
                            if (resultado) {
                              mostrarMensajeInferior(context, S.of(context).msj_deporteactualizadoconexito, colorFondo: AppColors.verde);
                            } else {
                              mostrarMensajeInferior(context, S.of(context).msj_deporteactualizadoconerror, colorFondo: AppColors.rojo);
                            }
                            Navigator.of(context).pop();
                          },
                          style: AppColors.botonverde,
                          child: Text(
                            S.of(context).label_guardar,
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
              style: AppColors.textosecundarionegro,
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
              style: AppColors.textosecundarionegro,
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
            style: AppColors.textosecundarionegro,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppColors.textosecundarionegro,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}