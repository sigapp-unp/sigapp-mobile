-- ============================================================================
-- SUPABASE DATABASE SETUP
-- ============================================================================

-- ----------------------------------------------------------------------------
-- EXTENSIONS
-- ----------------------------------------------------------------------------

-- Provides uuid_generate_v4() function for auto-generated unique IDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ----------------------------------------------------------------------------
-- FUNCTIONS
-- ----------------------------------------------------------------------------

-- Auto-update updated_at field on any UPDATE
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------
-- TABLES
-- ----------------------------------------------------------------------------

-- 1. Create table
-- 2. Faster lookups by business key
-- 3. Enable RLS
-- 4. Add trigger for updated_at field

-- Course tracking table
CREATE TABLE gt_course_tracking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_code TEXT NOT NULL,
  course_code TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (course_code, student_code, id)
);

CREATE TRIGGER update_gt_course_tracking_timestamp
BEFORE UPDATE ON gt_course_tracking
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

CREATE UNIQUE INDEX idx_gt_course_tracking_student_course ON gt_course_tracking(student_code, course_code);

ALTER TABLE gt_course_tracking ENABLE ROW LEVEL SECURITY;

-- Grade categories table
CREATE TABLE gt_grade_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_tracking_id UUID NOT NULL REFERENCES gt_course_tracking(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  weight REAL NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_gt_grade_categories_course_id ON gt_grade_categories(course_tracking_id);

ALTER TABLE gt_grade_categories ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER update_gt_grade_categories_timestamp
BEFORE UPDATE ON gt_grade_categories
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Grades table
CREATE TABLE gt_grades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID NOT NULL REFERENCES gt_grade_categories(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  score REAL NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_gt_grades_category_id ON gt_grades(category_id);

ALTER TABLE gt_grades ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER update_gt_grades_timestamp
BEFORE UPDATE ON gt_grades
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- ----------------------------------------------------------------------------
-- 2025-06-18: PASSWORD MANAGEMENT VIA SERVICE ROLE KEY
-- ----------------------------------------------------------------------------

-- Expose auth.users for enabling password updates
CREATE OR REPLACE VIEW public.users AS
SELECT * FROM auth.users;

-- ----------------------------------------------------------------------------
-- 2025-07-19: USER_PREFERENCES TABLE
-- ----------------------------------------------------------------------------

CREATE TABLE user_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_code TEXT NOT NULL UNIQUE,
  preferences JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_preferences_student_code ON user_preferences(student_code);

ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER update_user_preferences_timestamp
BEFORE UPDATE ON user_preferences
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- ----------------------------------------------------------------------------
-- 2025-07-23: GRADE SIMULATOR JSONB HYBRID APPROACH (replacement of gt_course_*)
-- ----------------------------------------------------------------------------

-- Replaces the complex 3-table setup (gt_course_tracking + gt_grade_categories + gt_grades)
-- with a single document-based table using JSONB for maximum performance.
--
-- WHY HYBRID (2 JSON fields vs 1 monolithic)?
-- - categories vs grades rarely conflict (different UI sections)
-- - granular overwrites reduce data loss in multi-device scenarios
--
-- PERFORMANCE GAINS:
-- - Before: 12+ DB operations for createWithDefaults
-- - After:  2 operations max (categories + grades)
-- - Offline: Everything in memory, single sync per field type

CREATE TABLE course_grade_simulator (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_code TEXT NOT NULL,
  course_code TEXT NOT NULL,
  
  -- Categories: [{"id": "uuid", "name": "Exámenes", "weight": 0.6}, ...]
  categories JSONB NOT NULL DEFAULT '[]',
  
  -- Grades: [{"id": "uuid", "categoryId": "uuid", "name": "Parcial 1", "score": 85, "enabled": true}, ...]
  grades JSONB NOT NULL DEFAULT '[]',
  
  -- -- Metadata: {"passScore": 60, "semester": "2025-1", "notifications": true, ...}
  -- metadata JSONB NOT NULL DEFAULT '{}',
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE (student_code, course_code)
);

-- Index for fast lookups by student+course
CREATE UNIQUE INDEX idx_course_simulator_student_course 
ON course_grade_simulator(student_code, course_code);

-- GIN index for fast JSONB queries (optional, if needed)
CREATE INDEX idx_course_simulator_categories_gin ON course_grade_simulator USING GIN (categories);
CREATE INDEX idx_course_simulator_grades_gin ON course_grade_simulator USING GIN (grades);

ALTER TABLE course_grade_simulator ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER update_course_simulator_timestamp
BEFORE UPDATE ON course_grade_simulator
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- ----------------------------------------------------------------------------
-- EXAMPLE DATA STRUCTURES
-- ----------------------------------------------------------------------------

-- Example 1: Complete course setup
-- INSERT INTO course_grade_simulator (student_code, course_code, categories, grades) VALUES (
--   '2021001234',
--   'MAT101',
--   '[
--     {"id": "cat1", "name": "Exámenes", "weight": 0.6},
--     {"id": "cat2", "name": "Tareas", "weight": 0.3},
--     {"id": "cat3", "name": "Participación", "weight": 0.1}
--   ]',
--   '[
--     {"id": "g1", "categoryId": "cat1", "name": "Parcial 1", "score": 85, "enabled": true},
--     {"id": "g2", "categoryId": "cat1", "name": "Parcial 2", "score": 92, "enabled": true},
--     {"id": "g3", "categoryId": "cat2", "name": "Tarea 1", "score": 78, "enabled": true}
--   ]'
-- );

-- Example 2: Update only grades (preserves categories)
-- UPDATE course_grade_simulator 
-- SET grades = '[
--   {"id": "g1", "categoryId": "cat1", "name": "Parcial 1", "score": 90, "enabled": true},
--   {"id": "g2", "categoryId": "cat1", "name": "Parcial 2", "score": 92, "enabled": true},
--   {"id": "g3", "categoryId": "cat2", "name": "Tarea 1", "score": 78, "enabled": true},
--   {"id": "g4", "categoryId": "cat2", "name": "Tarea 2", "score": 88, "enabled": true}
-- ]'
-- WHERE student_code = '2021001234' AND course_code = 'MAT101';

-- Example 3: Bulk category restructure (preserves grades)
-- UPDATE course_grade_simulator 
-- SET categories = '[
--   {"id": "cat1", "name": "Evaluaciones", "weight": 0.7},
--   {"id": "cat4", "name": "Proyectos", "weight": 0.3}
-- ]'
-- WHERE student_code = '2021001234' AND course_code = 'MAT101';

-- Example 4: Query patterns
-- Get all data: SELECT * FROM course_grade_simulator WHERE student_code = ? AND course_code = ?
-- Get categories only: SELECT categories FROM course_grade_simulator WHERE student_code = ? AND course_code = ?
-- Search in grades: SELECT * FROM course_grade_simulator WHERE grades @> '[{"name": "Parcial"}]'

-- ----------------------------------------------------------------------------
-- MIGRATION STRATEGY (when ready)
-- ----------------------------------------------------------------------------

-- Step 1: Migrate existing data from 3-table structure
-- INSERT INTO course_grade_simulator (student_code, course_code, categories, grades)
-- SELECT 
--   ct.student_code,
--   ct.course_code,
--   COALESCE(
--     json_agg(
--       json_build_object('id', gc.id, 'name', gc.name, 'weight', gc.weight)
--       ORDER BY gc.created_at
--     ) FILTER (WHERE gc.id IS NOT NULL), 
--     '[]'::json
--   ) as categories,
--   COALESCE(
--     json_agg(
--       json_build_object('id', g.id, 'categoryId', g.category_id, 'name', g.name, 'score', g.score, 'enabled', g.enabled)
--       ORDER BY g.created_at
--     ) FILTER (WHERE g.id IS NOT NULL),
--     '[]'::json
--   ) as grades
-- FROM gt_course_tracking ct
-- LEFT JOIN gt_grade_categories gc ON ct.id = gc.course_tracking_id
-- LEFT JOIN gt_grades g ON gc.id = g.category_id
-- GROUP BY ct.student_code, ct.course_code, ct.id;

-- Step 2: Drop old tables (after testing)
-- DROP TABLE IF EXISTS gt_grades;
-- DROP TABLE IF EXISTS gt_grade_categories;
-- DROP TABLE IF EXISTS gt_course_tracking;
