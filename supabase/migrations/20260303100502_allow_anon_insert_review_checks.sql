-- ============================================
-- review_checks テーブルに匿名ユーザー用のINSERTポリシーを追加
-- ============================================
-- アンケート送信は公開機能のため、ログインしていないユーザーも送信可能にする
-- ただし、セキュリティを考慮してINSERTのみ許可（SELECT/UPDATE/DELETEは不可）
-- ============================================

-- 匿名ユーザー（anon）にreview_checksへのINSERT権限を付与
CREATE POLICY "review_checks_insert_anon" ON review_checks
  FOR INSERT TO anon
  WITH CHECK (
    -- facility_idが実際に存在する施設のIDであることを確認
    EXISTS (
      SELECT 1 FROM facilities
      WHERE facilities.id = review_checks.facility_id
    )
  );

-- コメント追加
COMMENT ON POLICY "review_checks_insert_anon" ON review_checks IS '匿名ユーザーがアンケート送信できるようにするポリシー（存在する施設のみ）';
