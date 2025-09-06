# User Preferences Optimization Plan - SigApp

## 1. Problema Identificado

**UserPreferencesRepositoryImpl NO está optimizado**:

- **Patrón Repository chatty**: Cada `setPreference()` ejecuta GET + PATCH/POST → 2-3 DB calls por cambio UI
- **Sin cache local**: Cada `getPreference()` va directo a Supabase → 100-500ms latencia
- **Sin debouncing**: Toggle UI preference dispara escritura inmediata → saturación innecesaria
- **Sin sync queue**: No funciona offline → usuario pierde cambios sin conexión
- **Sin optimistic updates**: UI bloquea esperando respuesta remota → mala UX

**Impacto actual**:

- **UI laggy**: 200-800ms por toggle de preferencia
- **Carga DB innecesaria**: Usuario cambia 5 settings = 10-15 requests HTTP
- **Offline fail**: App no funciona sin conexión para preferencias críticas
- **Escalabilidad**: Patrón no sostenible con más preferencias

## 2. Contexto de Negocio

### **Tipos de Preferencias Identificadas**

```dart
// Existing preference keys
class PreferenceKeys {
  static const String scheduleHiddenEvents = 'schedule_hidden_events';           // List<String>
  static const String courseChain = 'course_chain';                             // Object container
  static const String courseChainHighlightCriticalPath = 'course_chain.highlight_critical_path';  // bool
  static const String courseChainViewMode = 'course_chain.view_mode';           // String enum
}
```

### **Use Cases Existentes** (mantener compatibilidad)

- `GetAllHiddenCoursesPreferencesUseCase` → Leer lista eventos ocultos
- `SetCourseVisibilityPreferencesUseCase` → Toggle visibilidad curso individual
- `GetCourseViewModeUseCase` → Obtener modo vista cadena prerrequisitos
- `SetCourseViewModePreferencesUseCase` → Cambiar modo vista (list/tree/graph)
- `GetHighlightCriticalPathUseCase` → Estado highlight ruta crítica
- `SetHighlightCriticalPathPreferencesUseCase` → Toggle highlight ruta crítica

### **Patrones de Uso Identificados**

- **Lectura frecuente**: Cada render UI lee múltiples preferencias
- **Escritura granular**: Usuario cambia 1 setting por vez (toggles, dropdowns)
- **Sincronización multi-dispositivo**: Preferencias deben persistir entre sesiones
- **Offline tolerance**: Usuario debe poder usar app básica sin conexión
- **Consistencia eventual**: OK si sync toma 10-30s, no es crítico tiempo real

## 3. Arquitectura Objetivo: User Preferences Optimization

### **Estrategia: Aplicar patrón optimizado del Grade Simulator**

| Componente              | Actual (Direct HTTP)           | Objetivo (Cache + Sync)          |
| ----------------------- | ------------------------------ | -------------------------------- |
| **Repository Pattern**  | Direct HTTP GET/PATCH per call | Cache-first + optimistic updates |
| **Local Cache**         | ❌ No existe                   | SQLite Drift local-first         |
| **Sync Strategy**       | Inmediato (blocking UI)        | Batch + debouncing 8s timer      |
| **Offline Support**     | ❌ Falla completamente         | 100% funcional offline           |
| **Conflict Resolution** | ❌ No implementado             | Last-Write-Wins por preference   |
| **UI Latency**          | 200-800ms (HTTP roundtrip)     | <5ms (SQLite cache)              |

### **Schema Database** ✅

**Tabla remota existente**: `user_preferences`

- `student_code` (PK)
- `preferences` JSONB
- **✅ NO requiere cambios** - Schema ya optimizado para single-write

**Nueva tabla local**: `local_user_preferences` (Drift SQLite)

- `student_code` (PK)
- `preferences` TEXT (JSON serializado)
- `last_synced` DATETIME
- `is_dirty` BOOLEAN

**Nueva tabla sync queue**: `user_preferences_sync_queue` (Drift SQLite)

- `id` INTEGER PRIMARY KEY
- `student_code` TEXT
- `operation_type` TEXT ('set_preference', 'bulk_update')
- `operation_data` TEXT (JSON)
- `timestamp` DATETIME
- `status` TEXT ('pending', 'synced', 'failed')
- `retry_count` INTEGER

## 4. Arquitectura de Archivos

### **Fase 1: Core Infrastructure**

#### **A. Database Tables**

```
lib/shared/infrastructure/database/local_user_preferences.dart
lib/shared/infrastructure/database/user_preferences_sync_queue.dart
```

- **Responsabilidad**: Definir esquemas Drift para cache local + sync queue
- **Patrón**: Misma estructura que `local_course_grade_simulator.dart` + `sync_queue.dart`

#### **B. Local Repository (Cache-First)**

```
lib/shared/infrastructure/repositories/local/local_user_preferences_repository.dart
```

- **Responsabilidad**: CRUD instantáneo en SQLite, source of truth local
- **API**: `getUserPreferences()`, `setPreference()`, `markDirty()`, `markSynced()`
- **Patrón**: Similar a `LocalGradeSimulatorRepository`

#### **C. Remote Repository (Single-Write JSONB)**

```
lib/shared/infrastructure/repositories/remote/remote_user_preferences_repository.dart
lib/shared/infrastructure/repositories/remote/user_preferences_single_write_client.dart
```

- **Responsabilidad**: HTTP client especializado, batch JSONB operations
- **API**: `patchPreference(key, value)`, `patchPreferences(Map<String, dynamic>)`
- **Patrón**: Similar a `SingleWriteClient` con granularidad por preference key

#### **D. Sync Infrastructure**

```
lib/shared/infrastructure/services/user_preferences_sync_manager.dart
lib/shared/infrastructure/repositories/user_preferences_sync_queue_repository.dart
```

- **Responsabilidad**: Batching 8s timer + retry logic + offline handling
- **API**: `enqueueSyncOperation()`, `processPendingOperations()`, `checkConnectivityRecovery()`
- **Patrón**: Copia exacta de `GradeSimulatorSyncManager` adaptado para preferences

### **Fase 2: Proxy Integration**

#### **E. Proxy Repository (Orchestration)**

```
lib/shared/infrastructure/repositories/proxy/user_preferences_repository_proxy.dart
```

- **Responsabilidad**: Cache-first reads + optimistic updates + sync queue integration
- **API**: Mantiene interface `UserPreferencesRepository` existente
- **Patrón**: `performOptimisticUpdate()` pattern del grade simulator

#### **F. Implementation Replacement**

```
lib/courses/infrastructure/repositories/user_preferences_repository_impl.dart  [REEMPLAZAR]
```

- **ANTES**: Direct HTTP calls con ApiGatewayClient
- **DESPUÉS**: Delegation completa al UserPreferencesRepositoryProxy
- **Compatibilidad**: 100% - Use cases no cambian

### **Fase 3: Lifecycle Integration**

#### **G. App Lifecycle Integration**

```
lib/shared/infrastructure/services/user_preferences_resume_sync.dart
```

- **Responsabilidad**: Auto-sync al reabrir app, recovery tras crash
- **API**: `@PostConstruct()` initialization + `WidgetsBindingObserver`
- **Patrón**: Copia de `GradeSimulatorResumeSync`

## 5. Flujo de Datos Optimizado

### **Read Operation** (getPreference)

```text
UseCase → UserPreferencesRepositoryImpl → UserPreferencesRepositoryProxy → LocalUserPreferencesRepository → SQLite (5ms)
                                                                         ↓ (fallback si no cache)
                                                                         RemoteUserPreferencesRepository → Supabase
```

### **Write Operation** (setPreference)

```text
UseCase → UserPreferencesRepositoryImpl → UserPreferencesRepositoryProxy
                                        ↓
                                        performOptimisticUpdate():
                                        ├── LocalUserPreferencesRepository.setPreference() (instant SQLite)
                                        ├── UI return success (5ms perceived latency)
                                        └── UserPreferencesSyncManager.enqueueSyncOperation()
                                            ├── Add to _pendingOperations + sync_queue table
                                            ├── Restart 8s debouncing timer
                                            └── [8s later] → Batch process → RemoteRepository → Supabase
```

### **Batch Sync Process** (similar a grade simulator)

```text
SyncTimer (8s) → UserPreferencesSyncManager._processPendingOperations()
                ├── Group operations by student_code
                ├── Merge multiple setPreference() calls → bulk update
                ├── UserPreferencesSingleWriteClient.patchPreferences()
                ├── PATCH /rest/v1/user_preferences SET preferences = {merged_json}
                └── SyncQueueRepository.markOperationsAsSynced()
```

## 6. Escenarios Críticos: User Preferences

### **Escenario P.1**: Usuario cambia 5 settings rápidamente

**Situación**: Usuario abre settings, cambia view mode + highlight + oculta 3 cursos en 10 segundos.

**Flujo optimizado**:

1. **Cada toggle** → `setPreference()` → SQLite instant (5ms UI) + queue operation
2. **8s timer** → Batch 5 operations → 1 PATCH con preferences merged
3. **Usuario ve cambios** → Instantáneos en UI, sync transparente en background

**Resultado esperado**: `5 × (GET + PATCH) = 10 HTTP calls → 1 batch PATCH` = 90% reducción

### **Escenario P.2**: App crash durante cambio de preferencias

**Situación**: Usuario cambia setting, app se cierra antes de sync.

**Recovery flow**:

1. **App restart** → `UserPreferencesResumeSync.initialize()`
2. **Auto-recovery** → `checkConnectivityRecovery()` procesa sync_queue pendiente
3. **Sync transparente** → Preference change se sincroniza automáticamente
4. **Estado consistente** → Multi-device sync recovered

**Resultado esperado**: Cero pérdida de datos, recovery automático

### **Escenario P.3**: Usuario usa app sin conexión

**Situación**: Usuario cambia múltiples settings sin internet, luego se conecta.

**Offline behavior**:

1. **Settings changes** → SQLite local funciona normal (UI responsiva)
2. **Sync queue acumula** → Operations persist como 'pending'
3. **Reconnect detection** → Auto-recovery batch procesa cola completa
4. **Multi-device sync** → Preferences se propagan a otros dispositivos

**Resultado esperado**: App 100% funcional offline, auto-sync al reconectar

### **Escenario P.4**: Conflictos entre dispositivos

**Situación**: Usuario cambia setting en móvil y tablet simultáneamente.

**Conflict resolution**:

1. **Granularidad por key** → `view_mode` vs `highlight_critical_path` coexisten sin conflicto
2. **Same key conflict** → Last-Write-Wins simple (timestamp más reciente gana)
3. **Cache refresh** → Dispositivo "perdedor" recibe update automático
4. **UI consistency** → Estado final consistente en ambos dispositivos

**Resultado esperado**: Conflictos minimizados, resolución automática transparente

## 7. Implementación Step-by-Step

### **Día 1: Core Infrastructure**

1. **Crear tablas Drift** → `local_user_preferences.dart` + `user_preferences_sync_queue.dart`
2. **LocalUserPreferencesRepository** → CRUD SQLite con JSON serialization
3. **UserPreferencesSyncQueueRepository** → ACID queue operations
4. **Testing básico** → Unit tests para local operations

### **Día 2: Remote + Sync**

1. **RemoteUserPreferencesRepository** → HTTP single-write client
2. **UserPreferencesSyncManager** → Batching + retry logic
3. **Integration testing** → Local + Remote + Sync flow
4. **Error handling** → Offline scenarios + recovery

### **Día 3: Proxy Integration**

1. **UserPreferencesRepositoryProxy** → Cache-first + optimistic updates
2. **Reemplazar implementation** → UserPreferencesRepositoryImpl delegation
3. **Use case testing** → Verificar compatibilidad 100% con existing use cases
4. **UI testing** → Verificar latencia <5ms en toggles

### **Día 4: Lifecycle + Validation**

1. **UserPreferencesResumeSync** → App lifecycle integration
2. **End-to-end testing** → Escenarios críticos P.1-P.4
3. **Performance benchmarking** → Before/after metrics
4. **Production readiness** → Logs, error handling, rollback plan

## 8. Métricas de Éxito Esperadas

| Operación                    | Antes (Direct HTTP)       | Después (Cache+Sync) | Mejora Esperada |
| ---------------------------- | ------------------------- | -------------------- | --------------- |
| `getPreference()` typical    | 100-500ms (HTTP)          | <5ms (SQLite cache)  | 95%+ faster     |
| `setPreference()` individual | 200-800ms (GET+PATCH)     | <5ms (optimistic)    | 98%+ faster     |
| Cambiar 5 settings rápido    | 5 × 2 = 10 HTTP calls     | 1 batch PATCH        | 90% menos calls |
| UI preference toggles        | Laggy 300-500ms           | Instantáneo <5ms     | 100% mejora UX  |
| Offline functionality        | ❌ Falla completamente    | ✅ Funciona completo | ∞ improvement   |
| App startup preferences      | HTTP fetch blocking       | Cache instant        | 90%+ faster     |
| Multi-device consistency     | ❌ No conflict resolution | ✅ LWW automático    | Feature gained  |

## 9. Archivos de Implementación

### **Database & Local**

- `lib/shared/infrastructure/database/local_user_preferences.dart` - Tabla Drift cache local
- `lib/shared/infrastructure/database/user_preferences_sync_queue.dart` - Queue operations
- `lib/shared/infrastructure/repositories/local/local_user_preferences_repository.dart` - SQLite CRUD

### **Remote & Sync**

- `lib/shared/infrastructure/repositories/remote/remote_user_preferences_repository.dart` - HTTP repository
- `lib/shared/infrastructure/repositories/remote/user_preferences_single_write_client.dart` - Batch client
- `lib/shared/infrastructure/services/user_preferences_sync_manager.dart` - Batching + retry
- `lib/shared/infrastructure/repositories/user_preferences_sync_queue_repository.dart` - Queue persistence

### **Proxy & Integration**

- `lib/shared/infrastructure/repositories/proxy/user_preferences_repository_proxy.dart` - Cache-first orchestration
- `lib/shared/infrastructure/services/user_preferences_resume_sync.dart` - Lifecycle integration

### **Existing (Modified)**

- `lib/courses/infrastructure/repositories/user_preferences_repository_impl.dart` - [REPLACE] Delegate to proxy
- `lib/core/infrastructure/database/local_database.dart` - [ADD] New tables registration

### **Configuration**

- `lib/core/injection/get_it.config.dart` - [UPDATE] Dependency injection new components

## 10. Risk Analysis & Mitigation

### **Riesgos Identificados**

| Riesgo                      | Probabilidad | Impacto | Mitigación                                           |
| --------------------------- | ------------ | ------- | ---------------------------------------------------- |
| Breaking existing use cases | Media        | Alto    | Extensive testing, API compatibility guarantee       |
| Performance regression      | Baja         | Medio   | Benchmarking before/after, rollback plan             |
| Data consistency issues     | Baja         | Alto    | ACID transactions, comprehensive conflict testing    |
| Increased complexity        | Alta         | Bajo    | Clear documentation, code reuse from grade simulator |

### **Rollback Plan**

1. **Feature flag** → Implement with toggle to revert to old implementation
2. **Gradual rollout** → Test with subset of users first
3. **Monitoring** → Track error rates, performance metrics
4. **Quick revert** → Single config change to disable optimization

### **Success Criteria**

- ✅ **API Compatibility**: All existing use cases work identically
- ✅ **Performance**: >90% latency reduction for preference operations
- ✅ **Offline**: App fully functional without internet for preferences
- ✅ **Reliability**: Zero data loss scenarios, automatic recovery
- ✅ **Scalability**: Architecture supports 10x more preference types

## Conclusión

La refactorización de `UserPreferencesRepository` aplicando la estrategia optimizada del grade simulator eliminará completamente el patrón Repository chatty, proporcionando una experiencia de usuario instantánea con funcionalidad offline completa y sincronización inteligente en background.

**Impacto esperado**: De una implementación problemática y no escalable a una arquitectura robusta, performante y lista para producción que maneja preferences de forma óptima en el contexto de Supabase Free Plan limitations.
