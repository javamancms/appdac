import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/util/metodos.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsistenciaScreen extends StatelessWidget {
  const AsistenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controlasistencia = context.watch<ControlAsistencia>();

    if (controlasistencia.asistencia == null || controlasistencia.asistencia!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blanco,
          title: Center(
            child: Text(
              S.of(context).label_histasistencias,
              style: AppColors.textotitulonegro,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            color: AppColors.verde,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.verde,
                ),
                child: Icon(
                  Icons.checklist,
                  size: 30,
                  color: AppColors.blanco,
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No hay datos de asistencia disponibles',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final parsedData = parseAsistencia(controlasistencia.asistencia);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blanco,
        title: Center(
          child: Text(
            S.of(context).label_histasistencias,
            style: AppColors.textotitulonegro,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.verde,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.verde,
              ),
              child: Icon(
                Icons.checklist,
                size: 30,
                color: AppColors.blanco,
              ),
            ),
          )
          /*IconoDeporte(
              color: AppColors.blanco,
              backgroundColor: AppColors.verde,
              size: 30,
              borderRadius: 10,
            )*/
        ],
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.blanco, 
            image: DecorationImage(
              image: AssetImage('assets/img/logoirdcotafondo.png'),
              fit: BoxFit.contain,
              alignment: Alignment.center,
              opacity: 0.3,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstOver),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _buildAsistenciaTable(parsedData),
            ),
          )),
    );
  }

  Widget _buildAsistenciaTable(Map<String, dynamic> parsedData) {
    final header = List<String>.from(parsedData['header'] ?? []);
    final rows = List<List<String>>.from(parsedData['rows'] ?? []);

    if (header.isEmpty) {
      return Center(
        child: Text('Formato de datos no válido'),
      );
    }

    return DataTable(
      columnSpacing: 20,
      horizontalMargin: 16,
      headingRowHeight: 60,
      dataRowMinHeight: 50,
      dataRowMaxHeight: 100,
      columns: header.map((columna) {
        return DataColumn(
          label: Expanded(
            child: Text(
              columna,
              style: AppColors.textosubtituloverde,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
      rows: rows.map((fila) {
        return DataRow(
          cells: fila.asMap().entries.map((entry) {
            final index = entry.key;
            final valor = entry.value;

            // Estilo especial para la columna de porcentaje
            Widget contenido;
            if (index == 1 && valor.contains('%')) {
              final porcentaje = double.tryParse(valor.replaceAll('%', '').trim()) ?? 0;

              contenido = Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: porcentaje / 100,
                      backgroundColor: Colors.grey[300],
                      color: _getColorPorPorcentaje(porcentaje),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    valor,
                    style: AppColors.textosubtituloverde,
                  ),
                ],
              );
            } else {
              contenido = Text(
                valor,
                style: AppColors.textosubtituloverde,
                overflow: TextOverflow.ellipsis,
              );
            }

            return DataCell(
              Tooltip(
                message: valor,
                child: contenido,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Color _getColorPorPorcentaje(double porcentaje) {
    if (porcentaje >= 70) return Colors.green;
    if (porcentaje >= 50) return Colors.orange;
    return Colors.red;
  }

  void _exportarAsistencia(String csvData, BuildContext context) {
    // Aquí puedes implementar la exportación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos listos para exportar'),
        action: SnackBarAction(
          label: 'Copiar',
          onPressed: () {
            // Clipboard.setData(ClipboardData(text: csvData));
          },
        ),
      ),
    );
  }
}
