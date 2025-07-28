-- schema_extended_with_triggers.sql

PRAGMA foreign_keys = ON;
PRAGMA user_version  = 2;  -- coincide con tu _dbVersion en Dart

BEGIN TRANSACTION;

-- ===================================================================
-- 1) Tabla principal JSON‑hybrid para simulación de notas
-- ===================================================================
CREATE TABLE IF NOT EXISTS course_grade_simulator (
  course_key                TEXT    PRIMARY KEY,                   -- studentCode_courseCode
  categories_json           TEXT,                                 -- Lista de GradeCategory serializada
  grades_json               TEXT,                                 -- Map<categoryId, List<Grade>> serializado
  metadata_json             TEXT,                                 -- Metadatos del curso serializado
  last_modified_categories  INTEGER,                              -- Timestamp última modificación categorías
  last_modified_grades      INTEGER,                              -- Timestamp última modificación notas
  last_modified_metadata    INTEGER,                              -- Timestamp última modificación metadata
  created_at                INTEGER NOT NULL 
                               DEFAULT (strftime('%s','now')*1000)
);

-- ===================================================================
-- 2) Cola de sincronización para operaciones granulares
-- ===================================================================
CREATE TABLE IF NOT EXISTS sync_queue (
  id             INTEGER PRIMARY KEY AUTOINCREMENT,
  operation_type TEXT    NOT NULL
                   CHECK(operation_type IN (
                     'create',
                     'update_categories_field',
                     'update_grades_field',
                     'delete'
                   )),
  entity_type    TEXT    NOT NULL DEFAULT 'course_grade_simulator',
  entity_key     TEXT    NOT NULL,
  FOREIGN KEY(entity_key)
    REFERENCES course_grade_simulator(course_key)
    ON DELETE CASCADE,
  field_name     TEXT,                                       -- categories, grades, metadata
  operation_data TEXT    NOT NULL,                           -- JSON con detalles del cambio
  timestamp      INTEGER NOT NULL 
                   DEFAULT (strftime('%s','now')*1000),
  retry_count    INTEGER NOT NULL DEFAULT 0 
                   CHECK(retry_count >= 0),
  status         TEXT    NOT NULL DEFAULT 'pending'
                   CHECK(status IN (
                     'pending',
                     'processing',
                     'synced',
                     'failed'
                   ))
);

-- ===================================================================
-- 3) Índices para rendimiento
-- ===================================================================
CREATE INDEX IF NOT EXISTS idx_course_mod_categories
  ON course_grade_simulator(last_modified_categories);

CREATE INDEX IF NOT EXISTS idx_course_mod_grades
  ON course_grade_simulator(last_modified_grades);

CREATE INDEX IF NOT EXISTS idx_course_mod_metadata
  ON course_grade_simulator(last_modified_metadata);

CREATE INDEX IF NOT EXISTS idx_sync_status_field
  ON sync_queue(status, field_name, timestamp);

CREATE INDEX IF NOT EXISTS idx_sync_retry
  ON sync_queue(retry_count, timestamp);

-- ===================================================================
-- 4) Triggers para actualizar automáticamente los timestamps
-- ===================================================================
-- Cuando cambian categories_json ➔ actualizar last_modified_categories
CREATE TRIGGER IF NOT EXISTS trg_update_last_modified_categories
AFTER UPDATE OF categories_json ON course_grade_simulator
BEGIN
  UPDATE course_grade_simulator
    SET last_modified_categories = (strftime('%s','now')*1000)
  WHERE course_key = NEW.course_key;
END;

-- Cuando cambian grades_json ➔ actualizar last_modified_grades
CREATE TRIGGER IF NOT EXISTS trg_update_last_modified_grades
AFTER UPDATE OF grades_json ON course_grade_simulator
BEGIN
  UPDATE course_grade_simulator
    SET last_modified_grades = (strftime('%s','now')*1000)
  WHERE course_key = NEW.course_key;
END;

-- Cuando cambian metadata_json ➔ actualizar last_modified_metadata
CREATE TRIGGER IF NOT EXISTS trg_update_last_modified_metadata
AFTER UPDATE OF metadata_json ON course_grade_simulator
BEGIN
  UPDATE course_grade_simulator
    SET last_modified_metadata = (strftime('%s','now')*1000)
  WHERE course_key = NEW.course_key;
END;

-- ===================================================================
-- 5) (Opcional) Triggers para encolar automáticamente cambios
--    *Si* quisieras que la base lance la operación en sync_queue
--    en lugar de hacerlo desde Dart, podrías añadir algo así:
-- ===================================================================
/*
CREATE TRIGGER trg_enqueue_categories_change
AFTER UPDATE OF categories_json ON course_grade_simulator
BEGIN
  INSERT INTO sync_queue (
    operation_type,
    entity_key,
    field_name,
    operation_data
  ) VALUES (
    'update_categories_field',
    NEW.course_key,
    'categories',
    json_object('categories_json', NEW.categories_json)
  );
END;
*/

COMMIT;
