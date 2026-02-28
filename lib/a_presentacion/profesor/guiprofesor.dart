import 'package:appdac/a_presentacion/estudiante/guienviardocumentos.dart';
import 'package:appdac/a_presentacion/guigeneral/menugeneral.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfesorScreen extends StatefulWidget {
  const ProfesorScreen({super.key});

  @override
  State<ProfesorScreen> createState() => _ProfesorScreenState();
}

class _ProfesorScreenState extends State<ProfesorScreen> {
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
    ControlListaDeportesProfesor consultadeportes = context.watch<ControlListaDeportesProfesor>();
    
    if (ControlSesion.datosusuario != null) {
      consultadeportes.cargarListaDeportes();
    }
    List<DeporteProfesor> ldeportes = ControlListaDeportesProfesor.deportes;

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
                        context.push('/OpcionesProfesor');
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
