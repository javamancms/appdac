import 'package:appdac/b_control/bsdeportes.dart';
import 'package:appdac/b_control/bsestudiantes.dart';
import 'package:appdac/b_control/idioma/bsidiomas.dart';
import 'package:appdac/b_control/bsmetodologo.dart';
import 'package:appdac/b_control/navegacion/router.dart';
import 'package:appdac/b_control/bsprofesores.dart';
import 'package:appdac/b_control/bssesion.dart';
import 'package:appdac/config/config_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appdac/generated/l10n.dart';
import 'package:provider/provider.dart';
//import 'dart:io';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*await FlutterDownloader.initialize(
    debug: true, // Opcional: para ver logs
    ignoreSsl: false, // Solo si necesitas ignorar SSL
  );
*/
  // Cargar configuración antes de iniciar la app
  await ConfigLoader.load();

  // Inicializar el helper de idiomas
  await IdiomaHelper.inicializar();

  // Solicitar permisos para descargas (solo en Android)
  /*if (Platform.isAndroid) {
    await _requestPermissions();
  }*/

  runApp(const MainApp());
}

// Función para solicitar permisos
/*Future<void> _requestPermissions() async {
  try {
    // Lista de permisos necesarios para descargas
    List<Permission> permissions = [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.photos,
      Permission.videos,
      Permission.audio,
    ];

    // Solicitar permisos
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Verificar permisos
    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted && !status.isPermanentlyDenied) {
        allGranted = false;
        print('⚠️ Permiso ${permission.toString()} no concedido');
      } else if (status.isPermanentlyDenied) {
        print('❌ Permiso ${permission.toString()} permanentemente denegado');
      } else {
        print('✅ Permiso ${permission.toString()} concedido');
      }
    });

    if (!allGranted) {
      print('⚠️ Algunos permisos no fueron concedidos. Algunas funcionalidades pueden estar limitadas.');
    } else {
      print('✅ Todos los permisos necesarios han sido concedidos');
    }
  } catch (e) {
    print('Error al solicitar permisos: $e');
  }
}*/

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
        // Agregamos el IdiomaHelper como provider
        ChangeNotifierProvider(
          create: (context) => IdiomaHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlAsistenciaProfesor(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlListaDeporte(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlComunicadosProfesores(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlListaDeportesMetodologos(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlVerDocumentoAsistencia(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControlComentarios(),
        ),
      ],
      child: Consumer<IdiomaHelper>(
        builder: (context, idiomaHelper, child) {
          return MaterialApp.router(
            // Usar el locale actual del helper
            locale: idiomaHelper.idiomaActualLocale,

            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,

            // Configuración de localizaciones
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Idiomas soportados
            supportedLocales: IdiomaHelper.idiomasDisponibles.map((idioma) => Locale(idioma.codigo)).toList(),
          );
        },
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
    return Text(S.of(context).label_usuario);
  }
}
