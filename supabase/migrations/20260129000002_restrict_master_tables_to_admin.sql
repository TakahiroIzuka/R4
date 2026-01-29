-- ============================================
-- マスタテーブルの書き込み権限をadminのみに制限
-- ============================================
-- SELECT: 公開サイト用に維持
-- INSERT/UPDATE/DELETE: adminのみ
-- ============================================

-- ============================================
-- 1. services テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow authenticated users to insert services" ON services;
DROP POLICY IF EXISTS "Allow authenticated users to update services" ON services;
DROP POLICY IF EXISTS "Allow authenticated users to delete services" ON services;

CREATE POLICY "services_insert_admin" ON services
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "services_update_admin" ON services
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "services_delete_admin" ON services
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

-- ============================================
-- 2. genres テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow authenticated users to insert genres" ON genres;
DROP POLICY IF EXISTS "Allow authenticated users to update genres" ON genres;
DROP POLICY IF EXISTS "Allow authenticated users to delete genres" ON genres;

CREATE POLICY "genres_insert_admin" ON genres
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "genres_update_admin" ON genres
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "genres_delete_admin" ON genres
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

-- ============================================
-- 3. prefectures テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow authenticated users to insert prefectures" ON prefectures;
DROP POLICY IF EXISTS "Allow authenticated users to update prefectures" ON prefectures;
DROP POLICY IF EXISTS "Allow authenticated users to delete prefectures" ON prefectures;

CREATE POLICY "prefectures_insert_admin" ON prefectures
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "prefectures_update_admin" ON prefectures
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "prefectures_delete_admin" ON prefectures
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

-- ============================================
-- 4. areas テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow authenticated users to insert areas" ON areas;
DROP POLICY IF EXISTS "Allow authenticated users to update areas" ON areas;
DROP POLICY IF EXISTS "Allow authenticated users to delete areas" ON areas;

CREATE POLICY "areas_insert_admin" ON areas
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "areas_update_admin" ON areas
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

CREATE POLICY "areas_delete_admin" ON areas
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );
