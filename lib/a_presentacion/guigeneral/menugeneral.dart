import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget menuGeneral(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        // Encabezado del Drawer
        UserAccountsDrawerHeader(
          accountName: Text(
            ControlSesion.datosusuario != null ? ControlSesion.datosusuario!.nombre : '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            ControlSesion.datosusuario != null ? ControlSesion.datosusuario!.type : '',
            style: const TextStyle(
              fontSize: 14,
            ),
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

        // Opción 1: Configuración
        ListTile(
          leading: const Icon(
            Icons.settings,
            color: AppColors.verde,
          ),
          title: const Text(
            'Configuración',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
            // Navegar a la pantalla de configuración
            // context.push('/configuracion');
            //_mostrarMensaje(context, 'Configuración seleccionada');
          },
        ),

        // Divider entre opciones
        const Divider(
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: Colors.grey,
        ),

        // Espacio flexible para empujar los elementos inferiores hacia abajo
        const Spacer(),

        // Opción 2: Cerrar sesión
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          onTap: () {
            //Navigator.pop(context); // Cierra el drawer
            //_mostrarDialogoCerrarSesion(context);
            ControlListaDeportes.vaciarDeportes();
            ControlSesion.datosusuario = null;
            ControlSesion.credenciales = null;
            context.push('/');
          },
        ),

        // Información de versión o footer
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
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}