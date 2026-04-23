import 'package:appdac/a_presentacion/estudiante/guienviardocumentos.dart';
import 'package:appdac/a_presentacion/estudiante/guiinscribirdeporte.dart';
import 'package:appdac/a_presentacion/guigeneral/menugeneral.dart';
import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intestudiantes.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EstudianteScreen extends StatefulWidget {
  const EstudianteScreen({super.key});

  @override
  State<EstudianteScreen> createState() => _EstudianteScreenState();
}

class _EstudianteScreenState extends State<EstudianteScreen> {
  bool _dialogoMostrado = false;

  @override
  void initState() {
    super.initState();
    // Cargar datos aquí si es necesario
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Mostrar diálogo después de que el widget esté completamente construido
    if (!_dialogoMostrado && ControlSesion.datosusuario!.actualizacionDatos) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _dialogoMostrado = true;
          DialogoActualizarDatos.mostrar(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ControlListaDeportes consultadeportes = context.watch<ControlListaDeportes>();
    ControlInscribirDeportes inscripciondeportes = context.watch<ControlInscribirDeportes>();
    if (ControlSesion.datosusuario != null) {
      consultadeportes.cargarDeportes(ControlSesion.datosusuario!.idUsuario);
    }
    List<DeporteEstudiante> ldeportes = ControlListaDeportes.deportes;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blanco,
          title: Text(
            S.of(context).label_titmisdeportes,
            style: AppColors.textotitulonegro,
            ),
          actions: [
          IconoDeporte(
            color: AppColors.blanco,
            backgroundColor: AppColors.verde,
            size: 30,
            borderRadius: 10,
          )
        ],
        ),
        drawer: menuGeneral(context),
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
                // Botón "Inscribir Deporte" alineado a la derecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.verde.withOpacity(0.1), // Fondo verde muy claro
                        border: Border.all(
                          color: AppColors.verde,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ControlSesion.datosusuario != null ? ControlSesion.datosusuario!.estadoDeRevision! : '',
                        style: AppColors.textosubtituloverde,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await inscripciondeportes.cargarDeportes(ControlSesion.datosusuario!.idUsuario);
                        InscribirDeporteScreen.mostrarDialogo(context);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Inscribir Deporte'),
                      style: AppColors.botonverde,
                    ),
                  ],
                ),

                const SizedBox(height: 16), // Espacio entre el botón y la lista

                // GridView de deportes
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: ldeportes.length,
                    itemBuilder: (context, index) {
                      final deporte = ldeportes[index];

                      return GestureDetector(
                        onTap: () {
                          consultadeportes.seleccionarDeporte(deporte);
                          context.push('/OpcionesEstudiante');
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.verde,
                                  AppColors.verdeclaro,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconoDeporte(backgroundColor: AppColors.blanco,color: AppColors.verde,borderRadius: 20,size: 60,),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text(
                                        deporte.nombreDeporte,
                                        style: AppColors.textosubtituloblanco,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 3.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.blanco,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Text(
                                      'ID: ${deporte.idDeporte}',
                                      style: AppColors.textosecundarionegro,
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}