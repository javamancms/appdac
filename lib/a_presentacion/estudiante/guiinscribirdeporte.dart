import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/c_integracion/intestudiantes.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InscribirDeporteScreen extends StatelessWidget {
  const InscribirDeporteScreen({super.key});

  // Método estático para mostrar el diálogo
  static Future<List<Deporte>?> mostrarDialogo(BuildContext context) async {
    final key = GlobalKey<_DialogContentState>();

    return await showDialog<List<Deporte>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.blanco,
          title: Column(
            children: [
              Container(
                //color: AppColors.blanco, // Fondo verde
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).label_insdeportes,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.verde),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: _DialogContent(key: key),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(S.of(context).label_cancelar, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: AppColors.botonverde,
              onPressed: ()  async {
                // Obtener los deportes editados desde el estado
                final deportesEditados = key.currentState?.deportesEditables;
                if (await ControlInscribirDeportes.actualizarInscripcion(context, deportesEditados!)) {
                  mostrarMensajeInferior(context, S.of(context).msj_inscexitosa);
                } else {
                  mostrarMensajeInferior(context, S.of(context).msj_inscnoexitosa, colorFondo: Colors.red, colorFuente: Colors.yellow);
                }
                context.pop();
              },
              child: Text(S.of(context).label_enviar),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blanco,
        title: Text('Inscribir Deportes'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final deportesEditados = await InscribirDeporteScreen.mostrarDialogo(context);
            if (deportesEditados != null) {
              print('Deportes editados: ${deportesEditados.length}');
              // Aquí procesas los deportes editados
            }
          },
          child: Text('Mostrar diálogo de deportes'),
        ),
      ),
    );
  }
}

// Widget para el contenido del diálogo
class _DialogContent extends StatefulWidget {
  const _DialogContent({Key? key}) : super(key: key);

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  late List<Deporte> deportesOriginales;
  late List<Deporte> deportesEditables;

  // Getter público para acceder a deportesEditables desde fuera
  List<Deporte> get deportesEditablesPublico => List<Deporte>.from(deportesEditables);

  @override
  void initState() {
    super.initState();
    final control = context.read<ControlInscribirDeportes>();
    deportesOriginales = List<Deporte>.from(control.deportes);
    deportesEditables = List<Deporte>.from(control.deportes);
  }

  // Resto del código permanece igual...
  int get seleccionadosCount {
    return deportesEditables.where((d) => d.existe).length;
  }

  int get inicialmenteSeleccionados {
    return deportesOriginales.where((d) => d.existe).length;
  }

  bool _esDeshabilitado(int index) {
    return deportesOriginales[index].existe;
  }

  void _actualizarDeporte(int index, bool nuevoValor) {
    final deporte = deportesEditables[index];

    if (_esDeshabilitado(index)) {
      return;
    }

    if (nuevoValor && seleccionadosCount >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Solo puedes tener máximo 2 deportes seleccionados'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      deportesEditables[index] = Deporte(
        nombreDeporte: deporte.nombreDeporte,
        existe: nuevoValor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final altura = (deportesEditables.length * 80.0).clamp(200.0, 500.0);

    return SizedBox(
      width: double.maxFinite,
      height: altura,
      child: Column(
        children: [
          // Resto del contenido permanece igual...
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.blanco,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.verde),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).label_deportesdisponibles,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$seleccionadosCount/2 ${S.of(context).label_seleccionados}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: seleccionadosCount >= 2 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: deportesEditables.length,
              itemBuilder: (context, index) {
                final deporte = deportesEditables[index];
                final esDeshabilitado = _esDeshabilitado(index);
                final maximoAlcanzado = !esDeshabilitado && deporte.existe == false && seleccionadosCount >= 2;

                return _DeporteCardItem(
                  deporte: deporte,
                  esDeshabilitado: esDeshabilitado,
                  maximoAlcanzado: maximoAlcanzado,
                  onChanged: (value) => _actualizarDeporte(index, value ?? false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _DeporteCardItem permanece igual...
class _DeporteCardItem extends StatelessWidget {
  final Deporte deporte;
  final bool esDeshabilitado;
  final bool maximoAlcanzado;
  final ValueChanged<bool?> onChanged;

  const _DeporteCardItem({
    required this.deporte,
    required this.esDeshabilitado,
    required this.maximoAlcanzado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final deshabilitado = esDeshabilitado || maximoAlcanzado;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      color: esDeshabilitado
          ? Colors.grey[50]
          : maximoAlcanzado
              ? Colors.grey[100]
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: esDeshabilitado
              ? Colors.green.withOpacity(0.3)
              : maximoAlcanzado
                  ? Colors.grey.withOpacity(0.4)
                  : Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              esDeshabilitado
                  ? Icons.lock
                  : maximoAlcanzado
                      ? Icons.block
                      : Icons.sports_soccer,
              color: esDeshabilitado
                  ? AppColors.verde
                  : maximoAlcanzado
                      ? AppColors.gris
                      : AppColors.verde,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    deporte.nombreDeporte,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: esDeshabilitado ? FontWeight.bold : FontWeight.normal,
                      color: deshabilitado ? AppColors.gris : AppColors.verde,
                    ),
                    maxLines: null, // Permite tantas líneas como necesite
                    overflow: TextOverflow.visible, // Permite que el texto se salga si es necesario
                    softWrap: true, // Permite dividir el texto en múltiples líneas
                  ),

                  SizedBox(height: 2),
                  if (esDeshabilitado)
                    Text(
                      'Ya inscrito - No se puede modificar',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  /*if (maximoAlcanzado && !esDeshabilitado)
                    Text(
                      'Límite de 2 deportes alcanzado',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),*/
                ],
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: esDeshabilitado
                    ? Colors.green.withOpacity(0.1)
                    : maximoAlcanzado
                        ? Colors.grey[100]
                        : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Checkbox(
                    value: deporte.existe,
                    onChanged: deshabilitado ? null : onChanged,
                    activeColor: esDeshabilitado ? Colors.green : Colors.blue,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Text(
                    esDeshabilitado
                        ? S.of(context).label_yainscrito
                        : maximoAlcanzado
                            ? '-'
                            : deporte.existe
                                ? ''
                                : S.of(context).label_seleccionar,
                    style: TextStyle(
                      fontSize: 9,
                      color: esDeshabilitado
                          ? Colors.green
                          : maximoAlcanzado
                              ? Colors.grey[600]
                              : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
