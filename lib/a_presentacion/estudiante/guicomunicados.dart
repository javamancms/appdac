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
      appBar: AppBar(
        title: Text(
          S.of(context).label_comunicados,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: comunicados.isEmpty ? _buildVacio() : _buildListaComunicados(listaComunicados),
    );
  }

  // Widget para cuando no hay comunicados
  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.announcement_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'No hay comunicados disponibles',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Cuando haya nuevos comunicados\naparecerán aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar la lista de comunicados
  Widget _buildListaComunicados(List<Comunicado> comunicados) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blanco,
            AppColors.blanco,
          ],
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: comunicados.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildCardComunicado(context, comunicados[index]);
        },
      ),
    );
  }

  // Widget para cada tarjeta de comunicado
  Widget _buildCardComunicado(BuildContext context, Comunicado comunicado) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.verde,
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.verde,
              AppColors.verdeclaro,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono de megáfono
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.blanco,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.campaign,
                color: AppColors.verde,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Contenido del comunicado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).label_titulo,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blanco,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          comunicado.titulo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blanco,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Mensaje
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).label_mensaje,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blanco,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          comunicado.mensaje,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.blanco,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),

                  // Separador y fecha si está disponible
                  const SizedBox(height: 12),

                  // Extraer fecha del título si existe
                  /*if (_contieneFecha(comunicado.titulo)) ...[
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _extraerFecha(comunicado.titulo),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para parsear el CSV a una lista de comunicados
  List<Comunicado> _parsearComunicadosCSV(String csvData) {
    csvData = csvData.replaceAll('\n', '--');
    csvData = csvData.replaceAll('"', '');

    final List<Comunicado> comunicados = [];

    List<String> porguiones = csvData.split('--');

    for (String lcomunicado in porguiones) {
      List<String> porcomas = lcomunicado.split(',');
      if (porcomas.length > 1) {
        comunicados.add(Comunicado(titulo: lcomunicado.split(',')[0], mensaje: lcomunicado.split(',')[1]));
      }
    }

    logear('fin por guiones');
    return comunicados.reversed.toList();
  }

  // Método para parsear líneas CSV considerando comillas
  List<String> _parseCSVLine(String line) {
    final List<String> result = [];
    final StringBuffer current = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        // Manejar comillas dobles escapadas
        if (i + 1 < line.length && line[i + 1] == '"') {
          current.write('"');
          i++; // Saltar la siguiente comilla
        } else {
          // Alternar estado de comillas
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        // Fin de columna
        result.add(current.toString());
        current.clear();
      } else {
        current.write(char);
      }
    }

    // Agregar la última columna
    result.add(current.toString());

    return result;
  }

  // Método auxiliar para verificar si el título contiene fecha
  bool _contieneFecha1(String titulo) {
    final fechaRegex = RegExp(r'\d{1,2}:\d{2}\s*-\s*\d{1,2}/\d{1,2}/\d{4}');
    return fechaRegex.hasMatch(titulo);
  }

  // Método para extraer la fecha del título
  String _extraerFecha(String titulo) {
    final fechaRegex = RegExp(r'(\d{1,2}:\d{2}\s*-\s*\d{1,2}/\d{1,2}/\d{4})');
    final match = fechaRegex.firstMatch(titulo);
    return match?.group(1) ?? 'Fecha no disponible';
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
