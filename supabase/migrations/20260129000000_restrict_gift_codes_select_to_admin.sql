-- gift_codesのSELECTポリシーをadminのみに制限
-- 既存のポリシーを削除して、admin限定のポリシーを作成

DROP POLICY IF EXISTS "gift_codes_select_policy" ON gift_codes;

CREATE POLICY "gift_codes_select_policy" ON gift_codes
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );
