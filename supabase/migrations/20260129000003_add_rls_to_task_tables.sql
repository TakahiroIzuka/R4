-- ============================================
-- バッチタスクテーブルにRLSを追加
-- ============================================

-- ============================================
-- 1. review_check_tasks テーブル
-- ============================================
ALTER TABLE review_check_tasks ENABLE ROW LEVEL SECURITY;

-- admin: 全操作可能
CREATE POLICY "review_check_tasks_all_admin" ON review_check_tasks
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

-- 通常ユーザー: 自分のcompany_idに紐づく施設のreview_checksに関連するタスクのみ
CREATE POLICY "review_check_tasks_select_user" ON review_check_tasks
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      JOIN review_checks ON review_checks.facility_id = facilities.id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND review_checks.id = review_check_tasks.review_check_id
    )
  );

CREATE POLICY "review_check_tasks_insert_user" ON review_check_tasks
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      JOIN review_checks ON review_checks.facility_id = facilities.id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND review_checks.id = review_check_tasks.review_check_id
    )
  );

CREATE POLICY "review_check_tasks_update_user" ON review_check_tasks
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      JOIN review_checks ON review_checks.facility_id = facilities.id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND review_checks.id = review_check_tasks.review_check_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      JOIN review_checks ON review_checks.facility_id = facilities.id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND review_checks.id = review_check_tasks.review_check_id
    )
  );

CREATE POLICY "review_check_tasks_delete_user" ON review_check_tasks
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      JOIN review_checks ON review_checks.facility_id = facilities.id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND review_checks.id = review_check_tasks.review_check_id
    )
  );

-- ============================================
-- 2. fetch_review_detail_tasks テーブル
-- ============================================
ALTER TABLE fetch_review_detail_tasks ENABLE ROW LEVEL SECURITY;

-- admin: 全操作可能
CREATE POLICY "fetch_review_detail_tasks_all_admin" ON fetch_review_detail_tasks
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

-- 通常ユーザー: 自分のcompany_idに紐づく施設のタスクのみ
CREATE POLICY "fetch_review_detail_tasks_select_user" ON fetch_review_detail_tasks
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = fetch_review_detail_tasks.facility_id
    )
  );

CREATE POLICY "fetch_review_detail_tasks_insert_user" ON fetch_review_detail_tasks
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = fetch_review_detail_tasks.facility_id
    )
  );

CREATE POLICY "fetch_review_detail_tasks_update_user" ON fetch_review_detail_tasks
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = fetch_review_detail_tasks.facility_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = fetch_review_detail_tasks.facility_id
    )
  );

CREATE POLICY "fetch_review_detail_tasks_delete_user" ON fetch_review_detail_tasks
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = fetch_review_detail_tasks.facility_id
    )
  );
