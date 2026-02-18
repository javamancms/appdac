import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

// Importaciones necesarias (ajusta según tu proyecto)
import 'package:appdac/a_presentacion/dialogos_generales/dialogos.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/config/log.dart';
import 'package:appdac/generated/l10n.dart';

class DialogoActualizarDatos extends StatefulWidget {
  const DialogoActualizarDatos({Key? key}) : super(key: key);

  static Future<void> mostrar(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DialogoActualizarDatos(),
    );
  }

  @override
  _DialogoActualizarDatosState createState() => _DialogoActualizarDatosState();
}

class _DialogoActualizarDatosState extends State<DialogoActualizarDatos> {
  File? _archivoDocumento;
  File? _certificadoEps;
  File? _consentimientoInformado;

  bool _enviando = false;
  ControlActualizarDocumentos? _controldocumentos;

  @override
  Widget build(BuildContext context) {
    _controldocumentos = context.watch<ControlActualizarDocumentos>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera del diálogo
              _buildCabeceraDialogo(),

              const SizedBox(height: 16),

              // Contenido del diálogo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instrucción
                    _buildInstruccion(),

                    const SizedBox(height: 24),

                    // Campo para Archivo Documento
                    _buildCampoDocumento(
                      titulo: S.of(context).label_arcdocumento,
                      archivo: _archivoDocumento,
                      onTap: () => _seleccionarArchivo('documento'),
                    ),

                    const SizedBox(height: 16),

                    // Campo para Certificado EPS
                    _buildCampoDocumento(
                      titulo: S.of(context).label_certeps,
                      archivo: _certificadoEps,
                      onTap: () => _seleccionarArchivo('eps'),
                    ),

                    const SizedBox(height: 16),

                    // Campo para Consentimiento Informado
                    _buildCampoDocumento(
                      titulo: S.of(context).label_consentimiento,
                      archivo: _consentimientoInformado,
                      onTap: () => _seleccionarArchivo('consentimiento'),
                    ),

                    const SizedBox(height: 32),

                    // Botones de acción
                    _buildBotonesAccion(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para la cabecera del diálogo
  Widget _buildCabeceraDialogo() {
    return Container(
      decoration: BoxDecoration(
        color:AppColors.verde,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.update, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).label_tituloactudocs,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blanco,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${S.of(context).label_estudiante}: ${ControlSesion.datosusuario?.nombre ?? 'Usuario'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.blanco,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Widget para la instrucción
  Widget _buildInstruccion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.verde),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.verde),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).label_docrequerida,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.verde,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Suba los siguientes documentos en formato PDF',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.verde,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cada campo de documento
  Widget _buildCampoDocumento({
    required String titulo,
    required File? archivo,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.picture_as_pdf, color: AppColors.verde, size: 18),
            const SizedBox(width: 6),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.verde,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: archivo != null ? Colors.green : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: archivo != null ? AppColors.verde : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    archivo != null ? _obtenerNombreArchivo(archivo!.path) : S.of(context).label_selectpdf,
                    style: TextStyle(
                      fontSize: 14,
                      color: archivo != null ?AppColors.verde : Colors.grey.shade600,
                      fontWeight: archivo != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (archivo != null)
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: Colors.red.shade600),
                    onPressed: () => _eliminarArchivo(titulo == S.of(context).label_arcdocumento
                        ? 0
                        : titulo == S.of(context).label_certeps
                            ? 1
                            : titulo == S.of(context).label_consentimiento
                                ? 2
                                : -1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
        if (archivo != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
              const SizedBox(width: 6),
              Text(
                'Documento cargado',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Widget para botones de acción
  Widget _buildBotonesAccion() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            child: Text(
              S.of(context).label_cancelar,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _enviando ? null : _validarYEnviar,
            style: ElevatedButton.styleFrom(
              backgroundColor: _puedeEnviar() ? AppColors.verde : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: _enviando
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send, color:  AppColors.blanco, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        S.of(context).label_enviar,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blanco,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // Método para seleccionar archivo PDF
  Future<void> _seleccionarArchivo(String tipo) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File archivo = File(result.files.single.path!);

        setState(() {
          switch (tipo) {
            case 'documento':
              _archivoDocumento = archivo;
              break;
            case 'eps':
              _certificadoEps = archivo;
              break;
            case 'consentimiento':
              _consentimientoInformado = archivo;
              break;
          }
        });
      }
    } catch (e) {
      mostrarMensajeInferior(
        context,
        S.of(context).msj_errorseleccarchivo,
        colorFondo: Colors.red.shade700,
        colorFuente: Colors.white,
        tamanoFuente: 14,
      );
    }
  }

  // Método para eliminar archivo seleccionado
  void _eliminarArchivo(int idarchivo) {
    setState(() {
      switch (idarchivo) {
        case 0:
          _archivoDocumento = null;
          break;
        case 1:
          _certificadoEps = null;
          break;
        case 2:
          _consentimientoInformado = null;
          break;
      }
    });
  }

  // Método para validar y enviar documentos
  void _validarYEnviar() async {
    logear('enviar documentos: ${_puedeEnviar()}');

    if (!_puedeEnviar()) {
      mostrarMensajeInferior(
        context,
        S.of(context).msj_errorselecctresarchivos,
        colorFondo: Colors.red,
        colorFuente: Colors.yellow,
        tamanoFuente: 15,
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      /*_controldocumentos!.enviarDocumentacion(
        ControlSesion.datosusuario!.idUsuario,
        _archivoDocumento!,
        _certificadoEps!,
        _consentimientoInformado!,
      );*/

      // Mostrar mensaje de éxito y cerrar diálogo
      mostrarMensajeInferior(
        context,
        S.of(context).msj_docsenviados,
        colorFondo: Colors.green.shade700,
        colorFuente: Colors.white,
        tamanoFuente: 15,
      );

      Navigator.of(context).pop();
    } catch (e) {
      mostrarMensajeInferior(
        context,
        '${S.of(context).msj_errorenvdocs} $e',
        colorFondo: Colors.red.shade700,
        colorFuente: Colors.white,
        tamanoFuente: 14,
      );
    } finally {
      if (mounted) {
        setState(() => _enviando = false);
      }
    }
  }

  // Validar si se pueden enviar los documentos
  bool _puedeEnviar() {
    return _archivoDocumento != null && _certificadoEps != null && _consentimientoInformado != null;
  }

  // Método auxiliar para obtener nombre corto del archivo
  String _obtenerNombreArchivo(String path) {
    List<String> partes = path.split('/');
    String nombreCompleto = partes.last;

    // Limitar longitud del nombre si es muy largo
    if (nombreCompleto.length > 25) {
      return '${nombreCompleto.substring(0, 20)}...${nombreCompleto.substring(nombreCompleto.length - 4)}';
    }

    return nombreCompleto;
  }
}
