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
