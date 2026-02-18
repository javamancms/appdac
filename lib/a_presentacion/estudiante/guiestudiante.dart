import 'package:appdac/a_presentacion/estudiante/guienviardocumentos.dart';
import 'package:appdac/a_presentacion/estudiante/guiinscribirdeporte.dart';
import 'package:appdac/a_presentacion/guigeneral/menugeneral.dart';
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
          title: Text(S.of(context).label_titmisdeportes),
        ),
        drawer: menuGeneral(context),
        body: Padding(
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
                      style: const TextStyle(
                        color: AppColors.verde,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await inscripciondeportes.cargarDeportes(ControlSesion.datosusuario!.idUsuario);
                      InscribirDeporteScreen.mostrarDialogo(context);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Inscribir Deporte'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                      shadowColor: Colors.green.withOpacity(0.3),
                    ),
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
                                  child: const Icon(
                                    Icons.sports_soccer,
                                    size: 32.0,
                                    color: Colors.green,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      deporte.nombreDeporte,
                                      style: const TextStyle(
                                        fontSize: 11.0, // Tamaño más pequeño
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blanco,
                                        height: 1.3,
                                        letterSpacing: -0.2, // Reduce ligeramente el espacio entre letras
                                      ),
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
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: AppColors.verde,
                                      fontWeight: FontWeight.w500,
                                    ),
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
    );
  }
}
