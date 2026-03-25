import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/b_control/bsmetodologo.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intmetodologo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MetodologoScreen extends StatelessWidget {
  const MetodologoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaDeportesMetodologos controllistadeportes = context.watch<ControlListaDeportesMetodologos>();

    controllistadeportes.verDeportes(ControlSesion.datosusuario!.idUsuario);
    List<Deporte> deportes = controllistadeportes.deportes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metodólogo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: deportes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay deportes asignados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: deportes.length,
              itemBuilder: (context, index) {
                final deporte = deportes[index];
                return CardDeporte(deporte: deporte);
              },
            ),
    );
  }
}

class CardDeporte extends StatelessWidget {
  final Deporte deporte;

  const CardDeporte({
    super.key,
    required this.deporte,
  });

  IconData _getSportIcon(String nombreDeporte) {
    final nombre = nombreDeporte.toLowerCase();

    if (nombre.contains('fútbol') || nombre.contains('futbol')) {
      return Icons.sports_soccer;
    } else if (nombre.contains('baloncesto')) {
      return Icons.sports_basketball;
    } else if (nombre.contains('voleibol') || nombre.contains('voley')) {
      return Icons.sports_volleyball;
    } else if (nombre.contains('tenis')) {
      if (nombre.contains('mesa')) {
        return Icons.sports_tennis; // Para tenis de mesa
      }
      return Icons.sports_tennis;
    } else if (nombre.contains('ajedrez')) {
      return Icons.games;
    } else if (nombre.contains('atletismo')) {
      return Icons.directions_run;
    } else if (nombre.contains('ciclismo') || nombre.contains('bmx') || nombre.contains('push bike')) {
      return Icons.directions_bike;
    } else if (nombre.contains('natación') || nombre.contains('natacion')) {
      return Icons.pool;
    } else if (nombre.contains('gimnasia')) {
      if (nombre.contains('rítmica') || nombre.contains('ritmica')) {
        return Icons.self_improvement;
      }
      return Icons.fitness_center;
    } else if (nombre.contains('patinaje')) {
      return Icons.roller_skating;
    } else if (nombre.contains('karate') || nombre.contains('taekwondo')) {
      return Icons.sports_martial_arts;
    } else if (nombre.contains('esgrima')) {
      return Icons.sports_mma;
    } else if (nombre.contains('pesas')) {
      return Icons.fitness_center;
    } else if (nombre.contains('porrismo')) {
      return Icons.emoji_emotions;
    } else if (nombre.contains('tejo')) {
      return Icons.sports;
    } else if (nombre.contains('paralimpico')) {
      return Icons.accessible;
    } else if (nombre.contains('recreativo')) {
      return Icons.sports_handball;
    } else {
      return Icons.sports; // Icono genérico para deportes
    }
  }

  Color _getSportColor(String genero) {
    switch (genero.toUpperCase()) {
      case 'MASCULINO':
        return Colors.blue;
      case 'FEMENINO':
        return Colors.pink;
      case 'TODOS':
      default:
        return Colors.green;
    }
  }

  String _getGeneroTexto(String genero) {
    switch (genero.toUpperCase()) {
      case 'MASCULINO':
        return 'Masculino';
      case 'FEMENINO':
        return 'Femenino';
      case 'TODOS':
        return 'Mixto';
      default:
        return genero;
    }
  }

  @override
  Widget build(BuildContext context) {
    ControlVerDocumentoAsistencia controlverdocumentoasistencia = context.watch<ControlVerDocumentoAsistencia>();
    ControlComentarios controlcomentarios  = context.watch<ControlComentarios>();
    final sportIcon = _getSportIcon(deporte.nombreDeporte);
    final sportColor = _getSportColor(deporte.genero);
    final generoTexto = _getGeneroTexto(deporte.genero);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior con icono, nombre y botones
            Row(
              children: [
                // Icono del deporte con fondo circular
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: sportColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    sportIcon,
                    color: sportColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Nombre del deporte y género
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deporte.nombreDeporte,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: sportColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          generoTexto,
                          style: TextStyle(
                            fontSize: 12,
                            color: sportColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Botones redondos
                Row(
                  children: [
                    // Botón de mensaje
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.message, color: Colors.blue),
                        onPressed: () {
                         _mostrarDialogoAgregarComentario(context, deporte, controlcomentarios); 
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Botón de descarga
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.download, color: Colors.green),
                        onPressed: () async {
                          DocumentoAsistenciaResponse documentosAsistencia = await controlverdocumentoasistencia.verDocumentosAsistencia(deporte.idDeporte);

                          // Mostrar el diálogo después de obtener los datos
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Descargar Documentos'),
                                content: const Text('Seleccione el formato de descarga:'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Acción para descargar hoja de cálculo
                                      _abrirUrl(context, documentosAsistencia.descargaXlsx);
                                      Navigator.pop(context); // Cerrar el diálogo
                                    },
                                    child: const Text('Ver hoja de cálculo'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Acción para descargar CSV
                                      _abrirUrl(context, documentosAsistencia.descargaCsv);
                                      Navigator.pop(context); // Cerrar el diálogo
                                    },
                                    child: const Text('Ver CSV'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Línea divisoria
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            // Información adicional en fila
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ID del deporte
                _InfoItem(
                  icon: Icons.tag,
                  label: 'ID',
                  value: deporte.idDeporte,
                  color: sportColor,
                ),
                // Cupo máximo
                _InfoItem(
                  icon: Icons.people,
                  label: 'Cupo máx.',
                  value: deporte.cantidadEstudiantesPermitidos.toString(),
                  color: sportColor,
                ),
                // Rango de edades
                _InfoItem(
                  icon: Icons.cake,
                  label: 'Edades',
                  value: '${deporte.edadMinima} - ${deporte.edadMaxima} años',
                  color: sportColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Badge para "Para formulario web" si es true
            if (deporte.paraFormularioWeb)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.web,
                      size: 14,
                      color: Colors.purple,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Visible en formulario web',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500,
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

 void _mostrarDialogoAgregarComentario(BuildContext context, Deporte deporte, ControlComentarios controlcomentarios) {
  final TextEditingController _comentarioController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar Comentario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deporte: ${deporte.nombreDeporte}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Comentario:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _comentarioController,
              maxLines: 5,
              minLines: 3,
              decoration: InputDecoration(
                hintText: 'Escribe tu comentario aquí...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async{
              await controlcomentarios.enviarComentarioCurso(context, deporte.idDeporte, _comentarioController.text);
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: const Text('Enviar'),
          ),
        ],
      );
    },
  );
}

void _abrirUrl(BuildContext context, String url) async {
  if (url.isEmpty) {
    mostrarMensajeInferior(context, 'URL no válida');
    return;
  }

  try {
    // Normalizar la URL
    final Uri uri = Uri.parse(url);
    
    // Verificar si se puede lanzar la URL
    if (await canLaunchUrl(uri)) {
      // Para archivos y URLs específicas, usar externalApplication
      // que abrirá con la aplicación predeterminada del sistema
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Esto abre con la app adecuada
      );
      
      if (!launched && context.mounted) {
        // Si falla, intentar con externalNonBrowserApplication
        final bool fallbackLaunched = await launchUrl(
          uri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        
        if (!fallbackLaunched && context.mounted) {
          mostrarMensajeInferior(context, 'No se encontró una aplicación para abrir este archivo');
        }
      }
    } else {
      // Si no se puede lanzar directamente, mostrar opciones
      if (context.mounted) {
        _mostrarOpcionesAbrir(context, uri);
      }
    }
  } catch (e) {
    if (context.mounted) {
      mostrarMensajeInferior(context, 'Error al abrir: ${e.toString()}');
    }
  }
}

void _mostrarOpcionesAbrir(BuildContext context, Uri uri) async {
  final shouldOpenInBrowser = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Abrir archivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No se pudo abrir automáticamente: ${uri.path.split('/').last}'),
            const SizedBox(height: 8),
            const Text('¿Cómo deseas abrirlo?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Abrir en navegador'),
          ),
        ],
      );
    },
  );
  
  if (shouldOpenInBrowser == true) {
    // Intentar abrir en navegador como fallback
    await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );
  }
}
  /*void _descargarCSV(DocumentoAsistenciaResponse documentos) {
    // Aquí implementas la lógica para descargar el CSV
    print('Descargando CSV...');
    // Tu código aquí
  }*/
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
