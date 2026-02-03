-- ============================================
-- usersテーブルのRLSポリシー循環参照問題を修正
-- ============================================
-- 問題: users_all_admin ポリシーが自分自身がadminかどうか確認するために
-- usersテーブルを参照していたため、無限再帰が発生していた
--
-- 解決策: SECURITY DEFINER関数を使用してRLSをバイパスし、
-- ユーザーのタイプを安全に判定する
-- ============================================

-- 1. SECURITY DEFINER関数を作成（RLSをバイパスして実行される）
CREATE OR REPLACE FUNCTION public.get_current_user_type()
RETURNS TEXT AS $$
DECLARE
  user_type TEXT;
BEGIN
  SELECT type INTO user_type
  FROM users
  WHERE auth_user_id = auth.uid();

  RETURN user_type;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 関数の実行権限を設定
GRANT EXECUTE ON FUNCTION public.get_current_user_type() TO authenticated;

-- 2. 既存の問題のあるポリシーを削除
DROP POLICY IF EXISTS "users_all_admin" ON users;
DROP POLICY IF EXISTS "users_select_self" ON users;

-- 3. 新しいポリシーを作成（循環参照なし）

-- adminは全ユーザーの読み取り・更新・削除が可能
CREATE POLICY "users_all_admin" ON users
  FOR ALL TO authenticated
  USING (get_current_user_type() = 'admin')
  WITH CHECK (get_current_user_type() = 'admin');

-- 通常ユーザーは自分自身のレコードのみ読み取り可能
CREATE POLICY "users_select_self" ON users
  FOR SELECT TO authenticated
  USING (auth_user_id = auth.uid());
