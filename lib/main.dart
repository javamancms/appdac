import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/bsmetodologo.dart';
import 'package:appdac/b_control/navegacion/router.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/config/config_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar configuración antes de iniciar la app
  await ConfigLoader.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

   

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ControlSesion(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlListaProfesores(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlListaDeportes(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlAsistencia(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlActualizarDocumentos(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlComunicados(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlInscribirDeportes(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlListaDeportesAdministrador(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlListaEstudiantesAdministrador(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlListaMetodologos(),
         
        ),
        ChangeNotifierProvider(
           create: (context) => ControlListaDeportesProfesor(),
         
        ),
      ],
      child: MaterialApp.router(
        //theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, S.delegate],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}

class PanelPrueba extends StatelessWidget {
  const PanelPrueba({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /*final config = AppConfig.instance;
    logear('-------------------------------------------------------------------------');
    logear('dato:${config.parametros['urllogin']}');
    logear('-------------------------------------------------------------------------');*/

    return Text(S.of(context).label_usuario);
  }
}
