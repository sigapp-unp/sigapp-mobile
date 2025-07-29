# SIGApp

Cliente móvil de código abierto para consultar información académica desde el sistema SIGA de la Universidad Nacional de Piura (UNP).

La app permite a los estudiantes acceder de forma rápida y organizada a su horario, historial académico, boletín de cursos y plan de estudios, todo desde una interfaz nativa para Android.

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

## Instalación

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/josedaniel-cb/sigapp.git
   ```

2. Instalar dependencias:

   ```bash
   flutter pub get
   ```

3. Ejecutar en dispositivo/emulador:

   ```bash
   flutter run
   ```

## Solución de problemas

**Error "Cannot recurse at later or equal phase 0" en build_runner:**

Si build_runner falla con errores de ciclos de librería, ejecuta:

```bash
dart run build_runner clean
# Eliminar archivos generados manualmente
Get-ChildItem -Path lib -Recurse -Include "*.freezed.dart", "*.g.dart", "*.mocks.dart" | Remove-Item -Force
# Rebuild limpio
dart run build_runner build --delete-conflicting-outputs
```

## Contribuciones

Cualquier colaboración es bienvenida. Puedes abrir un issue, proponer mejoras o enviar un pull request. Este es un proyecto comunitario orientado a mejorar la experiencia estudiantil con tecnologías modernas.

<a href="https://github.com/sigapp-unp/sigapp-mobile/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=sigapp-unp/sigapp-mobile" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
