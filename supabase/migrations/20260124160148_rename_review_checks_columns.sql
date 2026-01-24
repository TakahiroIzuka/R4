-- Rename is_sent to is_review_posted
ALTER TABLE review_checks RENAME COLUMN is_sent TO is_review_posted;

-- Rename is_approved to is_owner_approved
ALTER TABLE review_checks RENAME COLUMN is_approved TO is_owner_approved;

-- Add is_admin_approved column
ALTER TABLE review_checks ADD COLUMN is_admin_approved BOOLEAN NOT NULL DEFAULT FALSE;

-- Add comments for clarity
COMMENT ON COLUMN review_checks.is_review_posted IS 'レビューが投稿されたかどうか';
COMMENT ON COLUMN review_checks.is_owner_approved IS 'オーナー（施設）による承認';
COMMENT ON COLUMN review_checks.is_admin_approved IS '管理者による承認';
