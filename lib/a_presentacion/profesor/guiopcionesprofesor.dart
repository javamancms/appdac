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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blanco,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context).label_veralumnosinscritos,
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blanco,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context).label_enviaranunciosgrupo,
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
            children: const [
              Icon(
                Icons.person_add_alt_1,
                size: 30,
                color: Colors.white, // Icono blanco
              ),
              SizedBox(height: 4),
              Text(
                'Tomar Asistencia',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              Text(
                'Hoy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white, // Texto blanco
                ),
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
        title: Text(S.of(context).label_enviarcomunicado),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: S.of(context).label_titulo,
                    //hintText: 'Ingresa el título del mensaje',
                    border: OutlineInputBorder(),
                    //prefixIcon: Icon(Icons.title),
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
                  decoration: InputDecoration(
                    labelText: S.of(context).label_mensaje,
                    //hintText: 'Escribe el contenido del mensaje',
                    border: OutlineInputBorder(),
                    //prefixIcon: Icon(Icons.message),
                    alignLabelWithHint: true,
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
            child: Text(S.of(context).label_cancelar),
          ),

          // Botón Enviar
          ElevatedButton(
            onPressed: () async {
              await controlcomunicadosprofesores.enviarComunicado(context, idDeporte, titleController.text, bodyController.text);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).label_enviar),
          ),
        ],
      );
    },
  );
}
