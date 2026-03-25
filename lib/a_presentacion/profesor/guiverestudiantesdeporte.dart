import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeporteEstudiantesScreen extends StatelessWidget {
  const DeporteEstudiantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaDeporte controllistadeporte = context.watch<ControlListaDeporte>();
    List<EstudianteDeporte> estudiantes = controllistadeporte.estudiantes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes (${estudiantes.length})'),
      ),
      body: estudiantes.isEmpty
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
    );
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
            leading: Container(
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
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    estudiante.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: estudiante.activo ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    estudiante.activo ? 'Activo' : 'Inactivo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'ID: ${estudiante.idEstudiante}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
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
                    label: 'Email',
                    value: estudiante.email,
                  ),

                  // EPS
                  _buildInfoRow(
                    icon: Icons.health_and_safety,
                    label: 'EPS',
                    value: estudiante.eps,
                  ),

                  // Alergias (si existen)
                  if (estudiante.alergias != null && estudiante.alergias!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.warning_amber_rounded,
                      label: 'Alergias',
                      value: estudiante.alergias!.join(', '),
                      color: Colors.orange,
                    ),

                  // Medicamentos (si existen)
                  if (estudiante.nombreMedicamento != null && estudiante.nombreMedicamento!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.medication,
                      label: 'Medicamentos',
                      value: estudiante.nombreMedicamento!,
                      color: Colors.purple,
                    ),

                  // Condiciones médicas (si existen)
                  if (estudiante.condicionesMedicas != null && estudiante.condicionesMedicas!.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.medical_services,
                      label: 'Condiciones médicas',
                      value: estudiante.condicionesMedicas!.join(', '),
                      color: Colors.red,
                    ),

                  // Estado de revisión
                  _buildInfoRow(
                    icon: Icons.assignment,
                    label: 'Estado de revisión',
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
            color: color ?? Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'No especificado',
                  style: TextStyle(
                    fontSize: 14,
                    color: color ?? Colors.black87,
                    fontWeight: value.isNotEmpty ? FontWeight.normal : FontWeight.w300,
                  ),
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
