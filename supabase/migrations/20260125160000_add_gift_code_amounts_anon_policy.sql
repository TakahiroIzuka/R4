-- gift_code_amountsテーブルにanonユーザーのSELECT権限を追加
-- アンケート画面でギフトコード額に基づいて画像を表示するために必要

ALTER TABLE gift_code_amounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anon to read gift_code_amounts"
ON gift_code_amounts
FOR SELECT
TO anon
USING (true);
