import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/config/log.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComunicadosScreen extends StatelessWidget {
  const ComunicadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlComunicados controlcomunicados = context.watch<ControlComunicados>();
    String comunicados = controlcomunicados.comunicados;

    // Parsear el CSV a una lista de comunicados
    final List<Comunicado> listaComunicados = _parsearComunicadosCSV(comunicados);

    return Scaffold(
        backgroundColor: AppColors.blanco, // Cambiado a blanco
        appBar: AppBar(
          backgroundColor: AppColors.blanco,
          title: SizedBox(
            width: double.infinity,
            child: Text(
              S.of(context).label_comunicados,
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
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.blanco.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.campaign,
                  size: 24,
                  color: AppColors.blanco,
                ),
              ),
            )
          ],
        ),
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
          child: comunicados.isEmpty || listaComunicados.isEmpty ? _buildVacio() : _buildListaComunicados(listaComunicados),
        ) /*comunicados.isEmpty || listaComunicados.isEmpty ? _buildVacio() : _buildListaComunicados(listaComunicados)*/
        );
  }

  // Widget para cuando no hay comunicados
  Widget _buildVacio() {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.verde.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.announcement_outlined,
                size: 80,
                color: AppColors.verde,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay comunicados disponibles',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.negro,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cuando haya nuevos comunicados\naparecerán aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar la lista de comunicados
  Widget _buildListaComunicados(List<Comunicado> comunicados) {
    return RefreshIndicator(
      onRefresh: () async {
        // Aquí puedes agregar lógica para recargar comunicados
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: comunicados.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 300 + (index * 50)),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _buildCardComunicado(context, comunicados[index], index),
          );
        },
      ),
    );
  }

  // Widget para cada tarjeta de comunicado
  Widget _buildCardComunicado(BuildContext context, Comunicado comunicado, int index) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.verde.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.verde,
          width: 1.5,
        ),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          //_mostrarDialogoComunicado(context, comunicado);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.blanco,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono y título
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.verde.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.verde, AppColors.verde],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.campaign,
                        color: AppColors.blanco,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${S.of(context).label_comunicado}${index + 1}',
                            style: AppColors.textosubtituloverde,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comunicado.titulo,
                            style: AppColors.textosubtitulonegro,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido del mensaje
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 16,
                          color: AppColors.verde,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).label_mensaje,
                          style: AppColors.textosubtituloverde,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      comunicado.mensaje,
                      style: AppColors.textosubtitulonegro,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Diálogo para mostrar el comunicado completo
  void _mostrarDialogoComunicado(BuildContext context, Comunicado comunicado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.blanco,
                  AppColors.blanco, // Cambiado a blanco
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.verde, AppColors.verde ?? AppColors.verde],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        comunicado.titulo,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.negro,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Línea decorativa
                Container(
                  height: 3,
                  width: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.verde, AppColors.verde ?? AppColors.verde],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Mensaje completo
                Text(
                  comunicado.mensaje,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),

                // Botón de cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.verde,
                      foregroundColor: AppColors.blanco,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para parsear el CSV a una lista de comunicados
  List<Comunicado> _parsearComunicadosCSV(String csvData) {
    if (csvData.isEmpty) return [];

    csvData = csvData.replaceAll('\n', '--');
    csvData = csvData.replaceAll('"', '');

    final List<Comunicado> comunicados = [];

    List<String> porguiones = csvData.split('--');

    for (String lcomunicado in porguiones) {
      List<String> porcomas = lcomunicado.split(',');
      if (porcomas.length > 1) {
        String titulo = porcomas[0].trim();
        String mensaje = porcomas[1].trim();

        // Limpiar títulos que puedan tener formato de fecha
        titulo = _limpiarTitulo(titulo);

        if (titulo.isNotEmpty && mensaje.isNotEmpty) {
          comunicados.add(Comunicado(titulo: titulo, mensaje: mensaje));
        }
      }
    }

    logear('Total comunicados: ${comunicados.length}');
    return comunicados.reversed.toList();
  }

  // Método para limpiar el título de posibles formatos de fecha
  String _limpiarTitulo(String titulo) {
    // Eliminar patrones de fecha/hora al inicio del título
    final fechaRegex = RegExp(r'^\d{1,2}:\d{2}\s*-\s*\d{1,2}/\d{1,2}/\d{4}\s*[-–]\s*');
    String limpio = titulo.replaceAll(fechaRegex, '');

    // Si después de limpiar está vacío, devolver el original
    return limpio.isNotEmpty ? limpio : titulo;
  }
}

// Clase para representar un comunicado
class Comunicado {
  final String titulo;
  final String mensaje;

  Comunicado({
    required this.titulo,
    required this.mensaje,
  });
}
