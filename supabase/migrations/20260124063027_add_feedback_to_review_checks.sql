-- review_checksテーブルにfeedbackカラムを追加
ALTER TABLE review_checks ADD COLUMN feedback TEXT;

-- コメント追加
COMMENT ON COLUMN review_checks.feedback IS 'お客様からのご意見・ご感想';
