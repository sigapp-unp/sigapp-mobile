-- ============================================================================
-- SUPABASE DATABASE CLEANUP
-- ============================================================================
-- Destroys all data tables, policies, and triggers
-- Keeps extensions and functions intact for reuse

-- ----------------------------------------------------------------------------
-- RLS POLICIES
-- ----------------------------------------------------------------------------

-- Remove RLS policies (orden no importa para policies)
DROP POLICY IF EXISTS "Users can view their own preferences" ON user_preferences;
DROP POLICY IF EXISTS "Users can insert their own preferences" ON user_preferences;
DROP POLICY IF EXISTS "Users can update their own preferences" ON user_preferences;
DROP POLICY IF EXISTS "Users can delete their own preferences" ON user_preferences;

DROP POLICY IF EXISTS "Users can view their own grades" ON gt_grades;
DROP POLICY IF EXISTS "Users can insert their own grades" ON gt_grades;
DROP POLICY IF EXISTS "Users can update their own grades" ON gt_grades;
DROP POLICY IF EXISTS "Users can delete their own grades" ON gt_grades;

DROP POLICY IF EXISTS "Users can view their own grade categories" ON gt_grade_categories;
DROP POLICY IF EXISTS "Users can insert their own grade categories" ON gt_grade_categories;
DROP POLICY IF EXISTS "Users can update their own grade categories" ON gt_grade_categories;
DROP POLICY IF EXISTS "Users can delete their own grade categories" ON gt_grade_categories;

DROP POLICY IF EXISTS "Users can view their own courses" ON gt_course_tracking;
DROP POLICY IF EXISTS "Users can insert their own courses" ON gt_course_tracking;
DROP POLICY IF EXISTS "Users can update their own courses" ON gt_course_tracking;
DROP POLICY IF EXISTS "Users can delete their own courses" ON gt_course_tracking;

-- ----------------------------------------------------------------------------
-- TRIGGERS
-- ----------------------------------------------------------------------------

-- Remove triggers before dropping tables to avoid dependency issues
DROP TRIGGER IF EXISTS update_user_preferences_timestamp ON user_preferences;
DROP TRIGGER IF EXISTS update_gt_grades_timestamp ON gt_grades;
DROP TRIGGER IF EXISTS update_gt_grade_categories_timestamp ON gt_grade_categories;
DROP TRIGGER IF EXISTS update_gt_course_tracking_timestamp ON gt_course_tracking;

-- ----------------------------------------------------------------------------
-- VIEWS
-- ----------------------------------------------------------------------------

-- Remove views created in setup
DROP VIEW IF EXISTS public.users;

-- ----------------------------------------------------------------------------
-- TABLES
-- ----------------------------------------------------------------------------

-- Remove tables in reverse order of creation to respect foreign key constraints
DROP TABLE IF EXISTS gt_grades;
DROP TABLE IF EXISTS gt_grade_categories;
DROP TABLE IF EXISTS gt_course_tracking;
DROP TABLE IF EXISTS user_preferences;

-- ----------------------------------------------------------------------------
-- NOTES
-- ----------------------------------------------------------------------------

-- Extensions (uuid-ossp) and Functions (update_timestamp) are kept intact
-- They can be reused when running db_setup.sql again
-- Indexes are automatically dropped with their parent tables