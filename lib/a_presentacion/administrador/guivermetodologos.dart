import 'package:appdac/b_control/bsmetodologo.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intmetodologo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MetodologosScreen extends StatelessWidget {
  const MetodologosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaMetodologos controlmetodologos = context.watch<ControlListaMetodologos>();
    controlmetodologos.cargarMetodologos(ControlSesion.datosusuario!.idUsuario);
    List<Metodologo> metodologos = controlmetodologos.metodologos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Metodologos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: MetodologosLista(
        metodologos: metodologos,
        controlmetodologos: controlmetodologos,
      ),
    );
  }
}

class MetodologosLista extends StatefulWidget {
  final List<Metodologo> metodologos;
  final ControlListaMetodologos controlmetodologos;

  const MetodologosLista({
    Key? key,
    required this.metodologos,
    required this.controlmetodologos,
  }) : super(key: key);

  @override
  State<MetodologosLista> createState() => _MetodologosListaState();
}

class _MetodologosListaState extends State<MetodologosLista> {
  final TextEditingController _busquedaController = TextEditingController();
  String _filtroBusqueda = '';
  
  // Conjunto para trackear qué metodólogos están en proceso de cambio
  final Set<String> _metodologosEnProceso = {};

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Metodologo> get _metodologosFiltrados {
    if (_filtroBusqueda.isEmpty) {
      return widget.metodologos;
    }

    return widget.metodologos.where((metodologo) {
      final nombreCompleto = metodologo.nombre.toLowerCase();
      final busqueda = _filtroBusqueda.toLowerCase();
      return nombreCompleto.contains(busqueda);
    }).toList();
  }

  Future<void> _toggleActivo(Metodologo metodologo) async {
    // Verificar si ya está en proceso
    if (_metodologosEnProceso.contains(metodologo.idMetodologo)) {
      return;
    }

    setState(() {
      _metodologosEnProceso.add(metodologo.idMetodologo);
    });

    try {
      await widget.controlmetodologos.cambiarEstadoMetodologo(metodologo.idMetodologo);
      
      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${metodologo.nombre}: ${!metodologo.activo ? 'Activado' : 'Desactivado'} correctamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Mostrar mensaje de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar estado: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _metodologosEnProceso.remove(metodologo.idMetodologo);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final metodologosFiltrados = _metodologosFiltrados;

    return Column(
      children: [
        // Cuadro de búsqueda
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _busquedaController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _filtroBusqueda = value;
              });
            },
          ),
        ),

        // Contador de resultados
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                '${metodologosFiltrados.length} metodólogo${metodologosFiltrados.length != 1 ? 's' : ''} encontrado${metodologosFiltrados.length != 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Lista de metodólogos
        Expanded(
          child: metodologosFiltrados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron metodólogos',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (_filtroBusqueda.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _busquedaController.clear();
                              _filtroBusqueda = '';
                            });
                          },
                          child: const Text('Limpiar búsqueda'),
                        ),
                      ],
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: metodologosFiltrados.length,
                  itemBuilder: (context, index) {
                    final metodologo = metodologosFiltrados[index];
                    final bool estaEnProceso = _metodologosEnProceso.contains(metodologo.idMetodologo);
                    
                    return MetodologoCard(
                      metodologo: metodologo,
                      estaEnProceso: estaEnProceso,
                      onToggleActivo: () => _toggleActivo(metodologo),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class MetodologoCard extends StatelessWidget {
  final Metodologo metodologo;
  final bool estaEnProceso;
  final VoidCallback onToggleActivo;

  const MetodologoCard({
    Key? key,
    required this.metodologo,
    required this.estaEnProceso,
    required this.onToggleActivo,
  }) : super(key: key);

  Color _getColorByEstado() {
    return metodologo.activo ? Colors.green : Colors.red;
  }

  IconData _getIconByEstado() {
    return metodologo.activo ? Icons.check_circle : Icons.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: estaEnProceso ? Colors.grey[200] : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar con iniciales
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: estaEnProceso
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : Text(
                      metodologo.nombre.isNotEmpty 
                          ? metodologo.nombre.split(' ').map((e) => e[0]).take(2).join() 
                          : '??',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
            ),

            const SizedBox(width: 16),

            // Información del metodólogo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metodologo.nombre,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: estaEnProceso ? Colors.grey[600] : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Usuario: ${metodologo.usuario}',
                    style: TextStyle(
                      fontSize: 14,
                      color: estaEnProceso ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${metodologo.idMetodologo}',
                    style: TextStyle(
                      fontSize: 12,
                      color: estaEnProceso ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Checkbox y estado con indicador de progreso
            estaEnProceso
                ? Container(
                    width: 80,
                    height: 50,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Actualizando...',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Checkbox(
                        value: metodologo.activo,
                        onChanged: (value) => onToggleActivo(),
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getIconByEstado(),
                            size: 14,
                            color: _getColorByEstado(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            metodologo.activo ? 'Activo' : 'Inactivo',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getColorByEstado(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}