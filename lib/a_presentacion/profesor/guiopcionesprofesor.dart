import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OpcionesProfesorScreen extends StatelessWidget {
  const OpcionesProfesorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlComunicadosProfesores controlcomunicadosprofesores = context.watch<ControlComunicadosProfesores>();
    ControlListaDeportesProfesor controllistadeportes = context.watch<ControlListaDeportesProfesor>();
    ControlAsistenciaProfesor controlasistencia = context.watch<ControlAsistenciaProfesor>();
    ControlListaDeporte controllistadeporte = context.watch<ControlListaDeporte>();
    //ControlComunicados controlcomunicados = context.watch<ControlComunicados>();

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
                      await controlasistencia.cargarAsistencia(controllistadeportes.seleccionado!.idDeporte);
                      context.push('/VerAsistenciaProfesor');
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
          
                // Card para Lista Estudiantes
                Card(
                  color: AppColors.verde,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await controllistadeporte.cargarEstudiantes(controllistadeportes.seleccionado!.idDeporte);
                      context.push('/VerDeporteEstudiantes');
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
                              Icons.people,
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
                                  S.of(context).label_listaestudiantes,
                                  style: AppColors.textosubtituloblanco,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S.of(context).label_veralumnosinscritos,
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
                      await mostrarDialogoComunicado(context, controllistadeportes.seleccionado!.idDeporte, controlcomunicadosprofesores);
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
                                  S.of(context).label_enviarcomunicados,
                                  style: AppColors.textosubtituloblanco,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S.of(context).label_enviaranunciosgrupo,
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
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            await controllistadeporte.cargarEstudiantes(controllistadeportes.seleccionado!.idDeporte);
            context.push('/TomarAsistencia');
          },
          style: AppColors.botonverde.copyWith(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_add_alt_1,
                size: 30,
                color: Colors.white, // Icono blanco
              ),
              SizedBox(height: 4),
              Text(
                S.of(context).label_tomarasistencia,
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              
            ],
          ),
        ));
  }
}

Future<Map<String, String>?> mostrarDialogoComunicado(BuildContext context, String idDeporte, ControlComunicadosProfesores controlcomunicadosprofesores) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false, // Evita cerrar tocando fuera
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.blanco,
        title: Text(S.of(context).label_enviarcomunicado, style: AppColors.textotituloverde,),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: DecoracionCampoVerdeFondoGris(
                    letrero: S.of(context).label_titulo,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El título es requerido';
                    }
                    return null;
                  },
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: bodyController,
                  decoration: DecoracionCampoVerdeFondoGris(
                    letrero: S.of(context).label_mensaje,

                  ),
                  maxLines: 5,
                  minLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El cuerpo del mensaje es requerido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Botón Cancelar
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo sin retornar nada
            },
            style: AppColors.botonblanco,
            child: Text(S.of(context).label_cancelar),
          ),

          // Botón Enviar
          ElevatedButton(
            onPressed: () async {
              await controlcomunicadosprofesores.enviarComunicado(context, idDeporte, titleController.text, bodyController.text);
              Navigator.of(context).pop();
            },
            style: AppColors.botonverde,
            child: Text(S.of(context).label_enviar),
          ),
        ],
      );
    },
  );
}