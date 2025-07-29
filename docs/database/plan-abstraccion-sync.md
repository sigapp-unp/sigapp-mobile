## Guía Ultra-Detallada de Refactorización: Extracción del Módulo Sync

> **Objetivo**: Mover toda la lógica de sincronización del módulo `grade_simulator` a un nuevo módulo `grade_sync`, proporcionando ejemplos de diffs, rutas exactas, clases renombradas, cambios en DI y sugerencias de commits.

---

### 1. Preparación del Módulo `grade_sync`

1. **Crear carpeta y pubspec**

   ```bash
   mkdir -p lib/grade_sync/{application/usecases,domain/entities,infrastructure/{database,dtos,repositories,services}}
   cat <<EOF > lib/grade_sync/pubspec.yaml
   name: grade_sync
   version: 0.1.0
   dependencies:
     injectable: ^1.5.0
     drift: ^2.4.0
     dio: ^5.0.0
   EOF
   ```

2. **Registrar inyección** (`lib/grade_sync/grade_sync_injectable.dart`)

   ```dart
   @module
   abstract class GradeSyncModule {
     @lazySingleton
     SyncManager get syncManager;
     @lazySingleton
     SingleWriteClient get singleWriteClient;
     @lazySingleton
     SyncQueueRepository get syncQueueRepository;
     @factory
     GetSyncMetricsUseCase get getSyncMetricsUseCase;
   }
   ```

3. **Actualizar `grade_simulator/pubspec.yaml`**

   ```diff
   dependencies:
   -  # ...
   +  grade_sync:
   +    path: ../grade_sync
   ```

---

### 2. Migración de Archivos (con Diffs)

Cada sección incluye **origen**, **destino**, **clases/funciones** principales y **diff** de ejemplo.

#### 2.1 `sync_constants.dart`

- **Origen**: `grade_simulator/domain/sync_constants.dart`
- **Destino**: `grade_sync/domain/sync_constants.dart`

<details>
<summary>Diff ejemplo</summary>

```diff
-from enum SyncStatus { pending, synced, failed }
+# lib/grade_sync/domain/sync_constants.dart
+enum SyncStatus { pending, synced, failed }
@@
-extension SyncStatusExtension on SyncStatus {
-  String get value => toString().split('.').last;
-}
+extension SyncStatusExtension on SyncStatus {
+  String get value => toString().split('.').last;
+}
@@
-const int defaultMaxRetryCount = 3;
+const int defaultMaxRetryCount = 3;
```

</details>

#### 2.2 Drift Table `sync_queue.dart`

- **Origen**: `grade_simulator/infrastructure/database/sync_queue.dart`
- **Destino**: `grade_sync/infrastructure/database/sync_queue.dart`

<details>
<summary>Diff ejemplo</summary>

```diff
- import 'package:drift/drift.dart';
+ // lib/grade_sync/infrastructure/database/sync_queue.dart
+ import 'package:drift/drift.dart';
+ import 'package:grade_sync/domain/sync_constants.dart';
@@
- class SyncQueue extends Table {
+ @DataClassName('SyncQueueData')
+ class SyncQueue extends Table {
@@
- @override String get tableName => 'sync_queue';
+ // Mantener tableName para migración de datos en SQLite
+ @override String get tableName => 'sync_queue';
```

</details>

#### 2.3 DTOs de Reporting

- **Origen**: `grade_simulator/infrastructure/dtos/sync_reporting_dtos.dart` y `dtos.dart`
- **Destino**: `grade_sync/infrastructure/dtos/`

<details>
<summary>Diff `dtos.dart`</summary>

```diff
- // Infrastructure DTOs for sync queue
- export 'sync_reporting_dtos.dart';
+ // lib/grade_sync/infrastructure/dtos/dtos.dart
+ export 'sync_reporting_dtos.dart';
```

</details>

#### 2.4 Cliente JSONB `SingleWriteClient`

- **Origen**: `grade_simulator/infrastructure/repositories/remote/single_write_client.dart`
- **Destino**: `grade_sync/infrastructure/services/single_write_client.dart`

<details>
<summary>Diff ejemplo</summary>

```diff
- import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
+ // lib/grade_sync/infrastructure/services/single_write_client.dart
+ import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
+ import 'package:grade_sync/domain/sync_constants.dart';
@@
- class SingleWriteClient {
+ @injectable
+ class SingleWriteClient {
@@ constructor
- const SingleWriteClient(this._client, this._logger);
+ SingleWriteClient(this._client, this._logger);
```

</details>

#### 2.5 `SyncQueueRepository`

- **Origen**: `grade_simulator/infrastructure/repositories/sync_queue_repository.dart`
- **Destino**: `grade_sync/infrastructure/repositories/sync_queue_repository.dart`

<details>
<summary>Diff ejemplo</summary>

```diff
- import 'package:sigapp/grade_simulator/domain/sync_constants.dart';
+ // lib/grade_sync/infrastructure/repositories/sync_queue_repository.dart
+ import 'package:grade_sync/domain/sync_constants.dart';
@@
- @singleton
+ @LazySingleton(as: SyncQueueRepository)
```

</details>

#### 2.6 Servicio de Sincronización `SyncManager`

- **Origen**: `grade_simulator/infrastructure/services/sync_manager.dart`
- **Destino**: `grade_sync/infrastructure/services/sync_manager.dart`
- **Cambios clave**:

  - Renombrar `GradeSimulatorSyncManager` → `SyncManager`
  - Ajustar constructor para recibir `SyncClient` interfaces en lugar de repositorios directos

<details>
<summary>Diff de clase</summary>

```diff
- @LazySingleton()
- class GradeSimulatorSyncManager {
+ @LazySingleton()
+ class SyncManager {
@@
-   final GradeTrackingCourseRepository _courseRepository;
-   final GradeTrackingCategoryRepository _categoryRepository;
-   final GradeTrackingGradeRepository _gradeRepository;
+   final CourseSyncClient _courseClient;
+   final CategorySyncClient _categoryClient;
+   final GradeSyncClient _gradeClient;
@@
-   GradeSimulatorSyncManager(
-     this._syncQueueRepository,
-     this._logger,
-     @Named('remote') this._courseRepository,
-     @Named('remote') this._categoryRepository,
-     @Named('remote') this._gradeRepository,
-   );
+   SyncManager(
+     this._syncQueueRepository,
+     this._logger,
+     this._courseClient,
+     this._categoryClient,
+     this._gradeClient,
+   );
```

</details>

#### 2.7 `ResumeSync` y `ConflictResolver`

- **Mover** sin cambios de lógica pero con imports apuntando a `grade_sync`.
- **Renombrar** la clase para reflejar módulo: `GradeSyncResumeService`, `ConflictResolver`.

---

### 3. Ajustes en `grade_simulator`

1. **Rutas**: borrar carpetas

   ```bash
   git rm -r lib/grade_simulator/infrastructure/services
   git rm lib/grade_simulator/infrastructure/repositories/sync_queue_repository.dart
   git rm lib/grade_simulator/infrastructure/database/sync_queue.dart
   git rm lib/grade_simulator/infrastructure/dtos/sync_reporting_dtos.dart lib/grade_simulator/infrastructure/dtos/dtos.dart
   ```

2. **Proxy Repositories**: diffs de imports

   ```diff
   - import 'package:sigapp/grade_simulator/infrastructure/services/sync_manager.dart';
   + import 'package:grade_sync/infrastructure/services/sync_manager.dart';
   ```

3. **Casos de Uso y Widgets**:

   ```diff
   - import 'package:sigapp/grade_simulator/infrastructure/services/sync_manager.dart';
   + import 'package:grade_sync/application/usecases/get_sync_metrics_use_case.dart';
   ```

---

### 4. Sugerencias de Commits por Fase

- **feat(sync): scaffold grade_sync module and pubspec**
- **refactor(domain): move sync_constants to grade_sync**
- **refactor(database): migrate Drift table sync_queue to grade_sync**
- **refactor(dto): move sync_reporting_dtos and dtos**
- **chore(di): register SyncManager, SingleWriteClient, SyncQueueRepository**
- **refactor(service): rename GradeSimulatorSyncManager to SyncManager**
- **refactor(repo): migrate SyncQueueRepository to grade_sync**
- **refactor(ui): update imports in proxies and sync_metrics widget**
- **chore(cleanup): remove old sync files from grade_simulator**

---

Con esta guía, cada archivo y cambio de clase, import y DI está documentado con ejemplos de diffs, rutas exactas, y commits para facilitar la revisión y el seguimiento en Git. ¡A por ello! 🎯
