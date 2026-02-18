import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OpcionesEstudianteScreen extends StatelessWidget {
  const OpcionesEstudianteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaDeportes controllistadeportes = context.watch<ControlListaDeportes>();
    ControlAsistencia controlasistencia = context.watch<ControlAsistencia>();
    ControlComunicados controlcomunicados = context.watch<ControlComunicados>();

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Text(
            controllistadeportes.seleccionado!.nombreDeporte,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2, // Permite hasta 2 líneas
            overflow: TextOverflow.ellipsis, // Muestra "..." si es muy largo
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card para Curso e historial de asistencias
            Card(
              color: AppColors.verde,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () async {
                  await controlasistencia.cargarAsistencia(controllistadeportes.seleccionado!.idDeporte, ControlSesion.datosusuario!.idUsuario);
                  context.push('/VerAsistenciaEstudiante');
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Icono de lista de chequeo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.blanco,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.checklist,
                          size: 32,
                          color: AppColors.verde,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Textos a la derecha del icono
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).label_curso,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blanco,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.of(context).label_verhistorialdeasistencias,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.blanco,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Flecha indicadora (opcional)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card para Comunicados
            Card(
              color: AppColors.verde,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () async {
                  await controlcomunicados.cargarComunicados(controllistadeportes.seleccionado!.idDeporte);

                  context.push('/VerComunicadosEstudiante');
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Icono de megáfono
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.blanco,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.campaign,
                          size: 32,
                          color: AppColors.verde,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Textos a la derecha del icono
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).label_comunicados,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blanco,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.of(context).label_veranunciosgrupo,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.blanco,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Flecha indicadora (opcional)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card para Comunicados
            Card(
              color: AppColors.verde,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () async {
                  //await controlcomunicados.cargarComunicados(controllistadeportes.seleccionado!.idDeporte);

                  context.push('/VerHorario');
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Icono de megáfono
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.blanco,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.campaign,
                          size: 32,
                          color: AppColors.verde,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Textos a la derecha del icono
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).label_horario,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blanco,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.of(context).label_horarioexp,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.blanco,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Flecha indicadora (opcional)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Espacio para agregar más cards en el futuro
            const Spacer(),

            // Puedes agregar más opciones aquí si es necesario
            /*
            const SizedBox(height: 20),
            
            Card(
              // Configuración similar para más opciones
            ),
            */
          ],
        ),
      ),
    );
  }
}
