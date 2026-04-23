import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeporteEstudiantesScreen extends StatelessWidget {
  const DeporteEstudiantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaDeporte controllistadeporte = context.watch<ControlListaDeporte>();
    List<EstudianteDeporte> estudiantes = controllistadeporte.estudiantes;

    return Scaffold(
        /*appBar: AppBar(
        title: Text('Estudiantes (${estudiantes.length})'),
      ),*/
        appBar: AppBar(
          backgroundColor: AppColors.blanco,
          title: Center(
            child: Text(
              '${S.of(context).label_estudiantes} (${estudiantes.length})',
              style: AppColors.textotitulonegro,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            color: AppColors.verde,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.verde,
                ),
                child: Icon(
                  Icons.menu_book,
                  size: 30,
                  color: AppColors.blanco,
                ),
              ),
            )
            /*IconoDeporte(
              color: AppColors.blanco,
              backgroundColor: AppColors.verde,
              size: 30,
              borderRadius: 10,
            )*/
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
              // Elimina el colorFilter
            ),
          ),
          child: estudiantes.isEmpty
              ? const Center(
                  child: Text('No hay estudiantes para mostrar'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: estudiantes.length,
                  itemBuilder: (context, index) {
                    final estudiante = estudiantes[index];
                    return EstudianteCard(estudiante: estudiante);
                  },
                ),
        ));
  }
}

class EstudianteCard extends StatefulWidget {
  final EstudianteDeporte estudiante;

  const EstudianteCard({
    super.key,
    required this.estudiante,
  });

  @override
  State<EstudianteCard> createState() => _EstudianteCardState();
}

class _EstudianteCardState extends State<EstudianteCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final estudiante = widget.estudiante;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Cabecera de la tarjeta (siempre visible)
          ListTile(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            /*leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.blue,
                size: 30,
              ),
            ),*/
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    estudiante.nombre,
                    style: AppColors.textosubtitulonegro,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: estudiante.activo ? AppColors.verde : AppColors.rojo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    estudiante.activo ? S.of(context).label_activo : S.of(context).label_inactivo,
                    style: AppColors.textosecundarioblanco,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'ID: ${estudiante.idEstudiante}',
              style: AppColors.textosecundarionegro,
            ),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),

          // Contenido expandido
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                  const Divider(),
                  const SizedBox(height: 8),

                  // Email
                  _buildInfoRow(
                    icon: Icons.email,
                    label: S.of(context).label_email,
                    value: estudiante.email,
                  ),

                  // EPS
                  _buildInfoRow(
                    icon: Icons.health_and_safety,
                    label: S.of(context).label_eps,
                    value: estudiante.eps,
                  ),

                  // Alergias (si existen)
                  if (estudiante.alergias != null && estudiante.alergias!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.warning_amber_rounded,
                      label: S.of(context).label_alergias,
                      value: estudiante.alergias!.join(', '),
                      color: Colors.orange,
                    ),

                  // Medicamentos (si existen)
                  if (estudiante.nombreMedicamento != null && estudiante.nombreMedicamento!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.medication,
                      label: S.of(context).label_tomamedicamentos,
                      value: estudiante.nombreMedicamento!,
                      color: Colors.purple,
                    ),

                  // Condiciones médicas (si existen)
                  if (estudiante.condicionesMedicas != null && estudiante.condicionesMedicas!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.medical_services,
                      label: S.of(context).label_condicionesmedicas,
                      value: estudiante.condicionesMedicas!.join(', '),
                      color: Colors.red,
                    ),

                  // Estado de revisión
                  _buildInfoRow(
                    icon: Icons.assignment,
                    label: S.of(context).label_estadoderevision,
                    value: estudiante.estadoRevision,
                    color: _getEstadoColor(estudiante.estadoRevision),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? AppColors.gris,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppColors.textoinformativogris,
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '---',
                  style: AppColors.textosecundarioverde,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'verificado':
        return AppColors.verde;
      case 'devuelto':
        return AppColors.naranja;
      case 'rechazado':
        return AppColors.rojo;
      default:
        return AppColors.gris;
    }
  }
}
