-- ============================================
-- 通常ユーザーのアクセス制限を強化するRLSポリシー
-- ============================================
-- admin: 全テーブルにフルアクセス
-- user (通常ユーザー): 自分のcompany_idに紐づくデータのみ
-- anon/public: 公開サイト用の読み取りのみ
-- ============================================

-- ============================================
-- 1. facilities テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow public read access on facilities" ON facilities;
DROP POLICY IF EXISTS "Allow authenticated users to insert facilities" ON facilities;
DROP POLICY IF EXISTS "Allow authenticated users to update facilities" ON facilities;
DROP POLICY IF EXISTS "Allow authenticated users to delete facilities" ON facilities;

-- 公開サイト用: 誰でも読み取り可能
CREATE POLICY "facilities_select_public" ON facilities
  FOR SELECT TO public
  USING (true);

-- admin: 全操作可能
CREATE POLICY "facilities_all_admin" ON facilities
  FOR ALL TO authenticated
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

-- 通常ユーザー: 自分のcompany_idに紐づく施設のみ
CREATE POLICY "facilities_select_user" ON facilities
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND users.company_id = facilities.company_id
    )
  );

CREATE POLICY "facilities_insert_user" ON facilities
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND users.company_id = facilities.company_id
    )
  );

CREATE POLICY "facilities_update_user" ON facilities
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND users.company_id = facilities.company_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND users.company_id = facilities.company_id
    )
  );

CREATE POLICY "facilities_delete_user" ON facilities
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND users.company_id = facilities.company_id
    )
  );

-- ============================================
-- 2. review_checks テーブル
-- ============================================
ALTER TABLE review_checks ENABLE ROW LEVEL SECURITY;

-- admin: 全操作可能
CREATE POLICY "review_checks_all_admin" ON review_checks
  FOR ALL TO authenticated
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

-- 通常ユーザー: 自分のcompany_idに紐づく施設のreview_checksのみ
CREATE POLICY "review_checks_select_user" ON review_checks
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = review_checks.facility_id
    )
  );

CREATE POLICY "review_checks_insert_user" ON review_checks
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = review_checks.facility_id
    )
  );

CREATE POLICY "review_checks_update_user" ON review_checks
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = review_checks.facility_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = review_checks.facility_id
    )
  );

CREATE POLICY "review_checks_delete_user" ON review_checks
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = review_checks.facility_id
    )
  );

-- ============================================
-- 3. facility_details テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow public read access on facility_details" ON facility_details;
DROP POLICY IF EXISTS "Allow public read access" ON facility_details;
DROP POLICY IF EXISTS "Allow authenticated users to insert facility_details" ON facility_details;
DROP POLICY IF EXISTS "Allow authenticated users to update facility_details" ON facility_details;
DROP POLICY IF EXISTS "Allow authenticated users to delete facility_details" ON facility_details;

-- 公開サイト用: 誰でも読み取り可能
CREATE POLICY "facility_details_select_public" ON facility_details
  FOR SELECT TO public
  USING (true);

-- admin: 全操作可能
CREATE POLICY "facility_details_all_admin" ON facility_details
  FOR ALL TO authenticated
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

-- 通常ユーザー: 自分のcompany_idに紐づく施設のもののみ
CREATE POLICY "facility_details_select_user" ON facility_details
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_details.facility_id
    )
  );

CREATE POLICY "facility_details_insert_user" ON facility_details
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_details.facility_id
    )
  );

CREATE POLICY "facility_details_update_user" ON facility_details
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_details.facility_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_details.facility_id
    )
  );

CREATE POLICY "facility_details_delete_user" ON facility_details
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_details.facility_id
    )
  );

-- ============================================
-- 4. facility_images テーブル
-- ============================================
DROP POLICY IF EXISTS "Anyone can view facility images" ON facility_images;
DROP POLICY IF EXISTS "Anyone can insert facility images" ON facility_images;
DROP POLICY IF EXISTS "Anyone can update facility images" ON facility_images;
DROP POLICY IF EXISTS "Anyone can delete facility images" ON facility_images;

-- 公開サイト用: 誰でも読み取り可能
CREATE POLICY "facility_images_select_public" ON facility_images
  FOR SELECT TO public
  USING (true);

-- admin: 全操作可能
CREATE POLICY "facility_images_all_admin" ON facility_images
  FOR ALL TO authenticated
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

-- 通常ユーザー: 自分のcompany_idに紐づく施設のもののみ
CREATE POLICY "facility_images_select_user" ON facility_images
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_images.facility_id
    )
  );

CREATE POLICY "facility_images_insert_user" ON facility_images
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_images.facility_id
    )
  );

CREATE POLICY "facility_images_update_user" ON facility_images
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_images.facility_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_images.facility_id
    )
  );

CREATE POLICY "facility_images_delete_user" ON facility_images
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_images.facility_id
    )
  );

-- ============================================
-- 5. companies テーブル
-- ============================================
DROP POLICY IF EXISTS "Allow public read access" ON companies;
DROP POLICY IF EXISTS "Allow authenticated users to insert companies" ON companies;
DROP POLICY IF EXISTS "Allow authenticated users to update companies" ON companies;
DROP POLICY IF EXISTS "Allow authenticated users to delete companies" ON companies;

-- 公開サイト用: 誰でも読み取り可能（施設に紐づく企業名表示用）
CREATE POLICY "companies_select_public" ON companies
  FOR SELECT TO public
  USING (true);

-- admin: 全操作可能
CREATE POLICY "companies_all_admin" ON companies
  FOR ALL TO authenticated
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

-- 通常ユーザー: 自分のcompanyのみ読み取り可能
CREATE POLICY "companies_select_user" ON companies
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND users.company_id = companies.id
    )
  );

-- ============================================
-- 6. users テーブル
-- ============================================
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON users;

-- admin: 全操作可能
CREATE POLICY "users_all_admin" ON users
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.auth_user_id = auth.uid()
      AND u.type = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.auth_user_id = auth.uid()
      AND u.type = 'admin'
    )
  );

-- 通常ユーザー: 自分自身のレコードのみ読み取り可能
CREATE POLICY "users_select_self" ON users
  FOR SELECT TO authenticated
  USING (auth_user_id = auth.uid());
