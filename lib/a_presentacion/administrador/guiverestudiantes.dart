import 'package:appdac/a_presentacion/administrador/guiinscribirdeporte.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/c_integracion/intestudiantes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EstudiantesScreen extends StatelessWidget {
  const EstudiantesScreen({super.key});

  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    ControlListaEstudiantesAdministrador controllistaestudiantes = context.watch<ControlListaEstudiantesAdministrador>();
    controllistaestudiantes.cargarEstudiantes();
    List<Estudiante> estudiantes = controllistaestudiantes.estudiantes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de estudiantes'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: estudiantes.isEmpty
          ? const Center(
              child: Text(
                'Cargando estudiantes...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : EstudianteList(
              estudiantes: estudiantes,
              onUrlTap: _abrirUrl,
            ),
    );
  }
}

class EstudianteList extends StatefulWidget {
  final List<Estudiante> estudiantes;
  final Function(String) onUrlTap;

  const EstudianteList({
    super.key,
    required this.estudiantes,
    required this.onUrlTap,
  });

  @override
  State<EstudianteList> createState() => _EstudianteListState();
}

class _EstudianteListState extends State<EstudianteList> {
  final TextEditingController _searchController = TextEditingController();
  List<Estudiante> _filteredEstudiantes = [];
  String _searchQuery = '';
  String _estadoFiltro = 'Todos';
  
  // Conjunto para trackear qué estudiantes están en proceso de cambio
  final Set<String> _estudiantesEnProceso = {};

  @override
  void initState() {
    super.initState();
    _filteredEstudiantes = widget.estudiantes;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(EstudianteList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.estudiantes != widget.estudiantes) {
      _aplicarFiltros();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    setState(() {
      _searchQuery = _searchController.text;

      List<Estudiante> tempList = widget.estudiantes;

      if (_estadoFiltro != 'Todos') {
        tempList = tempList.where((estudiante) => estudiante.estadoRevision == _estadoFiltro).toList();
      }

      if (_searchQuery.isNotEmpty) {
        tempList = tempList.where((estudiante) {
          final nombreCompleto = '${estudiante.nombre} ${estudiante.apellidosDeportista}'.toLowerCase();
          final documento = estudiante.documento.toString();
          final queryLower = _searchQuery.toLowerCase();

          return nombreCompleto.contains(queryLower) || documento.contains(_searchQuery);
        }).toList();
      }

      _filteredEstudiantes = tempList;
    });
  }

  void _cambiarFiltroEstado(String estado) {
    setState(() {
      _estadoFiltro = estado;
      _aplicarFiltros();
    });
  }

  void _limpiarBusqueda() {
    _searchController.clear();
  }

  Future<void> _toggleActivo(Estudiante estudiante) async {
    // Verificar si ya está en proceso
    if (_estudiantesEnProceso.contains(estudiante.idEstudiante)) {
      return;
    }

    setState(() {
      _estudiantesEnProceso.add(estudiante.idEstudiante);
    });

    try {
      final controllistaestudiantes = context.read<ControlListaEstudiantesAdministrador>();
      await controllistaestudiantes.cambiarEstadoEstudiante(estudiante.idEstudiante);
      
      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${estudiante.nombre} ${estudiante.apellidosDeportista}: ${!estudiante.activo ? 'Activado' : 'Desactivado'} correctamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Mostrar mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar estado: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _estudiantesEnProceso.remove(estudiante.idEstudiante);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o documento...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: _limpiarBusqueda,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),

        // Botones de filtrado por estado
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FiltroButton(
                  label: 'Todos',
                  icon: Icons.people,
                  isSelected: _estadoFiltro == 'Todos',
                  onTap: () => _cambiarFiltroEstado('Todos'),
                ),
                const SizedBox(width: 8),
                _FiltroButton(
                  label: 'En revisión',
                  icon: Icons.pending_actions,
                  isSelected: _estadoFiltro == 'En revision',
                  color: Colors.orange,
                  onTap: () => _cambiarFiltroEstado('En revision'),
                ),
                const SizedBox(width: 8),
                _FiltroButton(
                  label: 'Verificado',
                  icon: Icons.verified,
                  isSelected: _estadoFiltro == 'Verificado',
                  color: Colors.green,
                  onTap: () => _cambiarFiltroEstado('Verificado'),
                ),
                const SizedBox(width: 8),
                _FiltroButton(
                  label: 'Devuelto',
                  icon: Icons.assignment_return,
                  isSelected: _estadoFiltro == 'Devuelto',
                  color: Colors.red,
                  onTap: () => _cambiarFiltroEstado('Devuelto'),
                ),
              ],
            ),
          ),
        ),

        // Indicador de filtro activo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Filtro activo: $_estadoFiltro',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Resultados de la búsqueda
        Expanded(
          child: _filteredEstudiantes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron estudiantes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otro término de búsqueda o filtro',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _filteredEstudiantes.length,
                  itemBuilder: (context, index) {
                    final estudiante = _filteredEstudiantes[index];
                    final bool estaEnProceso = _estudiantesEnProceso.contains(estudiante.idEstudiante);
                    
                    return EstudianteCard(
                      estudiante: estudiante,
                      onUrlTap: widget.onUrlTap,
                      searchQuery: _searchQuery,
                      estaEnProceso: estaEnProceso,
                      onToggleActivo: () => _toggleActivo(estudiante),
                    );
                  },
                ),
        ),

        // Contador de resultados
        if (_filteredEstudiantes.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mostrando ${_filteredEstudiantes.length} de ${widget.estudiantes.length} estudiantes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                if (_searchQuery.isNotEmpty || _estadoFiltro != 'Todos')
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _cambiarFiltroEstado('Todos');
                    },
                    child: const Text('Limpiar filtros'),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// Widget para los botones de filtro
class _FiltroButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FiltroButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = color ?? Colors.blue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? selectedColor : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? selectedColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EstudianteCard extends StatefulWidget {
  final Estudiante estudiante;
  final Function(String) onUrlTap;
  final String searchQuery;
  final bool estaEnProceso;
  final VoidCallback onToggleActivo;

  const EstudianteCard({
    super.key,
    required this.estudiante,
    required this.onUrlTap,
    this.searchQuery = '',
    required this.estaEnProceso,
    required this.onToggleActivo,
  });

  @override
  State<EstudianteCard> createState() => _EstudianteCardState();
}

class _EstudianteCardState extends State<EstudianteCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late TabController _tabController;
  String _selectedEstadoRevision = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedEstadoRevision = widget.estudiante.estadoRevision;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getColorForEstado(String estado) {
    switch (estado) {
      case 'En revision':
        return Colors.orange;
      case 'Verificado':
        return Colors.green;
      case 'Devuelto':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    ControlListaEstudiantesAdministrador controllistaestudiantes = context.watch<ControlListaEstudiantesAdministrador>();

    ControlInscribirDeportes inscripciondeportes = context.watch<ControlInscribirDeportes>();

    final estudiante = widget.estudiante;
    final nombreCompleto = '${estudiante.nombre} ${estudiante.apellidosDeportista}';

    final String estado_revision = 'En revision';
    final String estado_verificado = 'Verificado';
    final String estado_devuelto = 'Devuelto';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: widget.estaEnProceso ? Colors.grey[200] : null,
      child: Column(
        children: [
          // Cabecera de la tarjeta (siempre visible)
          ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHighlightedText(
                        nombreCompleto,
                        widget.searchQuery,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.estaEnProceso ? Colors.grey[600] : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Badge de estado de revisión
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getColorForEstado(estudiante.estadoRevision).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.estaEnProceso 
                                ? Colors.grey 
                                : _getColorForEstado(estudiante.estadoRevision),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.estaEnProceso ? 'Actualizando...' : estudiante.estadoRevision,
                          style: TextStyle(
                            fontSize: 11,
                            color: widget.estaEnProceso 
                                ? Colors.grey 
                                : _getColorForEstado(estudiante.estadoRevision),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Checkbox o indicador de progreso para activo/inactivo
                widget.estaEnProceso
                    ? Container(
                        width: 80,
                        height: 50,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Actualizando...',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            estudiante.activo ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                              fontSize: 12,
                              color: estudiante.activo ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Checkbox(
                            value: estudiante.activo,
                            onChanged: (bool? value) => widget.onToggleActivo(),
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                          ),
                        ],
                      ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.badge,
                  label: 'Documento',
                  value: _buildHighlightedText(
                    estudiante.documento.toString(),
                    widget.searchQuery,
                    style: TextStyle(
                      color: widget.estaEnProceso ? Colors.grey[600] : null,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.person,
                  label: 'Usuario',
                  value: Text(
                    estudiante.usuario.isNotEmpty ? estudiante.usuario.first : 'Sin usuario',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.estaEnProceso ? Colors.grey[600] : null,
                    ),
                  ),
                ),
              ],
            ),
            onTap: widget.estaEnProceso 
                ? null // Deshabilitar tap mientras procesa
                : () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
          ),

          // Contenido expandido (solo visible si no está en proceso)
          if (_isExpanded && !widget.estaEnProceso)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pestañas
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: const [
                        Tab(text: 'Salud'),
                        Tab(text: 'Identificación'),
                        Tab(text: 'Familia'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Contenido de las pestañas
                  SizedBox(
                    height: 320, // Altura fija para el contenido de las pestañas
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Pestaña Salud
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(icon: Icons.medical_services, label: 'EPS', value: Text(estudiante.eps)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.health_and_safety, label: 'Régimen EPS', value: Text(estudiante.tipoRegimenEps)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.bloodtype, label: 'Grupo Sanguíneo', value: Text(estudiante.grupoSanguineo)),
                              const SizedBox(height: 4),
                              if (estudiante.alergias != null && estudiante.alergias!.isNotEmpty) _InfoRow(icon: Icons.warning, label: 'Alergias', value: Text(estudiante.alergias!)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.medication, label: 'Toma Medicamentos', value: Text(estudiante.tomaMedicamentos)),
                              const SizedBox(height: 4),
                              if (estudiante.condicionesMedicas != null && estudiante.condicionesMedicas!.isNotEmpty)
                                _InfoRow(icon: Icons.health_and_safety, label: 'Condiciones Médicas', value: Text(estudiante.condicionesMedicas!)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.sick, label: 'Enfermedades Previas', value: Text(estudiante.enfermedadesPrevias)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.local_hospital, label: 'Cirugías Previas', value: Text(estudiante.cirugiasPrevias)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.sports_mma, label: 'Lesiones Previas', value: Text(estudiante.lesionesPrevias)),
                              const SizedBox(height: 8),
                              if (estudiante.copiaCertificadoEps.isNotEmpty)
                                _DocumentoLink(
                                  icon: Icons.assignment,
                                  label: 'Certificado EPS',
                                  archivo: estudiante.copiaCertificadoEps.first,
                                  onTap: widget.onUrlTap,
                                ),
                            ],
                          ),
                        ),

                        // Pestaña Identificación
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(icon: Icons.email, label: 'Email', value: Text(estudiante.email)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.wc, label: 'Género', value: Text(estudiante.genero)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.location_city, label: 'Lugar Nacimiento', value: Text(estudiante.lugarNacimiento)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.location_on, label: 'Lugar Expedición', value: Text(estudiante.lugarExpedicion)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.home, label: 'Dirección', value: Text(estudiante.direccion)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.landscape, label: 'Vereda/Sector', value: Text(estudiante.veredaSector)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.school, label: 'Institución Educativa', value: Text(estudiante.institucionEducativa)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.grade, label: 'Grado Escolar', value: Text(estudiante.gradoEscolar)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.people, label: 'Tipo Población', value: Text(estudiante.tipoPoblacion)),
                              const SizedBox(height: 8),
                              if (estudiante.identificacion.isNotEmpty)
                                _DocumentoLink(
                                  icon: Icons.badge,
                                  label: 'DOCUMENTO ID',
                                  archivo: estudiante.identificacion.first,
                                  onTap: widget.onUrlTap,
                                ),
                              if (estudiante.consentimiento != null && estudiante.consentimiento!.isNotEmpty)
                                _DocumentoLink(
                                  icon: Icons.description,
                                  label: 'CONSENTIMIENTO',
                                  archivo: estudiante.consentimiento!.first,
                                  onTap: widget.onUrlTap,
                                ),
                            ],
                          ),
                        ),

                        // Pestaña Familia
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(icon: Icons.person, label: 'Nombres Acudiente', value: Text(estudiante.nombresAcudiente1)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.person_outline, label: 'Apellidos Acudiente', value: Text(estudiante.apellidosAcudiente1)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.badge, label: 'Documento Acudiente', value: Text(estudiante.documentoAcudiente1.toString())),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.phone, label: 'Celular Acudiente', value: Text(estudiante.celularAcudiente1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botón Editar cursos
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await inscripciondeportes.cargarDeportes(estudiante.idEstudiante);
                        VerDeportesEstudiantesScreen.mostrarDialogo(context, estudiante);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Editar cursos'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Combo de selección para Estado de Revisión
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedEstadoRevision,
                      isExpanded: true,
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: [estado_revision, estado_verificado, estado_devuelto].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getColorForEstado(value),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          if (newValue == estado_devuelto) {
                            // Mostrar diálogo para motivo de devolución
                            _mostrarDialogoMotivoDevolucion(context).then((motivo) {
                              if (motivo != null && motivo.isNotEmpty) {
                                setState(() {
                                  _selectedEstadoRevision = newValue;
                                });
                                // Aquí puedes guardar el motivo junto con el cambio de estado
                                print('Motivo de devolución: $motivo');
                                controllistaestudiantes.cambiarEstadoDeRevisionEstudiante(estudiante.idEstudiante, newValue,comentario: motivo);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Estado cambiado a: $newValue\nMotivo: $motivo'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                // Si no ingresa motivo, revertir al estado anterior
                                setState(() {
                                  _selectedEstadoRevision = widget.estudiante.estadoRevision;
                                });
                              }
                            });
                          } else {
                            setState(() {
                              _selectedEstadoRevision = newValue;
                            });

                            controllistaestudiantes.cambiarEstadoDeRevisionEstudiante(estudiante.idEstudiante, newValue);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Estado cambiado a: $newValue'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<String?> _mostrarDialogoMotivoDevolucion(BuildContext context) {
    final TextEditingController motivoController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Motivo Devolución',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Por favor ingrese el motivo de la devolución:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: motivoController,
                decoration: InputDecoration(
                  hintText: 'Escriba el motivo aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 3,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (motivoController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debe ingresar un motivo'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop(motivoController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighlightedText(String text, String query, {TextStyle? style}) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: style);
    }

    final matches = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        matches.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        matches.add(TextSpan(text: text.substring(start, index)));
      }

      matches.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + query.length;
    }

    return RichText(
      text: TextSpan(
        children: matches,
        style: style ?? const TextStyle(fontSize: 13),
      ),
    );
  }
}

class _DocumentoLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final Archivo archivo;
  final Function(String) onTap;

  const _DocumentoLink({
    required this.icon,
    required this.label,
    required this.archivo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(archivo.url),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.blue, size: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(child: value),
      ],
    );
  }
}