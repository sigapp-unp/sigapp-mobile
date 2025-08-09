# Arquitectura Offline-First con Firebase en Flutter

Un enfoque probado para maximizar la experiencia offline sin disparar tu cuota de Firestore.

## 1. Inicialización de Firebase

1. **Dependencias**
   En `pubspec.yaml` añade:

   ```yaml
   dependencies:
     firebase_core: ^2.20.0
     cloud_firestore: ^5.4.0
   ```

   Luego ejecuta:

   ```bash
   flutter pub get
   ```

2. **Configuración nativa**

   - **Android**: coloca `google-services.json` en `android/app/`.
   - **iOS**: añade `GoogleService-Info.plist` en Runner.
   - Usa la CLI de FlutterFire para generar `firebase_options.dart`:

     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```

3. **Arranque de la app**
   En `main.dart` haz:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';

   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     runApp(const MyApp());
   }
   ```

   Así tendrás `FirebaseFirestore.instance` listo y la persistencia offline activada por defecto.

## 2. Persistencia offline nativa

- **SQLite interno**: en Android/iOS Firestore cachea lecturas y encola escrituras automáticamente, sin código extra.
- **Cache ilimitado** (opcional para datasets grandes):

  ```dart
  FirebaseFirestore.instance.settings = Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  ```

  Esto impide que el SDK limpie datos antiguos y maximiza tu cobertura offline.

### Estructura optimizada con studentCode como ID

```
/students                         ← colección raíz de usuarios
  /{studentCode}                  ← doc por alumno (ID = studentCode)
    ├─ preferences/               ← subcolección de preferencias
    │    ├─ global                ← doc de preferencias globales
    │    │    └── courseChain: Map<String, any>
    │    │         ├── highlightCriticalPath: bool
    │    │         └── viewMode: string ("tree", etc)
    │    │    [otras preferencias globales en camelCase...]
    │    │
    │    └─ _semesters            ← doc contenedor
    │         └─ data/            ← subcolección por semestre
    │              └─ {semesterId}     (p.ej. "20241", "20242")
    │                   └── scheduleHiddenEvents: string[]
    │
    └─ gradeSimulations/          ← subcolección de simulaciones de notas
         └─ {courseCode}          ← doc por curso (p.ej. "MATE101")
             ├── lastModified: Timestamp   ← para sync/cache
             │
             ├── categories: Map<String, Object>  ← categorías embebidas
             │    ├─ "0": { name: string, weight: number }
             │    ├─ "1": { name: string, weight: number }
             │    └─ ...                         ← claves = índices "0","1",...
             │
             └── grades: Map<String, Object>     ← notas embebidas
                  ├─ "0": {
                  │      categoryIndex: number,  ← índice de categoría padre
                  │      name: string,
                  │      score: number,
                  │      enabled: bool
                  │   }
                  ├─ "1": { ... }
                  └─ ...
```

**📍 Cambios aplicados para optimización de costos:**

1. **✅ studentCode como ID**: Eliminado el overhead de buscar firebaseUID
2. **✅ Campos redundantes removidos**:
   - `courseCode` (implícito en document ID)
   - `studentCode` (implícito en la ruta del usuario)
   - `id` opcional de CourseTracking
3. **✅ Estructura de semestres**: Usando `_semesters/data/{semesterId}` para compatibilidad con Firestore
4. **✅ Acceso directo**: Sin queries, sin cache, sin operaciones extra

**🚀 Beneficios de rendimiento:**

| Operación               | Antes                     | Después           | Ahorro    |
| ----------------------- | ------------------------- | ----------------- | --------- |
| **Get preferences**     | 2+ lecturas (query + get) | 1 lectura directa | 50%+      |
| **Update preferences**  | 2+ operaciones            | 1 operación       | 50%+      |
| **Get course tracking** | 2+ lecturas               | 1 lectura         | 50%+      |
| **Referencias**         | `await _getRef()`         | `_getRef()`       | Síncronas |

### 🛠 Definición de modelos Freezed + JsonSerializable

```dart
@freezed
class Grade with _$Grade {
  const factory Grade({
    required String id,
    required String categoryId,
    required String name,
    required double score,
    @Default(true) bool enabled,
  }) = _Grade;

  factory Grade.fromJson(Map<String, dynamic> json) =>
      _$GradeFromJson(json);
}

// (etc.)
```

### 🔗 Referencias tipadas con `withConverter`

```dart
// Ejemplo ficticio ilustrativo
final userSimRef = FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .collection('courseSimulators')
  .withConverter<CourseSimulator>(
    fromFirestore: (snap, _) => CourseSimulator.fromJson({
      ...snap.data()!..['id'] = snap.id,
      'courseCode': snap.id,
    }),
    toFirestore:   (cs, _)   => cs.copyWith(id: null).toJson()..remove('id'),
  );
```

#### 📝 Resumen

1. **No hay “crear tablas”**: tus colecciones y documentos surgen al insertar datos.
2. Usa **Freezed + JsonSerializable** para modelos fuertemente tipados.
3. Aplica **`withConverter<T>`** para obtener `DocumentReference<T>` en lugar de `Map<String, dynamic>`.
4. Elige entre subcolecciones bajo `users/{uid}` (opción A) o colecciones top-level separadas (opción B) según tus necesidades de consulta.

Con esto tienes tu esquema relacional/JSONB de Supabase adaptado a Firestore de forma clara, mantenible y sin ambigüedad en la API.

## 6. Monitoreo de conectividad (propuesta a evaluar)

Detecta cuando el dispositivo recupera conexión para reintentar escrituras pendientes:

```dart
Connectivity().onConnectivityChanged.listen((status) {
  if (status != ConnectivityResult.none) {
    _flushAllPending();
  }
});
```

Incluye lógica de **retry/backoff** para fallos temporales.

## 7. Optimización de cuota

- **`FieldValue.arrayUnion`/`arrayRemove`** para cambiar solo un elemento en arrays.
- **WriteBatch** o **Transaction** para agrupar múltiples documentos en un solo RPC.
- **Índices compuestos** para acelerar consultas con filtros y ordenamientos.

## 8. Buenas prácticas NoSQL y de seguridad

- **Modela según acceso**: denormaliza en lugar de usar JOINs; duplica datos si reduce lecturas.
- **Subcollections** para listas muy largas.
- Define **Security Rules** basadas en `request.auth` y validaciones de esquema.
- Añade versión de esquema (`schemaVersion`) en tus documentos para migraciones controladas.

## 9. Herramientas opcionales

- Paquetes como [brick_offline_first](https://pub.dev/packages/brick_offline_first) combinan SQLite local y Firestore en un repositorio único, con cache, sync y deduplicación declarativa.

**Resumen de beneficios**:

| Técnica                     | Impacto                                        |
| --------------------------- | ---------------------------------------------- |
| Persistencia offline nativa | Lecturas y escrituras en cola sin código extra |
| `get()` puntuales           | Minimizas lecturas activas                     |
| Debiance + WriteBatch       | Agrupas cambios y ahorras peticiones           |
| Repository Pattern          | Código limpio y desacoplado                    |
| Conectividad + retry        | Sincronización robusta post-offline            |

Con este patrón la UI siempre responde al instante, tu cuota de Firestore se mantiene baja y tu app funciona 100 % offline sin cache casera.

Aquí tienes cómo trasladar tu idea relacional/JSONB de Supabase a Cloud Firestore, sin “tablas” ni migraciones complejas, sino con dos colecciones bien organizadas y modelos tipados:

## 10. ToDo

[ ] Crear reglas para que los estudiantes solo puedan editar sus propios registros
