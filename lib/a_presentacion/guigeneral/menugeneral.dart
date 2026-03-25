import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/b_control/idioma/bsidiomas.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget menuGeneral(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        // Encabezado del Drawer
        UserAccountsDrawerHeader(
          accountName: Text(
            ControlSesion.datosusuario != null ? ControlSesion.datosusuario!.nombre : '',
            style: AppColors.textosubtituloblanco,
          ),
          accountEmail: Text(
            ControlSesion.datosusuario != null ? ControlSesion.datosusuario!.type : '',
            style: AppColors.textosubtituloblanco,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.verde,
                AppColors.verdeclaro,
              ],
            ),
          ),
        ),

        ListTile(
          leading: const Icon(
            Icons.settings,
            color: AppColors.verde,
          ),
          title: Text(
            S.of(context).label_configuracion,
            style: AppColors.textosubtitulonegro
          ),
        ),

        // Selector de idioma
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.language,
                color: AppColors.verde,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Consumer<IdiomaHelper>(
                  builder: (context, idiomaHelper, child) {
                    return DropdownButton<Locale>(
                      value: Locale(idiomaHelper.idiomaActualCodigo),
                      isExpanded: true,
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.verde),
                      items: IdiomaHelper.idiomasDisponibles.map((idioma) {
                        return DropdownMenuItem<Locale>(
                          value: Locale(idioma.codigo),
                          child: Text(
                            idioma.nombre,
                            style: AppColors.textosubtitulonegro,
                          ),
                        );
                      }).toList(),
                      onChanged: (Locale? newLocale) async {
                        if (newLocale != null) {
                          // Guardar el idioma seleccionado
                          await IdiomaHelper.guardarIdioma(newLocale.languageCode);
                          
                          // Cerrar el drawer
                          Navigator.pop(context);
                          
                          // No necesitamos redirigir, el Consumer se encargará de rebuildear
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: AppColors.grisclaro,
        ),

        const Spacer(),

        ListTile(
          leading: const Icon(
            Icons.logout,
            color: AppColors.rojo,
          ),
          title: Text(
            S.of(context).label_cerrarsesion,
            style: AppColors.textosubtitulorojo
          ),
          onTap: () {
            ControlListaDeportes.vaciarDeportes();
            ControlSesion.datosusuario = null;
            ControlSesion.credenciales = null;
            context.push('/');
          },
        ),

        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: [
              const Divider(),
              const SizedBox(height: 8),
              Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grisclaro,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}