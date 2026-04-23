import 'package:appdac/a_presentacion/guigeneral/menugeneral.dart';
import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:appdac/a_presentacion/widgetspersonalizados/paneliconoinfo.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdministradorScreen extends StatelessWidget {
  const AdministradorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ControlListaProfesores controlListaProfesores = context.watch<ControlListaProfesores>();

    final List<Map<String, dynamic>> paneles = [
      {
        'icon': Icons.person,
        'title': S.of(context).label_profesores,
        'onTap': () {
          controlListaProfesores.cargarProfesores(ControlSesion.datosusuario!.idUsuario);
          context.push('/VerProfesoresAdministrador');
        }
      },
      {
        'icon': Icons.sports,
        'title': S.of(context).label_deportes,
        'onTap': () {
          context.push('/VerDeportesAdministrador');
        },
      },
      {
        'icon': Icons.menu_book,
        'title': S.of(context).label_estudiantes,
        'onTap': () {
          context.push('/VerEstudiantesAdministrador');
        },
      },
      {
        'icon': Icons.timeline,
        'title': S.of(context).label_metodologos,
        'onTap': () {
          context.push('/VerMetodologosAdministrador');
        },
      },
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blanco,
          title: Text(
            S.of(context).label_perfil_administrador,
            style: AppColors.textotitulonegro,
          ),
          //backgroundColor: AppColors.verde.withOpacity(0.8), // AppBar semi-transparente
          elevation: 0,
        ),
        drawer: menuGeneral(context),
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.blanco, 
            image: DecorationImage(
              image: AssetImage('assets/img/logoirdcotafondo.png'),
              fit: BoxFit.contain,
              alignment: Alignment.center,
              opacity: 0.3,
              // Elimina el colorFilter
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: paneles.length,
              itemBuilder: (context, index) {
                return PanelIconoInfo(
                  icon: paneles[index]['icon'] as IconData,
                  info: paneles[index]['title'] as String,
                  cardColor: AppColors.verde,
                  textColor: AppColors.blanco,
                  iconColor: AppColors.blanco,
                  onTap: paneles[index]['onTap'] as VoidCallback,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
