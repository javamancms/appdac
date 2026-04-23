import 'package:appdac/a_presentacion/administrador/guiinscribirdeporte.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/c_integracion/intestudiantes.dart';
import 'package:appdac/generated/l10n.dart';
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
        backgroundColor: AppColors.blanco,
        title: Center(
          child: Text(
            S.of(context).label_listaestudiantes,
            style: AppColors.textotitulonegro,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.verde,
        ),
        actions: [
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(color: AppColors.verde, borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Icons.menu_book,
              color: AppColors.blanco,
            ),
          ),
        ],
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
        child: estudiantes.isEmpty
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
            backgroundColor: AppColors.rojo,
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
              color: AppColors.grisclaro,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.verde,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: DecoracionCampoVerde(icono: Icons.search, hintLetrero: S.of(context).label_buscarestudiante),
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
                  label: S.of(context).label_todos,
                  icon: Icons.people,
                  isSelected: _estadoFiltro == 'Todos',
                  onTap: () => _cambiarFiltroEstado('Todos'),
                ),
                const SizedBox(width: 8),
                _FiltroButton(
                  label: S.of(context).label_revision,
                  icon: Icons.pending_actions,
                  isSelected: _estadoFiltro == 'En revision',
                  color: AppColors.naranja,
                  onTap: () => _cambiarFiltroEstado('En revision'),
                ),
                const SizedBox(width: 8),
                _FiltroButton(
                  label: S.of(context).label_verificado,
                  icon: Icons.verified,
                  isSelected: _estadoFiltro == 'Verificado',
                  color: AppColors.verde,
                  onTap: () => _cambiarFiltroEstado('Verificado'),
                ),
                const SizedBox(width: 8),
                _FiltroButton(
                  label: S.of(context).label_devuelto,
                  icon: Icons.assignment_return,
                  isSelected: _estadoFiltro == 'Devuelto',
                  color: AppColors.rojo,
                  onTap: () => _cambiarFiltroEstado('Devuelto'),
                ),
              ],
            ),
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
                        color: AppColors.grisclaro,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron estudiantes',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.gris,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otro término de búsqueda o filtro',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grisclaro,
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
              color: AppColors.grisclaro,
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
                    color: AppColors.gris,
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
    final Color selectedColor = color ?? AppColors.azulrey;

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
              style: AppColors.textosecundarionegro,
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
        return AppColors.naranja;
      case 'Verificado':
        return AppColors.verde;
      case 'Devuelto':
        return AppColors.rojo;
      default:
        return AppColors.grisclaro;
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
                        style: AppColors.textosubtitulonegro,
                      ),
                      const SizedBox(height: 4),
                      // Badge de estado de revisión
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getColorForEstado(estudiante.estadoRevision).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.estaEnProceso ? AppColors.grisclaro : _getColorForEstado(estudiante.estadoRevision),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.estaEnProceso ? '...' : estudiante.estadoRevision,
                          style: AppColors.textosubtituloverde,
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
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.azulrey),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '...',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            estudiante.activo ? S.of(context).label_activo : S.of(context).label_inactivo,
                            style: AppColors.textosecundarionegro,
                          ),
                          Checkbox(
                            value: estudiante.activo,
                            onChanged: (bool? value) => widget.onToggleActivo(),
                            activeColor: AppColors.verde,
                            checkColor: AppColors.blanco,
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
                  label: S.of(context).label_documento,
                  value: _buildHighlightedText(
                    estudiante.documento.toString(),
                    widget.searchQuery,
                    style: AppColors.textosubtitulonegro,
                  ),
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.person,
                  label: S.of(context).label_usuario,
                  value: Text(
                    estudiante.usuario.isNotEmpty ? estudiante.usuario.first : 'Sin usuario',
                    style: AppColors.textosubtitulonegro,
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
                      labelColor: AppColors.azulrey,
                      unselectedLabelColor: AppColors.gris,
                      indicatorColor: AppColors.azulrey,
                      labelStyle: AppColors.textosubtitulonegro,
                      tabs: [
                        Tab(text: S.of(context).label_salud),
                        Tab(text: S.of(context).label_identificacion),
                        Tab(text: S.of(context).label_familia),
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
                              _InfoRow(icon: Icons.medical_services, label: S.of(context).label_eps, value: Text(estudiante.eps)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.health_and_safety, label: S.of(context).label_regimaneps, value: Text(estudiante.tipoRegimenEps)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.bloodtype, label: S.of(context).label_gruposanguineo, value: Text(estudiante.grupoSanguineo)),
                              const SizedBox(height: 4),
                              if (estudiante.alergias != null && estudiante.alergias!.isNotEmpty) _InfoRow(icon: Icons.warning, label: S.of(context).label_alergias, value: Text(estudiante.alergias!)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.medication, label: S.of(context).label_tomamedicamentos, value: Text(estudiante.tomaMedicamentos)),
                              const SizedBox(height: 4),
                              if (estudiante.condicionesMedicas != null && estudiante.condicionesMedicas!.isNotEmpty)
                                _InfoRow(icon: Icons.health_and_safety, label: S.of(context).label_condicionesmedicas, value: Text(estudiante.condicionesMedicas!)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.sick, label: S.of(context).label_enfermedadesprevias, value: Text(estudiante.enfermedadesPrevias)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.local_hospital, label: S.of(context).label_cirugiasprevias, value: Text(estudiante.cirugiasPrevias)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.sports_mma, label: S.of(context).label_lesionesprevias, value: Text(estudiante.lesionesPrevias)),
                              const SizedBox(height: 8),
                              if (estudiante.copiaCertificadoEps.isNotEmpty)
                                _DocumentoLink(
                                  icon: Icons.assignment,
                                  label: S.of(context).label_certificadoeps,
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
                              _InfoRow(icon: Icons.email, label: S.of(context).label_email, value: Text(estudiante.email)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.wc, label: S.of(context).label_genero, value: Text(estudiante.genero)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.location_city, label: S.of(context).label_lugarnacimiento, value: Text(estudiante.lugarNacimiento)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.location_on, label: S.of(context).label_lugarexpedicion, value: Text(estudiante.lugarExpedicion)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.home, label: S.of(context).label_direccion, value: Text(estudiante.direccion)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.landscape, label: S.of(context).label_veredasector, value: Text(estudiante.veredaSector)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.school, label: S.of(context).label_instieducativa, value: Text(estudiante.institucionEducativa)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.grade, label: S.of(context).label_gradoescolar, value: Text(estudiante.gradoEscolar)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.people, label: S.of(context).label_tipopoblacion, value: Text(estudiante.tipoPoblacion)),
                              const SizedBox(height: 8),
                              if (estudiante.identificacion.isNotEmpty)
                                _DocumentoLink(
                                  icon: Icons.badge,
                                  label: S.of(context).label_documentoid,
                                  archivo: estudiante.identificacion.first,
                                  onTap: widget.onUrlTap,
                                ),
                              if (estudiante.consentimiento != null && estudiante.consentimiento!.isNotEmpty)
                                _DocumentoLink(
                                  icon: Icons.description,
                                  label: S.of(context).label_consentimientodoc,
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
                              _InfoRow(icon: Icons.person, label: S.of(context).label_nombresacudiente, value: Text(estudiante.nombresAcudiente1)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.person_outline, label: S.of(context).label_apellidosacudiente, value: Text(estudiante.apellidosAcudiente1)),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.badge, label: S.of(context).label_documentoacudiente, value: Text(estudiante.documentoAcudiente1.toString())),
                              const SizedBox(height: 4),
                              _InfoRow(icon: Icons.phone, label: S.of(context).label_celularacudiente, value: Text(estudiante.celularAcudiente1)),
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
                      style: AppColors.botonverde,
                      child: Text(S.of(context).label_editarcursos),
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
                                controllistaestudiantes.cambiarEstadoDeRevisionEstudiante(estudiante.idEstudiante, newValue, comentario: motivo);

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
          title: Text(
            S.of(context).label_motivodevolucion,
            style: AppColors.textotitulonegro,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).label_motivodevolucionexp,
                style: AppColors.textoinformativogris,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: motivoController,
                decoration: DecoracionCampoVerde(),
                maxLines: 3,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              style: AppColors.botonblanco,
              child: Text(
                S.of(context).label_cancelar,
                style: TextStyle(color: AppColors.gris),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (motivoController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debe ingresar un motivo'),
                      backgroundColor: AppColors.rojo,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop(motivoController.text.trim());
              },
              style: AppColors.botonverde,
              child: Text(S.of(context).label_enviar),
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
            backgroundColor: AppColors.amarillo,
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
            Icon(icon, color: AppColors.azulrey, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.azulrey,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.open_in_new, color: AppColors.azulrey, size: 16),
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
        Icon(icon, size: 16, color: AppColors.gris),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: AppColors.textosubtitulonegro,
          ),
        ),
        Expanded(child: value),
      ],
    );
  }
}
