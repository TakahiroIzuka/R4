-- Seed services table
INSERT INTO services (id, code, name) VALUES
  (1, 'medical', 'メディカル'),
  (2, 'house-builder', '住宅会社'),
  (3, 'vacation-stay', '宿泊施設');

-- Seed genres table
INSERT INTO genres (id, code, name, service_id) VALUES
  (1, 'pilates', 'ピラティス', 1),
  (2, 'medical', '内科系', 1),
  (3, 'surgery', '外科系', 1),
  (4, 'dental', '歯科系', 1),
  (5, 'dermatology', '皮膚科系', 1),
  (6, 'house-maker-term', 'ハウスメーカー', 2),
  (7, 'house-builder-term', 'ビルダー', 2),
  (8, 'first-class-architect-office-term', '一級建築士事務所', 2),
  (9, 'real-estate-company-term', '不動産会社', 2),
  (10, 'koumuten-term', '工務店', 2),
  (11, 'construction-company-term', '建設会社', 2);

-- Seed prefectures table
INSERT INTO prefectures (id, name, lat, lng) VALUES
  (1, '京都府', 35.0116, 135.7681),
  (2, '兵庫県', 34.6913, 135.1830),
  (3, '千葉県', 35.6047, 140.1233),
  (4, '埼玉県', 35.8569, 139.6489),
  (5, '大阪府', 34.6937, 135.5023),
  (6, '宮崎県', 31.9111, 131.4239),
  (7, '広島県', 34.3963, 132.4596),
  (8, '愛知県', 35.1802, 136.9066),
  (9, '東京都', 35.6894, 139.6917),
  (10, '熊本県', 32.7898, 130.7417),
  (11, '神奈川県', 35.4478, 139.6425);

-- Seed areas table
INSERT INTO areas (id, prefecture_id, name, lat, lng) VALUES
  (1, 5, '大阪市', 34.6937, 135.5023),
  (2, 8, '名古屋', 35.1802, 136.9066),
  (3, 9, '世田谷区', 35.6461, 139.6530),
  (4, 9, '中野区', 35.7074, 139.6638),
  (5, 9, '千代田区', 35.6940, 139.7536),
  (6, 9, '新宿区', 35.6938, 139.7035),
  (7, 9, '杉並区', 35.6994, 139.6364),
  (8, 9, '渋谷区', 35.6640, 139.6982),
  (9, 9, '港区', 35.6581, 139.7513);

-- Seed companies table
INSERT INTO companies (id, code, name) VALUES
  (1, 'dairy_skin_clinic', 'DAILY SKIN CLINIC'),
  (2, 'studio_ivy', 'STUDIO IVY'),
  (3, 'umeda_clinic', '西梅田シティクリニック'),
  (4, 'ito_construction', '株式会社伊藤建設'),
  (5, 'seiei_corporation', '株式会社清栄コーポレーション');

-- Seed facilities and facility_details table
-- Note: id and uuid are auto-generated
DO $$
DECLARE
  facility_id INTEGER;
BEGIN
  -- Facility 1: DAILY SKIN CLINIC 名古屋院
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 1, 5, 8, 2, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'DAILY SKIN CLINIC 名古屋院', 4, 102, NULL, 'https://dailyskinclinic.jp', '450-0002', '愛知県名古屋市中村区名駅4-26-9', '052-123-4567', 35.21513224384904, 136.90848145863572, NULL, NULL, NULL, NULL, NULL);

  -- Facility 2: DAILY SKIN CLINIC 心斎橋院
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 1, 5, 5, 1, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'DAILY SKIN CLINIC 心斎橋院', 4.7, 548, NULL, 'https://dailyskinclinic.jp', '542-0086', '大阪府大阪市中央区西心斎橋1-5-5', '06-1234-5678', 34.675872736516, 135.49841414232787, NULL, NULL, NULL, NULL, NULL);

  -- Facility 3: DAILY SKIN CLINIC 新宿院
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 1, 5, 9, 6, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'DAILY SKIN CLINIC 新宿院', 4.5, 197, NULL, 'https://dailyskinclinic.jp', '160-0022', '東京都新宿区新宿3-1-16', '03-1234-5678', 35.69130895971996, 139.7036116918168, NULL, NULL, NULL, NULL, NULL);

  -- Facility 4: STUDIO IVY 広尾ANNEX店
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 2, 1, 9, 8, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'STUDIO IVY 広尾ANNEX店', NULL, 0, NULL, 'https://www.pilates-ivy.jp', '150-0012', '東京都渋谷区広尾5-16-3', '03-2345-6789', 35.64839035285032, 139.7176866205972, NULL, NULL, NULL, NULL, NULL);

  -- Facility 5: STUDIO IVY 恵比寿店
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 2, 1, 9, 8, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'STUDIO IVY 恵比寿店', 5, 5, NULL, 'https://www.pilates-ivy.jp', '150-0013', '東京都渋谷区恵比寿1-20-8', '03-3456-7890', 35.64570669164102, 139.70429115767035, NULL, NULL, NULL, NULL, NULL);

  -- Facility 6: STUDIO IVY 赤坂ANNEX店
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 2, 1, 9, 9, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'STUDIO IVY 赤坂ANNEX店', 4.7, 3, NULL, 'https://www.pilates-ivy.jp', '107-0052', '東京都港区赤坂4-2-6', '03-4567-8901', 35.670664250365526, 139.7346120644181, NULL, NULL, NULL, NULL, NULL);

  -- Facility 7: 西梅田シティクリニック
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (1, 3, 2, 5, 1, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '西梅田シティクリニック', 3.3, 253, NULL, 'https://nishiumeda.city-clinic.jp', '530-0001', '大阪府大阪市北区梅田2-5-25', '06-2345-6789', 34.69959423473339, 135.4954401355819, NULL, NULL, NULL, NULL, NULL);

  -- Facility 8: 伊藤建設
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, 4, 10, 11, NULL, gen_random_uuid(), 1)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '伊藤建設', 4.8, 21, NULL, 'https://itokensetsu.com', '251-0052', '神奈川県藤沢市藤沢1015-23', '0466512322', 35.341983436514866, 139.48383143989673, NULL, NULL, NULL, NULL, NULL);

  -- Facility 9: 清栄コーポレーション
  INSERT INTO facilities (service_id, company_id, genre_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, 5, 6, 1, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '清栄コーポレーション', 3.5, 16, NULL, 'https://www.seiei-1997.co.jp', '604-0847', E'京都市中京区烏丸通二条下ル秋野々町514番\n清栄ビル京都烏丸2階', '0120170161', 35.0133426, 135.7567308, NULL, NULL, NULL, NULL, NULL);
END $$;

-- Seed users table with Supabase Auth integration
-- Note: All passwords are 'pass1234'
-- type: 'admin' = company_id is NULL, 'user' = company_id is NOT NULL

-- Create auth users and link them to users table
DO $$
DECLARE
  admin_auth_id UUID;
  daily_skin_auth_id UUID;
  studio_ivy_auth_id UUID;
  umeda_clinic_auth_id UUID;
BEGIN
  -- Create Supabase Auth users
  admin_auth_id := create_auth_user('admin@example.com', 'pass1234');
  daily_skin_auth_id := create_auth_user('user@dailyskinclinic.jp', 'pass1234');
  studio_ivy_auth_id := create_auth_user('user@studio-ivy.jp', 'pass1234');
  umeda_clinic_auth_id := create_auth_user('user@nishiumeda-clinic.jp', 'pass1234');

  -- Insert into users table with auth_user_id
  INSERT INTO users (email, type, company_id, auth_user_id) VALUES
    ('admin@example.com', 'admin', NULL, admin_auth_id),
    ('user@dailyskinclinic.jp', 'user', 1, daily_skin_auth_id),
    ('user@studio-ivy.jp', 'user', 2, studio_ivy_auth_id),
    ('user@nishiumeda-clinic.jp', 'user', 3, umeda_clinic_auth_id);
END $$;

-- Fix all sequences after inserting data with explicit IDs
-- This ensures auto-increment continues from the correct number
-- Use pg_get_serial_sequence to dynamically find the correct sequence name
SELECT setval(pg_get_serial_sequence('services', 'id'), (SELECT MAX(id) FROM services));
SELECT setval(pg_get_serial_sequence('genres', 'id'), (SELECT MAX(id) FROM genres));
SELECT setval(pg_get_serial_sequence('prefectures', 'id'), (SELECT MAX(id) FROM prefectures));
SELECT setval(pg_get_serial_sequence('areas', 'id'), (SELECT MAX(id) FROM areas));
SELECT setval(pg_get_serial_sequence('companies', 'id'), (SELECT MAX(id) FROM companies));
SELECT setval(pg_get_serial_sequence('facilities', 'id'), (SELECT MAX(id) FROM facilities));
