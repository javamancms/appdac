import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/util/metodos.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsistenciaProfesorScreen extends StatelessWidget {
  const AsistenciaProfesorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controlasistencia = context.watch<ControlAsistenciaProfesor>();

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
          child: Center(
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
        child: _buildAsistenciaTable(parsedData),
      ),
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

    return _SynchronizedScrollTable(
      header: header,
      rows: rows,
      columnWidth: 150,
    );
  }
}

class _SynchronizedScrollTable extends StatefulWidget {
  final List<String> header;
  final List<List<String>> rows;
  final double columnWidth;

  const _SynchronizedScrollTable({
    required this.header,
    required this.rows,
    required this.columnWidth,
  });

  @override
  State<_SynchronizedScrollTable> createState() => _SynchronizedScrollTableState();
}

class _SynchronizedScrollTableState extends State<_SynchronizedScrollTable> {
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();
  
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    
    // Sincronizar scroll: cuando el cuerpo se mueve, el encabezado también
    _bodyScrollController.addListener(() {
      if (!_isSyncing && _headerScrollController.hasClients) {
        _isSyncing = true;
        _headerScrollController.jumpTo(_bodyScrollController.offset);
        _isSyncing = false;
      }
    });
    
    // Sincronizar scroll: cuando el encabezado se mueve, el cuerpo también
    _headerScrollController.addListener(() {
      if (!_isSyncing && _bodyScrollController.hasClients) {
        _isSyncing = true;
        _bodyScrollController.jumpTo(_headerScrollController.offset);
        _isSyncing = false;
      }
    });
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _bodyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    
    return Column(
      children: [
        // Encabezado fijo con scroll horizontal
        Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.verde.withOpacity(0.6),
            border: Border(
              bottom: BorderSide(color: AppColors.verde, width: 2),
            ),
          ),
          child: SingleChildScrollView(
            controller: _headerScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.header.map((columna) {
                return Container(
                  width: widget.columnWidth,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Text(
                    columna,
                    style: AppColors.textosubtituloblanco.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        // Cuerpo de la tabla con scroll vertical y horizontal
        Expanded(
          child: SingleChildScrollView(
            controller: _bodyScrollController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: widget.rows.asMap().entries.map((rowEntry) {
                  final fila = rowEntry.value;
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.grisclaro.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: fila.asMap().entries.map((entry) {
                        final index = entry.key;
                        final valor = entry.value;
                        
                        return Container(
                          width: widget.columnWidth,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: _buildCellContent(index, valor),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCellContent(int index, String valor) {
    if (index == 1 && valor.contains('%')) {
      final porcentaje = double.tryParse(valor.replaceAll('%', '').trim()) ?? 0;
      
      return Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: porcentaje / 100,
              backgroundColor: AppColors.grisclaro,
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
      return Tooltip(
        message: valor,
        child: Text(
          valor,
          style: AppColors.textosubtituloverde,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  Color _getColorPorPorcentaje(double porcentaje) {
    if (porcentaje >= 70) return Colors.green;
    if (porcentaje >= 50) return Colors.orange;
    return Colors.red;
  }
}