# SIGApp

Cliente móvil de código abierto para consultar información académica desde el sistema SIGA de la Universidad Nacional de Piura (UNP).

La app permite a los estudiantes acceder de forma rápida y organizada a su horario, historial académico, boletín de cursos y plan de estudios, todo desde una interfaz nativa para Android.

El target principal del proyecto es Android. El soporte web se usa solo como vía auxiliar de depuración puntual, especialmente en WSL.

## Arquitectura

SIGApp está desarrollada en Flutter. Utiliza HTTP directo hacia el backend del sistema académico institucional (`http://academico.unp.edu.pe/`), gestionando cookies y sesiones de forma manual para autenticar y recuperar datos del estudiante.

Ya no utiliza WebView ni DOM scraping.

### Stack

- Flutter (nativo Android)
- HTTP + manejo de sesión (cookies, autenticación)
- Persistencia local con `shared_preferences`

## Limitaciones

- La app no permite modificar datos (registro de cursos, solicitudes, etc.).
- Depende de la estructura actual del backend de SIGA; cambios drásticos podrían afectar el funcionamiento.
- Algunas funcionalidades del sistema oficial (como reportes imprimibles) no están implementadas.

## Entornos soportados

- Windows nativo: mejor experiencia para emuladores Android, Chrome y herramientas GUI.
- WSL: útil para desarrollo diario y debugging puntual, pero requiere setup manual de Android SDK/JDK.
- Web: solo soporte auxiliar de depuración visual; no es el target principal del proyecto.

## Setup rápido

1. Clona el repositorio:

   ```bash
   git clone https://github.com/josedaniel-cb/sigapp.git
   ```

2. Instala dependencias:

   ```bash
   flutter pub get
   ```

3. Verifica que Flutter vea Android:

   ```bash
   flutter doctor -v
   ```

4. Corre en Android dev:

   ```bash
   flutter run --flavor dev --dart-define=FLAVOR=dev
   ```

## Archivos privados requeridos

Este proyecto depende de archivos no versionados. Si faltan, puede compilar parcialmente pero romper en runtime o en release.

- `android/key.properties`
- `android/upload-keystore.jks`
- `android/app/src/dev/google-services.json`
- `android/app/src/prod/google-services.json`
- `environments/local.env`
- `environments/prod.env`

Además, deben existir:

- `lib/firebase_options_dev.dart`
- `lib/firebase_options_prod.dart`

## Android sin Android Studio

También es válido trabajar sin Android Studio, especialmente en WSL o entornos livianos. Lo mínimo que este proyecto terminó necesitando fue:

- JDK 17
- Android SDK por línea de comandos
- `platforms;android-34`
- `platforms;android-36`
- `build-tools;34.0.0`
- `build-tools;28.0.3`
- `platform-tools`
- `ndk;27.0.12077973`
- CMake 3.22.1

Rutas que funcionaron en Linux/WSL:

```bash
export JAVA_HOME="$HOME/.local/java/jdk-17.0.18+8"
export ANDROID_HOME="$HOME/.local/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
flutter config --jdk-dir="$JAVA_HOME"
flutter config --android-sdk "$ANDROID_HOME"
```

En este repo `android/local.properties` debe apuntar al SDK:

```properties
flutter.sdk=/ruta/a/flutter
sdk.dir=/ruta/al/android-sdk
```

## Firebase y flavors

Instala Firebase CLI y FlutterFire CLI:

```bash
bun install -g firebase-tools
dart pub global activate flutterfire_cli
```

Asegúrate de tener `~/.pub-cache/bin` en tu PATH:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

Luego autentícate:

```bash
firebase login
```

> En WSL, si el browser no abre solo, el CLI imprime la URL; ábrela manualmente.

Si ya tienes un `firebase.json` previo, elimínalo antes de configurar.

Prod:

```bash
flutterfire configure \
  --project=sigapp-432a6 \
  --out=lib/firebase_options_prod.dart \
  --android-package-name=com.josedanielcb.sigapp \
  --platforms=android \
  --android-out=android/app/src/prod/google-services.json
```

Dev:

```bash
flutterfire configure \
  --project=sigapp-dev \
  --out=lib/firebase_options_dev.dart \
  --android-package-name=com.josedanielcb.sigapp.dev \
  --platforms=android \
  --android-out=android/app/src/dev/google-services.json
```

## Desarrollo diario

Android dev:

```bash
flutter run --flavor dev --dart-define=FLAVOR=dev
```

APK producción:

```bash
flutter build apk --flavor prod --dart-define=FLAVOR=prod
```

App Bundle producción:

```bash
flutter build appbundle --flavor prod --dart-define=FLAVOR=prod
```

## Depuración inalámbrica por Wi-Fi (Android 11+ / 15)

Usa este flujo cuando quieras depurar desde la misma red local sin cable USB.

1. En el teléfono, activa `Opciones de desarrollador > Wireless debugging`.
2. Toca `Pair device with pairing code`.
3. El teléfono mostrará una IP/puerto de emparejamiento y un código de 6 dígitos.
4. En tu terminal, ejecuta:

   ```bash
   adb pair 192.168.x.x:PUERTO_PAIR
   ```

5. Ingresa el código de 6 dígitos.
6. Vuelve a `Wireless debugging` y busca `IP address & Port`.
7. Conéctate con ese segundo puerto:

   ```bash
   adb connect 192.168.x.x:PUERTO_CONNECT
   ```

8. Verifica:

   ```bash
   adb devices
   flutter devices
   ```

9. Corre la app:

   ```bash
   flutter run -d 192.168.x.x:PUERTO_CONNECT --flavor dev --dart-define=FLAVOR=dev
   ```

Notas:

- `adb pair` y `adb connect` son pasos distintos.
- `adb devices` solo mostrará el teléfono después del `connect`.
- El puerto de `pair` y el de `connect` normalmente son distintos.
- En Android 15 esos puertos cambian con frecuencia; no reutilices uno viejo.

## Web auxiliar de depuración

En WSL, para debugging visual puntual, usa `web-server` y abre la URL desde el navegador de Windows:

```bash
flutter run -d web-server --dart-define=FLAVOR=dev --web-port=8080
```

Si el puerto queda ocupado:

```bash
lsof -t -iTCP:8080 -sTCP:LISTEN | xargs -r kill
```

## Solución de problemas

**Síntoma:** `Cannot recurse at later or equal phase 0` en `build_runner`  
**Fix:**

```ps1
dart run build_runner clean
Get-ChildItem -Path lib -Recurse -Include "*.freezed.dart", "*.g.dart", "*.mocks.dart" | Remove-Item -Force
dart run build_runner build --delete-conflicting-outputs
```

**Síntoma:** AGP falla diciendo que usa Java 11  
**Causa probable:** `JAVA_HOME` o el JDK configurado en Flutter apunta a Java 11.  
**Fix:**

```bash
flutter config --jdk-dir="$JAVA_HOME"
```

**Síntoma:** CMake falla con Ninja en WSL  
**Causa probable:** el `ninja` empaquetado por el SDK/CMake no está usable en ese entorno.  
**Fix inicial:**

```bash
$ANDROID_HOME/cmake/3.22.1/bin/ninja --version
```

En esta máquina hubo que reemplazar ese `ninja` por un binario standalone más reciente.

**Síntoma:** error web de `google_fonts` con igualdad primitiva  
**Causa probable:** versión vieja/incompatible con Flutter/Dart recientes.  
**Fix:** usar en `pubspec.yaml`:

```yaml
google_fonts: ^6.3.3
```

Luego:

```bash
flutter pub get
```

**Síntoma:** `dwdsExtensionAuthentication net::ERR_EMPTY_RESPONSE` en WSL/web  
**Causa probable:** ruido del puente de debug.  
**Fix:** ignóralo salvo que luego aparezca un error real de Dart/Flutter.

**Síntoma:** `FormatException: Invalid port` con `API_GATEWAY_URL`  
**Causa probable:** `environments/local.env` tiene un placeholder como `http://192.168.x.x:xxxx`.  
**Fix:** reemplázalo por una URL válida.

## Contribuciones

Cualquier colaboración es bienvenida. Puedes abrir un issue, proponer mejoras o enviar un pull request. Este es un proyecto comunitario orientado a mejorar la experiencia estudiantil con tecnologías modernas.

<a href="https://github.com/sigapp-unp/sigapp-mobile/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=sigapp-unp/sigapp-mobile" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
