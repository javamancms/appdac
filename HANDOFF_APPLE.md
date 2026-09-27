# Traspaso: publicar IMRD COTA APP en la App Store

Documento para el agente de Claude (o cualquier persona) que continue el proceso cuando Apple confirme la conversion de la cuenta a organizacion. Sin secretos ni contrasenas.

## 1. Datos clave

| Dato | Valor |
|---|---|
| App | IMRD COTA APP (Flutter, repo `javamancms/appdac`) |
| Bundle ID | `com.nextgonsas.imrdcota` |
| App ID en App Store Connect | 6759175710 (`https://appstoreconnect.apple.com/apps/6759175710`) |
| Version | 2.0.0, build 12 (`pubspec.yaml`: `2.0.0+12`). En App Store Connect el ultimo build subido es el 10 |
| Team ID actual (cuenta individual) | `LNS2LY33X4` (Andres Coral). **Puede cambiar al pasar a organizacion** |
| Empresa | Nextgon SAS, D-U-N-S 570839619, https://nextgonsas.com.co, gerencia@nextgonsas.com.co |
| Caso Apple (conversion a organizacion) | **102977082602**, abierto el 2026-09-26 en developer.apple.com/contact (Membership and Account > Program Enrollment). Apple responde por correo al Apple ID de la cuenta |
| Rama con los arreglos | `ios-release-fixes` (commit local; si no se subio a GitHub, ver seccion 6) |

## 2. Por que Apple rechazo la version 2.0.0 (build 10), 2026-02-18

1. **4.0 Design**: inicio de sesion/registro llevaba al navegador. El login ya es dentro de la app (HTTP a webhook); no hay navegador externo en ese flujo. Se explico en las Notas de revision.
2. **2.1 Information Needed**: faltaba cuenta demo. Cargadas 5 cuentas en Notas de App Store Connect.
3. **2.3.8 Accurate Metadata**: la app se llamaba "Appdac" en el dispositivo. `CFBundleDisplayName`/`CFBundleName` ya son "IMRD COTA APP".
4. **1.5 Safety**: la URL de soporte `imrd-cota.nextgonsas.edu.co` no existe. Cambiadas URL de soporte y de marketing a `https://imrd-cota.nextgonsas.com.co/`.
5. **5.1.1(ix)**: la cuenta debe ser de **organizacion**, no individual. Es el unico punto bloqueante. No se arregla con codigo ni con documentos de permiso: hay que convertir la cuenta (caso 102977082602) o crear una nueva de organizacion y transferir la app.

## 3. Estado al momento de escribir esto

- Hecho: cambios de codigo, IPA de prueba firmado con el equipo individual, URLs, cuentas demo y datos de contacto en "Informacion de revision", solicitud de conversion enviada.
- Pendiente: respuesta de Apple. **No subir ni reenviar a revision hasta que la cuenta sea de organizacion.**

Cuentas demo (usuario): estudiante `c.david`, estudiante `s.martinez`, profesor `l.gomez`, metodologo `c.morales`, administrador `apple.administrador`. La clave esta en las Notas de la version en App Store Connect (Distribucion > version 2.0.0 > Informacion para el equipo de revision de apps > Notas).

## 4. Que hacer cuando Apple confirme (paso a paso)

### 4.1 Verificar la cuenta
1. En developer.apple.com/account, el tipo de miembro debe decir **Organization** (Nextgon SAS).
2. Anotar el **Team ID** de la organizacion (Membership details). Compararlo con `LNS2LY33X4`.
3. En App Store Connect confirmar que la app 6759175710 sigue en la cuenta. Si Apple creo una cuenta nueva en vez de convertir, transferir la app: Informacion de la app > Transferir app.

### 4.2 Crear la clave de API de App Store Connect (desde cualquier PC, en el navegador)
1. App Store Connect > Usuarios y acceso > Integraciones > Claves de App Store Connect > "+".
2. Rol **Admin** (necesario para que la firma automatica pueda crear certificados de distribucion).
3. Descargar `AuthKey_XXXX.p8` (solo se descarga una vez) y copiar **Key ID** e **Issuer ID**.

### 4.3 Configurar los secretos en GitHub
Repo `javamancms/appdac` > Settings > Secrets and variables > Actions > New repository secret:

| Secret | Contenido |
|---|---|
| `ASC_KEY_ID` | Key ID de la clave |
| `ASC_ISSUER_ID` | Issuer ID |
| `ASC_KEY_P8` | Contenido completo del `.p8` (incluye las lineas BEGIN/END) |
| `APPLE_TEAM_ID` | Team ID de la organizacion |

### 4.4 Llevar el codigo a GitHub
La rama `ios-release-fixes` tiene los arreglos y el flujo `.github/workflows/ios-release.yml`. Hacer PR a `main` y fusionar, o ejecutar el flujo desde la rama (Actions > "iOS Release (App Store Connect)" > Run workflow > elegir rama).

### 4.5 Subir el build
1. Ejecutar el flujo "iOS Release (App Store Connect)". Compila con Flutter 3.41.1, archiva sin firmar, firma con el equipo de la organizacion y **sube directo a App Store Connect** (`destination: upload`).
2. Si el numero de build ya existe, subir `version:` en `pubspec.yaml` (p. ej. `2.0.0+13`) y repetir.
3. Esperar el correo "build procesado" (5-30 min). El build aparece en App Store Connect > version 2.0.0 > Compilacion.

### 4.6 Reenviar a revision (navegador)
1. Distribucion > version 2.0.0 > seccion **Compilacion**: quitar la 10 y elegir la nueva (12 o superior).
2. Revisar que sigan guardados: URL de soporte/marketing, Notas con cuentas demo, datos de contacto.
3. Revisar App Privacy y el nombre de la app.
4. Ir a Revision de apps > envio rechazado > **Volver a enviar a revision de apps**. Opcionalmente responder al mensaje de Apple en Resolution Center explicando los 5 puntos de la seccion 2.

## 5. Problemas conocidos

- **Xcode 27 exige iOS minimo 15.0**: ya subido a 15.0 en el proyecto y en `ios/Podfile`.
- **`intl`**: con Flutter 3.41 hay que usar `^0.20.2` (ya cambiado).
- **Perfil de desarrollo**: la cuenta no tiene dispositivos registrados, por eso `flutter build ipa` falla al firmar. Solucion usada: archivar sin firmar y firmar al exportar con `-allowProvisioningUpdates` (perfil de distribucion, no requiere dispositivos). El flujo de GitHub hace lo mismo con la clave API.
- **Team ID en el proyecto**: `ios/Runner.xcodeproj/project.pbxproj` tiene `DEVELOPMENT_TEAM = LNS2LY33X4` en Runner. Si el Team ID cambia, actualizarlo (el flujo lo sobrescribe con `APPLE_TEAM_ID`, pero conviene dejarlo coherente).
- **App Store Connect Guardar**: en la pantalla de la version, si no persiste un cambio, pulsar Guardar y recargar para verificar.
- **Chrome con la extension de Claude**: usar el navegador del equipo correcto (listar con `list_connected_browsers`). Antes se uso por error un Chrome de Windows sin sesion de Apple.

## 6. Si el commit no llego a GitHub

El commit esta en la rama local `ios-release-fixes`. Desde un equipo con acceso a GitHub: `git push -u origin ios-release-fixes`. Como respaldo hay un archivo `appdac-ios-release-fixes.bundle` (git bundle): `git clone appdac-ios-release-fixes.bundle -b ios-release-fixes appdac` y luego `git remote set-url origin https://github.com/javamancms/appdac.git`.

## 7. Prompt sugerido para el agente

> Lee `HANDOFF_APPLE.md`. Apple ya convirtio la cuenta a organizacion (caso 102977082602). Verifica el tipo de cuenta y el Team ID, ayudame a crear la clave API y los secretos de GitHub, ejecuta el flujo "iOS Release (App Store Connect)", confirma que el build aparece en App Store Connect, selecciona el build nuevo en la version 2.0.0 y reenvia a revision. No cambies ni inventes credenciales; si necesitas iniciar sesion, pideme que lo haga yo.
