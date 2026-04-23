import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/a_presentacion/guigeneral/menugeneral.dart';
import 'package:appdac/a_presentacion/tema/iconos.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsmetodologo.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/c_integracion/intmetodologo.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MetodologoScreen extends StatelessWidget {
  const MetodologoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaDeportesMetodologos controllistadeportes = context.watch<ControlListaDeportesMetodologos>();

    if (ControlSesion.datosusuario != null) {
      controllistadeportes.verDeportes(ControlSesion.datosusuario!.idUsuario);
    }
    List<Deporte> deportes = controllistadeportes.deportes;

    return PopScope(
      canPop: false, // Desactiva la navegación hacia atrás
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blanco,
          title: Center(
            child: Text(
              S.of(context).label_metodologo,
              style: AppColors.textotitulonegro,
            ),
          ),
          /*leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            color: AppColors.verde,
          ),*/
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconoMetodologo(
                color: AppColors.blanco,
                backgroundColor: AppColors.verde,
                size: 30,
                borderRadius: 10,
              ),
            )
          ],
        ),
        drawer: menuGeneral(context),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/logoirdcotafondo.jpeg'),
              fit: BoxFit.contain,
              alignment: Alignment.center,
              opacity: 0.3,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.dstOver),
            ),
          ),
          child: deportes.isEmpty
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
        ),
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
    ControlComentarios controlcomentarios = context.watch<ControlComentarios>();
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
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deporte.nombreDeporte,
                        style: AppColors.textosubtitulonegro,
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
                          color: AppColors.gris.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          generoTexto,
                          style: AppColors.textosubtituloverde,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.azulrey.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.message, color: AppColors.azulrey),
                        onPressed: () {
                          _mostrarDialogoAgregarComentario(context, deporte, controlcomentarios);
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.verde.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.download, color: AppColors.verde),
                        onPressed: () async {
                          DocumentoAsistenciaResponse documentosAsistencia = await controlverdocumentoasistencia.verDocumentosAsistencia(deporte.idDeporte);

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  S.of(context).label_descargardocumentos,
                                  style: AppColors.textotituloverde,
                                ),
                                content: Text(
                                  S.of(context).label_seleccioneformato,
                                  style: AppColors.textosubtitulonegro,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _abrirUrl(context, documentosAsistencia.descargaXlsx);
                                      Navigator.pop(context);
                                    },
                                    style: AppColors.botonverde,
                                    child: Text(S.of(context).label_verhojacalculo),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _abrirUrl(context, documentosAsistencia.descargaCsv);
                                      Navigator.pop(context);
                                    },
                                    style: AppColors.botonverde,
                                    child: Text(S.of(context).label_vercsv),
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
            Divider(
              height: 1,
              color: AppColors.gris.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoItem(
                  icon: Icons.tag,
                  label: 'ID',
                  value: deporte.idDeporte,
                  color: AppColors.verde,
                ),
                _InfoItem(
                  icon: Icons.people,
                  label: S.of(context).label_cupomax,
                  value: deporte.cantidadEstudiantesPermitidos.toString(),
                  color: AppColors.verde,
                ),
                _InfoItem(
                  icon: Icons.cake,
                  label: S.of(context).label_edades,
                  value: '${deporte.edadMinima} - ${deporte.edadMaxima} ${S.of(context).label_anos}',
                  color: AppColors.verde,
                ),
              ],
            ),
            const SizedBox(height: 8),
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
          backgroundColor: AppColors.blanco,
          title: Text(
            S.of(context).label_agregarcomentario,
            style: AppColors.textotituloverde,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${S.of(context).label_deporte}: ${deporte.nombreDeporte}',
                style: AppColors.textosubtitulonegro,
              ),
              const SizedBox(height: 16),
              Text(
                '${S.of(context).label_comentario}:',
                style: AppColors.textosubtitulonegro,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _comentarioController,
                maxLines: 5,
                minLines: 3,
                decoration: DecoracionCampoVerdeFondoGris(letrero: S.of(context).label_escribecomentario),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: AppColors.botonblanco,
              child: Text(
                S.of(context).label_cancelar,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await controlcomentarios.enviarComentarioCurso(context, deporte.idDeporte, _comentarioController.text);
                Navigator.pop(context);
              },
              style: AppColors.botonverde,
              child: Text(S.of(context).label_enviar),
            ),
          ],
        );
      },
    );
  }

  void _abrirUrl(BuildContext context, String url) async {
    if (url.isEmpty) {
      mostrarMensajeInferior(context, S.of(context).msj_urlinvalida);
      return;
    }

    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched && context.mounted) {
          final bool fallbackLaunched = await launchUrl(
            uri,
            mode: LaunchMode.externalNonBrowserApplication,
          );

          if (!fallbackLaunched && context.mounted) {
            mostrarMensajeInferior(context, S.of(context).msj_noencontreaplicacion);
          }
        }
      } else {
        if (context.mounted) {
          _mostrarOpcionesAbrir(context, uri);
        }
      }
    } catch (e) {
      if (context.mounted) {
        mostrarMensajeInferior(context, '${S.of(context).msj_noencontreaplicacion}: ${e.toString()}');
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
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    }
  }
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
            style: AppColors.textoinformativogris,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppColors.textosecundarionegro,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
