import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/a_presentacion/widgetspersonalizados/panelprofesorlista.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/c_integracion/intprofesores.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaProfesoresScreen extends StatefulWidget {
  const ListaProfesoresScreen({super.key});

  @override
  State<ListaProfesoresScreen> createState() => _ListaProfesoresScreenState();
}

class _ListaProfesoresScreenState extends State<ListaProfesoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Profesor> _filteredProfesores(List<Profesor> profesores) {
    if (_searchQuery.isEmpty) {
      return profesores;
    }

    final queryLower = _searchQuery.toLowerCase();

    return profesores.where((profesor) {
      // Buscar por nombre del profesor
      if (profesor.nombre.toLowerCase().contains(queryLower)) {
        return true;
      }

      // Buscar en la lista de deportes del profesor
      // Verificar si algún deporte contiene el término de búsqueda
      for (String deporte in profesor.nombreDeporte) {
        if (deporte.toLowerCase().contains(queryLower)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ControlListaProfesores controllistaprofesores = context.watch<ControlListaProfesores>();

    List<Profesor> filteredProfesores = _filteredProfesores(controllistaprofesores.profesores);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blanco,
        title: Center(
          child: Text(
            S.of(context).label_listaprofesores,
            style: AppColors.textotitulonegro,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Cambia por el ícono que quieras
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.verde, // Color del ícono
        ),
        actions: [
          IconoProfesor(color: AppColors.blanco, backgroundColor: AppColors.verde,size: 40,borderRadius: 10,)
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).label_buscarnombredeporte,
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                // Agregar un hint más descriptivo
                helperText: S.of(context).label_buscarnombredeporteexp,
                helperStyle: AppColors.textoinformativogris,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.blanco, 
          image: DecorationImage(
            image: AssetImage('assets/img/logoirdcotafondo.png'),
            fit: BoxFit.contain,
            alignment: Alignment.center,
            opacity: 0.3,
            // Eliminado el colorFilter que causaba el problema
          ),
        ),
        child: filteredProfesores.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No se encontraron profesores',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Intenta con otro nombre o deporte',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: filteredProfesores.length,
                itemBuilder: (context, index) {
                  return ProfesorCard(
                    
                    profesor: filteredProfesores[index],
                  );
                },
              ),
      ),
    );
  }
}
