import 'package:appdac/a_presentacion/tema/iconos.dart';
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
        backgroundColor: AppColors.blanco,
          title: SizedBox(
            width: double.infinity,
            child: Text(
              controllistadeportes.seleccionado!.nombreDeporte,
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
              child: IconoDeporte(
                color: AppColors.blanco,
                backgroundColor: AppColors.verde,
                size: 30,
                borderRadius: 10,
              ),
            )
          ]),
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
        child: Padding(
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
                                style: AppColors.textosubtituloblanco,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context).label_verhistorialdeasistencias,
                                style: AppColors.textosecundarioblanco,
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
                                style: AppColors.textosubtituloblanco,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context).label_veranunciosgrupo,
                                style: AppColors.textosecundarioblanco,
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
                            Icons.lock_clock,
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
                                style: AppColors.textosubtituloblanco,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context).label_horarioexp,
                                style: AppColors.textosecundarioblanco,
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
      ),
    );
  }
}
