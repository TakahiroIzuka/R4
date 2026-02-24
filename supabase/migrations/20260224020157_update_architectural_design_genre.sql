-- Update architectural design genre code and name
-- first-class-architect-office-term → architectural-design-term
-- 一級建築士事務所 → 建築士事務所

UPDATE genres
SET
  code = 'architectural-design-term',
  name = '建築士事務所'
WHERE code = 'first-class-architect-office-term';
