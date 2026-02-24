-- Clear existing data (in reverse order of foreign key dependencies)
TRUNCATE TABLE
  gift_codes,
  facility_genres,
  facility_details,
  facilities,
  gift_code_amounts,
  companies,
  areas,
  prefectures,
  genres,
  services
RESTART IDENTITY CASCADE;

-- Delete seed auth users if they exist
DELETE FROM auth.users
WHERE email IN (
  'admin@example.com',
  'user@dailyskinclinic.jp',
  'user@studio-ivy.jp',
  'user@nishiumeda-clinic.jp'
);

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
  (8, 'architectural-design-term', '建築士事務所', 2),
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

-- Seed gift_code_amounts table
INSERT INTO gift_code_amounts (id, amount) VALUES
  (1, 3000),
  (2, 5000),
  (3, 10000);

-- Seed facilities and facility_details table
-- Note: id and uuid are auto-generated
DO $$
DECLARE
  facility_id INTEGER;
BEGIN
  -- Facility 1: 伊藤建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '伊藤建設', NULL, NULL, 'https://maps.app.goo.gl/LD5j9VjdFeEt3uQv9', 'https://itokensetsu.com', '251-0052', '神奈川県藤沢市藤沢1015-23', '466512322', 35.34198344, 139.4838314, NULL, 'https://itokensetsu.com/works/', 'https://itokensetsu.com/event/', 'https://www.youtube.com/watch?v=Q6lwUWX4Nzw&t=1s', 'ChIJs2bC3U5PGGARZ--7xqM6geI');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 2: es ARCHITECT
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'es ARCHITECT', NULL, NULL, 'https://maps.app.goo.gl/UyD3f4kohrXgD9T66', 'https://es-archi.jp/', '536-0016', '大阪市城東区蒲生2-7-8', '661675143', 34.6989825, 135.5393915, NULL, 'https://es-archi.jp/works/', 'https://es-archi.jp/event/', NULL, 'ChIJBwBQCNzgAGARsV3iriH_ZQc');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 3: GRAN-STYLE（グランスタイル）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'GRAN-STYLE（グランスタイル）', NULL, NULL, 'https://maps.app.goo.gl/C322r6VTf6ZK2NeP7', 'https://housing-ns.jp/', '530-0026', '大阪市北区神山町8-1 梅田辰巳ビル4F', '661255421', 34.7025553, 135.5026027, NULL, 'https://housing-ns.jp/salelist/', NULL, NULL, 'ChIJAQAslermAGARLpo9e6czufk');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);

  -- Facility 4: Gハウス
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'Gハウス', NULL, NULL, 'https://maps.app.goo.gl/oTd3MGEzTJa5R4Cu9', 'https://g-house.osaka.jp/', '535-0022', '大阪市旭区新森2丁目23-12', '669540648', 34.7165552, 135.5559174, NULL, 'https://g-house.osaka.jp/gallery', 'https://g-house.osaka.jp/event/opendays', NULL, 'ChIJA8cFqAXhAGARWWDUX7_IhUA');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 7);

  -- Facility 5: HIRO工務店（HIRO空間設計）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'HIRO工務店（HIRO空間設計）', NULL, NULL, 'https://maps.app.goo.gl/qveiFYnq2ManTMou5', 'https://hiro-ks.com/', '250-0012', '神奈川県小田原市本町2丁目13-15 第八セントラルビル小田原1階A', '465203280', 35.2493103, 139.1590014, NULL, 'https://hiro-ks.com/sekou.html', NULL, NULL, 'ChIJv9M5Sf2kGWARlmOjwyo9zkM');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 6: PLUS STYLE（注文住宅）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'PLUS STYLE（注文住宅）', NULL, NULL, 'https://maps.app.goo.gl/5gE3FMFDs35gPBgbA', 'https://plus-estate.jp/', '250-0001', '神奈川県小田原市扇町1丁目16－37 宮内ビル101', '465208001', 35.2645472, 139.1603784, NULL, 'https://plus-estate.jp/', 'https://plus-estate.jp/works/', NULL, 'ChIJOVV3enlXGGARWTXOveB5NwI');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);

  -- Facility 7: SARA HOME（桜建築事務所）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'SARA HOME（桜建築事務所）', NULL, NULL, 'https://maps.app.goo.gl/WM82y3WY7CchFTBY6', 'https://sakurakentiku.jp/', '243-0303', '神奈川県愛甲郡愛川町中津3367-7', '462862722', 35.5151409, 139.3377425, NULL, 'https://sakurakentiku.jp/works/', 'https://sakurakentiku.jp/misc_reserve/', NULL, 'ChIJn5vItiACGWARnUEXovIdatI');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 8: TAKI HOUSE
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'TAKI HOUSE', NULL, NULL, 'https://maps.app.goo.gl/tUTAHiaQA2ccE8er7', 'https://www.taki-house.co.jp/', '214-0021', '神奈川県川崎市多摩区宿河原2丁目26番1号', '449310036', 35.6144303, 139.5721791, NULL, 'https://www.taki-house.co.jp/works/?ca=3', 'https://www.taki-house.co.jp/news/?ca=1', NULL, 'ChIJvQjkvC7xGGARq2Lt2pd4CzU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 7);

  -- Facility 9: THE HOUSE（ザ ハウス）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'THE HOUSE（ザ ハウス）', NULL, NULL, 'https://maps.app.goo.gl/eofsPETcMkpuTwJA6', 'https://thehouse.style', '536-0015', '大阪府大阪市城東区新喜多1-7-25 スズビル京橋2F', '661852208', 34.6966481, 135.5394582, NULL, 'https://thehouse.style/plan/', NULL, NULL, 'ChIJbdsxNKDhAGARD6Qi5mApZBk');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 10: あすなろ建築工房
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'あすなろ建築工房', NULL, NULL, 'https://maps.app.goo.gl/PXbG1XFhHkwEhQed7', 'https://www.asunaro-studio.com/', '232-0041', '神奈川県横浜市南区睦町1-23-4', '453266007', 35.43219652, 139.6189405, NULL, NULL, NULL, NULL, 'ChIJqSp7_JpcGGARujHHk86zygU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 11: アシストホーム
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'アシストホーム', NULL, NULL, 'https://maps.app.goo.gl/c4oAoBuk569PRkPH9', 'https://www.assisthome-wb.jp/', '240-0111', '神奈川県三浦郡葉山町一色499', '468771127', 35.2685481, 139.5953574, NULL, 'https://www.assisthome-wb.jp/works/', NULL, NULL, 'ChIJ0UzZojhHGGAR5H0HY2821y4');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 12: アートテラスホーム
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'アートテラスホーム', NULL, NULL, 'https://maps.app.goo.gl/Z6DUF9zfmdKjACZ86', 'https://www.arterracehome.jp', '236-0051', '神奈川県横浜市金沢区富岡東4丁目3−51', '453743701', 35.3712096, 139.6338925, NULL, NULL, NULL, NULL, 'ChIJK7QAOlRBGGARn42flpoV6S4');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 13: イソダ
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'イソダ', NULL, NULL, 'https://maps.app.goo.gl/BXA6HrrEhPBMYDXx5', 'https://www.isoda.co.jp/', '248-0033', '神奈川県鎌倉市腰越4-9-7', '467319246', 35.3108966, 139.4945884, NULL, 'https://www.isoda.co.jp/works/', 'https://www.isoda.co.jp/event/', NULL, 'ChIJfXK2qBpPGGARqlxtg-gGqcg');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 14: カキザワホームズ
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'カキザワホームズ', NULL, NULL, 'https://maps.app.goo.gl/JFfrenaQMZKHyhuB7', 'https://kakizawa-sc.co.jp/', '252-0225', '神奈川県相模原市中央区緑が丘2-43-21', '120631009', 35.5471532, 139.3807098, NULL, 'https://kakizawa-sc.co.jp/cms/example', NULL, NULL, 'ChIJtRX-tqL9GGARmHsZgvYLGe0');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 15: カマクラ工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'カマクラ工務店', NULL, NULL, 'https://maps.app.goo.gl/vgU6GoQ57oTbCMRB8', 'https://www.kamakura-koumuten.com/', '248-0006', '神奈川県鎌倉市小町2-15-7 ザ・パークハウス鎌倉 1F', '0467385118', 35.3201105, 139.5504365, NULL, 'https://kamakura-koumuten.com/case/', NULL, NULL, 'ChIJrRc2VsFFGGARLZWGf6i5jDo');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 16: キリガヤ
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'キリガヤ', NULL, NULL, 'https://maps.app.goo.gl/Qd9L6w88RMEvCrHM8', 'https://kirigaya.jp/', '249-0002', '神奈川県逗子市山の根1-2-35', '0468730066', 35.29860298, 139.5767294, NULL, NULL, NULL, NULL, 'ChIJR96yloxGGGARnYxcALWeSAs');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 17: サンキホーム
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'サンキホーム', NULL, NULL, 'https://maps.app.goo.gl/nAvQTSTAvKDCbuti9', 'https://www.sankihome.co.jp/', '251-0043', '神奈川県藤沢市辻堂元町4-15-17', '0466333336', 35.3311387, 139.455604, NULL, 'https://www.sankihome.co.jp/construct/', 'https://www.sankihome.co.jp/blog/event/', NULL, 'ChIJC6IITeBPGGARqonnsMxb3MI');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 18: ジューテックホーム
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ジューテックホーム', NULL, NULL, 'https://maps.app.goo.gl/s3LPkDhCaA65oYdx8', 'https://www.jutec-home.jp/', '224-0035', '神奈川県横浜市都筑区新栄町4-1', '0455953222', 35.5386719, 139.5934436, NULL, 'https://www.jutec-home.jp/works/', NULL, NULL, 'ChIJLeeeOaRYGGARQF8Q0i4tAvs');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 19: タイセーハウジング
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'タイセーハウジング', NULL, NULL, 'https://maps.app.goo.gl/YTRSstGuF2AzMXJGA', 'https://www.taise-housing.co.jp/', '243-0018', '神奈川県厚木市中町4-14-1 サクセス本厚木ビル4F', '0462444888', 35.43913606, 139.3627342, NULL, 'https://www.taise-housing.co.jp/Examples/chumon_index', NULL, NULL, 'ChIJvbufQLKqGWARODXhv00oZRQ');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 20: タマック
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'タマック', NULL, NULL, 'https://maps.app.goo.gl/V7JafLUei8Z4zbH1A', 'https://tamac-inc.co.jp/', '214-0032', '神奈川県川崎市多摩区枡形2-6-11', '0120013709', 35.6182857, 139.5544184, NULL, 'https://tamac-inc.co.jp/case_newly', 'https://tamac-inc.co.jp/event', NULL, 'ChIJ45Jb5MLwGGAR9NE0mZkR-U4');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 21: ダイシンハウス
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ダイシンハウス', NULL, NULL, 'https://maps.app.goo.gl/BvzShFLnKCJq8ma76', 'https://www.daishinhousenew.com/', '239-0807', '神奈川県横須賀市根岸町3-11-5', '0468368990', 35.25039249, 139.6834604, NULL, 'https://www.daishinhousenew.com/works_index.html', NULL, NULL, 'ChIJWwvK_9I_GGARjru8FJCUJnk');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 22: ダイトー建設不動産（小田原店）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ダイトー建設不動産（小田原店）', NULL, NULL, 'https://maps.app.goo.gl/UdBrkCzAfSYXgzQv5', 'https://www.dyto.jp/', '250-0852', '神奈川県小田原市栢山506-1 パストラル宮ノ上103', '0465393388', 35.3095478, 139.143368, NULL, 'https://www.dyto.jp/build_result/', 'https://www.dyto.jp/information/', NULL, 'ChIJu1wco-umGWARHIkOPsXypPc');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 23: ネスト
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ネスト', NULL, NULL, 'https://maps.app.goo.gl/9Hv9rgxUQfybvdNt6', 'https://nestec.jp/', '254-0063', '神奈川県平塚市諏訪町14番44号', '0463361166', 35.3375818, 139.3295337, NULL, 'https://nestec.jp/case/', NULL, NULL, 'ChIJ9wzzi_CsGWARrTZczmxWyJM');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 24: バウムスタンフ
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'バウムスタンフ', NULL, NULL, 'https://maps.app.goo.gl/8qFctcZrSXdRoNe68', 'https://www.baumstumpf.com/', '251-0047', '神奈川県藤沢市辻堂5丁目4番11-C号', '0466340030', 35.3299789, 139.4491263, NULL, 'https://www.baumstumpf.com/category/works/', 'https://www.baumstumpf.com/category/blog/', NULL, 'ChIJmYLT_wVOGGARTM1Lt60Bzd0');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 25: ビクトリーホーム
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ビクトリーホーム', NULL, NULL, 'https://maps.app.goo.gl/dWQDPssRPPTdR61c7', 'https://victory-gp.jp/', '250-0124', '神奈川県南足柄市生駒361-5', '0466738655', 35.31299752, 139.117104, NULL, NULL, NULL, NULL, 'ChIJtYN1-CmhGWARzS6bXH8L0MU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 26: フローレンスガーデン
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'フローレンスガーデン', NULL, NULL, 'https://maps.app.goo.gl/8tKU5tapURakKzM47', 'https://www.florence-garden.com', '225-0003', '神奈川県横浜市青葉区新石川4-33-10', '0459115300', 35.568187, 139.562375, NULL, 'https://www.florence-garden.com/works_list/', 'https://www.florence-garden.com/showroom/', NULL, 'ChIJ4QSZAXX3GGARIlsV8DtpuhQ');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 27: プロネット
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'プロネット', NULL, NULL, 'https://maps.app.goo.gl/WvjBX8PXhY6RKbm78', 'https://www.pronet-home.com/', '220-0023', '神奈川県横浜市西区平沼1-3-17　宮方ビル2F', '0452904610', 35.4604853, 139.6179711, NULL, 'https://www.pronet-home.com/portfolio/', NULL, NULL, 'ChIJU_bUWlmNGGAR-FsD6324fXo');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 28: ホームスタイリング
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ホームスタイリング', NULL, NULL, 'https://maps.app.goo.gl/6vzVDYrSVXjZ9WH49', 'https://www.home-styling.co.jp/', '251-0037', '神奈川県藤沢市鵠沼海岸4丁目6-6', '0466608146', 35.3177677, 139.4606241, NULL, 'https://www.home-styling.co.jp/works/', 'https://www.home-styling.co.jp/event/', NULL, 'ChIJnQ5o6GhOGGARPfF9qyxN53w');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);

  -- Facility 29: ラボワット
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ラボワット', NULL, NULL, 'https://maps.app.goo.gl/hS7cqPvn7X3zRGMZ8', 'https://laboite.tv/', '251-0035', '神奈川県藤沢市片瀬海岸3丁目21', '0466292448', 35.3116738, 139.4777826, NULL, 'https://laboite.tv/works/pg5398437.html', NULL, NULL, 'ChIJm9cn4_hOGGARLsQcn1P6UoU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 30: ラ・ヴィータエステート
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, 'ラ・ヴィータエステート', NULL, NULL, 'https://maps.app.goo.gl/9UrSidB8UHYM4RLh9', 'https://www.lavitaestate.com/', '256-0815', '神奈川県小田原市小八幡781-1', '0465477878', 35.2800826, 139.1972972, NULL, 'https://www.lavitaestate.com/lowcost/', NULL, NULL, 'ChIJsdhmZ9SlGWAR7DB-9DyPc4s');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);

  -- Facility 31: 三心
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '三心', NULL, NULL, 'https://maps.app.goo.gl/Bd4Y75TztjiPm79F6', 'https://sannsin.com/', '250-0055', '神奈川県小田原市久野3067', '0465310015', 35.275149, 139.1149393, NULL, 'https://sannsin.com/works/', 'https://sannsin.com/news/', NULL, 'ChIJvZfS8_6jGWARM3JByacAgLo');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 32: 三森工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '三森工務店', NULL, NULL, 'https://maps.app.goo.gl/D3bSVHQbSQUMvu2XA', 'https://spanish-house.net/', '222-0036', '神奈川県横浜市港北区小机町3-1', '0455347504', 35.5110692, 139.5817801, NULL, NULL, NULL, NULL, 'ChIJq6qmWJ4VGGARTSodj-h2onE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 33: 三陽工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '三陽工務店', NULL, NULL, 'https://maps.app.goo.gl/cHjpCGmHUyUPQCCZ9', 'https://sanyoukoumuten.co.jp/', '252-0304', '神奈川県相模原市南区旭町11番8号', '0427420293', 35.5252903, 139.4239867, NULL, 'https://www.sanyoukoumuten.co.jp/caseall/case-ranking.html', 'https://www.sanyoukoumuten.co.jp/event/event.html', NULL, 'ChIJo86BC8L-GGARBTK7gJn4NHI');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 34: 中山建設（家づくり工房kitote）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '中山建設（家づくり工房kitote）', NULL, NULL, 'https://maps.app.goo.gl/4f1woPJDQmgv3DaK9', 'https://nakaken-nh.jp/', '241-0806', '神奈川県横浜市旭区下川井町2149-6', '0459415336', 35.48768708, 139.5145513, NULL, NULL, NULL, NULL, 'ChIJERBuNHxYGGARgQ-5__XoVJM');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 35: 中川工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '中川工務店', NULL, NULL, 'https://maps.app.goo.gl/kXnUq56rLzHZtVfu7', 'https://www.nakagawakoumuten.jp/', '258-0029', '神奈川県足柄上郡開成町みなみ5丁目5−１', '0465437770', 35.3196838, 139.1222079, NULL, 'https://www.nakagawakoumuten.jp/gallery', NULL, NULL, 'ChIJNaBO1SunGWAR6stK5bwfHRM');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 36: 丸晴工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '丸晴工務店', NULL, NULL, 'https://maps.app.goo.gl/pu93pwSqz4cyxuiM7', 'https://www.marusei-j.co.jp/', '214-0004', '神奈川県川崎市多摩区菅馬場2-3-2', '0449442007', 35.62858465, 139.539719, NULL, NULL, NULL, NULL, 'ChIJI-aRwYjwGGARvlJdc42gCkE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 37: 伊沢工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '伊沢工務店', NULL, NULL, 'https://maps.app.goo.gl/SmTTbTN3G6R9bXBZ6', 'https://izawa-koumuten.co.jp/', '242-0001', '神奈川県大和市下鶴間2785-31', '0462741199', 35.4938872, 139.4539416, NULL, 'https://izawa-koumuten.co.jp/works/', 'https://izawa-koumuten.co.jp/event/', NULL, 'ChIJbcVoYa_4GGARfXpc2bTlru8');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 38: 優建築工房
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '優建築工房', NULL, NULL, 'https://maps.app.goo.gl/R1LSRrKiQyDdGE3R8', 'https://yukobo.jp/', '243-0815', '神奈川県厚木市妻田西1-20-8', '0462944500', 35.4589071, 139.356196, NULL, 'https://yukobo.jp/example/', NULL, NULL, 'ChIJh3WHExsAGWAREz52K6Z2jFE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 39: 創和建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '創和建設', NULL, NULL, 'https://maps.app.goo.gl/sGRmeRrayo5M2w7B6', 'https://sowa-tm.jp/', '252-0184', '神奈川県相模原市緑区小渕1707', '0426876400', 35.5577819, 139.2322306, NULL, 'https://sowa-tm.jp/works/', 'https://sowa-tm.jp/archives/category/news', NULL, 'ChIJS_uzqPAWGWARUGNhSWnUmFg');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);

  -- Facility 40: 加賀妻工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '加賀妻工務店', NULL, NULL, 'https://maps.app.goo.gl/GznA6JZKz2vtehqS8', 'https://www.kagatuma.co.jp/', '253-0085', '神奈川県茅ヶ崎市矢畑1395', '0467871711', 35.3413795, 139.3969153, NULL, 'https://www.kagatuma.co.jp/jirei.html', NULL, NULL, 'ChIJi2o-ZvFSGGARuuydX6eHOFE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 41: 北村建築工房
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '北村建築工房', NULL, NULL, 'https://maps.app.goo.gl/3xtoXAythuxHx5YcA', 'https://ki-kobo.jp/', '237-0063', '神奈川県横須賀市追浜東町2-13', '0468654321', 35.31389838, 139.631057, NULL, NULL, NULL, NULL, 'ChIJS9AWFBZBGGART09Zw4DE7TU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 42: 大勝建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '大勝建設', NULL, NULL, 'https://maps.app.goo.gl/N5RrncEtcNvqRxNC7', 'https://www.daikatsu.plus/', '253-0055', '神奈川県茅ヶ崎市中海岸1丁目1-58', '0467862600', 35.3275237, 139.4027732, NULL, 'https://www.daikatsu.plus/works/', NULL, NULL, 'ChIJ6aOkhIdSGGARDqFAaKEHTsQ');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 43: 大栄建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '大栄建設', NULL, NULL, 'https://maps.app.goo.gl/vDa8waVd4aRJ9Bgw6', 'https://www.daiei-co.com/', '236-0042', '神奈川県横浜市金沢区釜利谷東6-5-53', '0120816636', 35.3430583, 139.5705721, NULL, 'https://www.daiei-co.com/example/ex_cat/shinchiku', 'https://www.ie-miru.jp/cms/yoyaku/990385', NULL, 'ChIJoUxRY_ZDGGARTBVHngeypzM');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 44: 奥山工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '奥山工務店', NULL, NULL, 'https://maps.app.goo.gl/MxpH3ku7mEGjXnSD8', 'https://www.okuyama-co.co.jp/', '238-0101', '神奈川県三浦市南下浦町上宮田1584番地', '0120046898', 35.1892853, 139.6481444, NULL, 'https://www.okuyama-co.co.jp/case/', NULL, NULL, 'ChIJ9bhZrtI9GGARtpQ9q1o4WvY');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 45: 富士建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '富士建設', NULL, NULL, 'https://maps.app.goo.gl/5aNKBQb2T73TjjRE8', 'https://www.fujikensetsu.co.jp/', '253-0041', '神奈川県茅ケ崎市茅ヶ崎1丁目2番66号', '0120853900', 35.3324753, 139.4002267, NULL, 'https://www.fujikensetsu.co.jp/work/index01.html', 'https://www.fujikensetsu.co.jp/event/index.html', NULL, 'ChIJXRQPcIlSGGARJB6bWEN57BY');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 46: 小林住宅
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '小林住宅', NULL, NULL, 'https://maps.app.goo.gl/tPATf64iuY4QhmLC6', 'https://dreamhome.co.jp', '541-0046', '大阪府大阪市中央区平野町2丁目4-9 淀屋橋PREX 6階', '0667664830', 34.6878323, 135.5023715, NULL, 'https://dreamhome.co.jp/voice/', NULL, NULL, 'ChIJLTQs2uPmAGARqCaA1w2DgEk');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 47: 小泉木材
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '小泉木材', NULL, NULL, 'https://maps.app.goo.gl/U8NyJW21oKnsmP6k8', 'https://kizuki-home.co.jp/', '224-0057', '神奈川県横浜市都筑区川和町101番地', '0459312801', 35.51945849, 139.5539028, NULL, NULL, NULL, NULL, 'ChIJO49qyg5cGGARbOiZbH4sLVs');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 48: 山下建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '山下建設', NULL, NULL, 'https://maps.app.goo.gl/91iXrtByNEx3GYjb8', 'https://www.howz-yamaken.co.jp', '242-0022', '神奈川県大和市柳橋5丁目7−10', '0462692111', 35.45535566, 139.4568121, NULL, NULL, NULL, NULL, 'ChIJcX9_SmNWGGARjYXa_Xgx6OU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 7);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 49: 岡本工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '岡本工務店', NULL, NULL, 'https://maps.app.goo.gl/dtvyKvRyvke6Roqb7', 'https://www.okmt-5610.co.jp', '540-0027', '大阪府大阪市中央区鎗屋町1丁目3−5 鎗屋町岡本ビル3階', '0669417666', 34.6826268, 135.5123584, NULL, 'https://www.okmt-5610.co.jp/works', 'https://www.okmt-5610.co.jp/event', NULL, 'ChIJFwWhyunnAGARczCZIA2X5lU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 50: 工藤工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '工藤工務店', NULL, NULL, 'https://maps.app.goo.gl/rM9FfzwZoLe6hqdh6', 'https://www.kudou-koumuten.co.jp/', '254-0077', '神奈川県平塚市東中原1丁目3ー62', '0463374003', 35.3524244, 139.339266, NULL, 'https://www.kudou-koumuten.co.jp/co_photo.html', NULL, NULL, 'ChIJl4OZUJSsGWARdYb1auLLJkY');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 51: 成建オーダーハウス
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '成建オーダーハウス', NULL, NULL, 'https://maps.app.goo.gl/bnZhg2qFsTW9Gys86', 'https://www.seiken-oh.jp/', '216-0007', '神奈川県川崎市宮前区小台2-6-6', '0448560818', 35.5845405, 139.5785308, NULL, 'https://www.seiken-oh.jp/case.html', NULL, NULL, 'ChIJVVVVFfD2GGARn1f-WYv1b2M');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 52: 戸井田工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '戸井田工務店', NULL, NULL, 'https://maps.app.goo.gl/FKChhe7FgiUGL5fm9', 'https://www.kamakura-standard.com/', '248-0007', '神奈川県鎌倉市大町5-5-9', '0467247777', 35.3092364, 139.5571351, NULL, NULL, NULL, NULL, 'ChIJed3L4NdFGGARa8fTma0iClU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 53: 新進建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '新進建設', NULL, NULL, 'https://maps.app.goo.gl/86nxL86yDbbtfjuQ8', 'https://www.shinshin-homes.co.jp/', '257-0012', '神奈川県秦野市西大竹116-1', '0463826014', 35.3578689, 139.2327611, NULL, 'https://www.shinshin-homes.co.jp/works/', 'https://www.shinshin-homes.co.jp/event/', NULL, 'ChIJH6Fvl_moGWARvuyTEfCTXAU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 54: 木匠工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '木匠工務店', NULL, NULL, 'https://maps.app.goo.gl/4q16tjphhL3D9cnX7', 'https://www.mokusho.com/', '227-0036', '神奈川県横浜市青葉区奈良町1966-7', '0459627854', 35.5615326, 139.4814681, NULL, 'https://www.mokusho.com/works/', 'https://www.mokusho.com/event/', NULL, 'ChIJreDNEXf5GGARUXbLPnVxBXk');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 55: 杉崎工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '杉崎工務店', NULL, NULL, 'https://maps.app.goo.gl/WbGt5T1kNCN2ggJs5', 'https://www.sugizaki-koumuten.jp/', '250-0002', '神奈川県小田原市寿町4丁目9-26', '0465348914', 35.2638323, 139.1658408, NULL, 'https://www.sugizaki-koumuten.jp/case/', NULL, NULL, 'ChIJTTFDxU_7GGARFVDhW3UxzXY');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 9);

  -- Facility 56: 松尾建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '松尾建設', NULL, NULL, 'https://maps.app.goo.gl/Cm4u192DayvbipoB7', 'https://www.matsuokensetsu.co.jp', '253-0054', '神奈川県茅ヶ崎市東海岸南3丁目1−15 松尾パルデンス', '0467857118', 35.323191, 139.4081437, NULL, NULL, NULL, NULL, 'ChIJ8YMRoH9SGGARE93kDy11Qtw');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 57: 柏木工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '柏木工務店', NULL, NULL, 'https://maps.app.goo.gl/58hwBVjingAkKPbQ8', 'https://www.kashiko-home.com/', '259-1125', '神奈川県伊勢原市下平間673', '0463933195', 35.384725, 139.3195512, NULL, 'https://www.kashiko-home.com/contents/category/gallery/', NULL, NULL, 'ChIJFadZ_aarGWARvfP7f-DwRtU');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 58: 株式会社TERAAS
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '株式会社TERAAS', NULL, NULL, 'https://maps.app.goo.gl/J4KbAJPesGf9L8nYA', 'https://teraas.co.jp/', '213-0033', '神奈川県川崎市高津区下作延1-1-7 nokutica', '0444001924', 35.6008524, 139.6060608, NULL, NULL, NULL, NULL, 'ChIJZ_VmeDz3GGARJvB2_a957hs');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 59: 株式会社じょぶ
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '株式会社じょぶ', NULL, NULL, 'https://maps.app.goo.gl/aFNgnwaLebk6beQ68', 'https://job-homes.com', '578-0911', '大阪府東大阪市中新開2-10-26', '0120926117', 34.6834534, 135.6194821, NULL, 'https://job-homes.com/works/', 'https://job-homes.com/events/', NULL, 'ChIJPX53CEEgAWARXvPXi5ZuSUc');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 60: 株式会社ダイヤビルト
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '株式会社ダイヤビルト', NULL, NULL, 'https://maps.app.goo.gl/9kYbBPmXUks3fkdp9', 'http://www.diabuilt.jp/', '213-0015', '神奈川県川崎市高津区梶ケ谷6丁目1-9 トライアングル梶ヶ谷 106', '0447899001', 35.5842865, 139.6050261, NULL, 'http://www.diabuilt.jp/#WORKS', NULL, NULL, 'ChIJ5RduCIf2GGAR8AxQdeZO_To');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 61: 株式会社マイトレジャー
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '株式会社マイトレジャー', NULL, NULL, 'https://maps.app.goo.gl/cLqkvUm89A1qnu8j7', 'https://mytre.jp/', '254-0077', '神奈川県平塚市東中原1-6-6', '0120000667', 35.3555877, 139.3395619, NULL, 'https://mytre.jp/works/', NULL, NULL, 'ChIJoW-ojJasGWARd4X3pQ8glj0');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 62: 根建工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '根建工務店', NULL, NULL, 'https://maps.app.goo.gl/45qyB7mLcTndooPL9', 'https://www.nedate.jp/', '242-0024', '神奈川県大和市福田1-11-5', '0462684061', 35.4507146, 139.4609858, NULL, 'https://www.nedate.jp/works-gallery', NULL, NULL, 'ChIJAQC0vYtWGGARFdrB3E9a9vE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 63: 江原工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '江原工務店', NULL, NULL, 'https://maps.app.goo.gl/DEcmHR1o5bwjCy3i8', 'https://www.ebarakoumuten.co.jp/', '250-0852', '神奈川県小田原市栢山2723-1', '0465381177', 35.3119082, 139.1400895, NULL, 'https://www.ebarakoumuten.co.jp/story.html', 'https://www.ebarakoumuten.co.jp/event_kengakukai.html', NULL, 'ChIJOWHN1ummGWARSDKwz5Z70mI');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 64: 田原建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 5, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '田原建設', NULL, NULL, 'https://maps.app.goo.gl/VQu3GajJb7T85qHZ8', 'https://www.tahara-k.jp', '573-1105', '大阪府枚方市南楠葉1丁目14-14 田原ビル3階', '0728517500', 34.8616689, 135.6823698, NULL, 'https://www.tahara-k.jp/works/', NULL, NULL, 'ChIJRZDilFsbAWARg-QAkvi4kso');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 65: 種市工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '種市工務店', NULL, NULL, 'https://maps.app.goo.gl/CYFLNaKtPxN61BP86', 'https://www.taneichikoumuten.com/', '243-0035', '神奈川県厚木市愛甲1丁目24-32', '0462479806', 35.4217183, 139.3364341, NULL, 'https://www.taneichikoumuten.com/case/', NULL, NULL, 'ChIJ2az9s-yqGWARPFCz19qr-cg');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

  -- Facility 66: 竹駒工務店
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '竹駒工務店', NULL, NULL, 'https://maps.app.goo.gl/tqayWciyMkNMvWtH9', 'http://www.takekoma.co.jp/', '226-0025', '神奈川県横浜市緑区十日市場町866-9', '0459837702', 35.5258444, 139.5083353, NULL, 'http://www.takekoma.co.jp/works/works_new_top.html', NULL, NULL, 'ChIJL6oETRT4GGARQ05-H2liTYc');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);

  -- Facility 67: 自然素材ハウス（トミス建設）
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '自然素材ハウス（トミス建設）', NULL, NULL, 'https://maps.app.goo.gl/h5Xg7YtCVpXzmi9x8', 'https://natural-house.co.jp/', '212-0015', '神奈川県川崎市幸区柳町8-3', '0445897112', 35.5314543, 139.6843636, NULL, 'https://natural-house.co.jp/gallery/', 'https://natural-house.co.jp/event/', NULL, 'ChIJZTBArrdfGGARS5vtfEI-2JE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 8);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 68: 青木建設
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '青木建設', NULL, NULL, 'https://maps.app.goo.gl/XN39evp1SxUuGxCb7', 'https://www.aoki-kensetu.jp/', '256-0816', '神奈川県小田原市酒匂1403', '0465473321', 35.2794687, 139.1796484, NULL, 'https://www.aoki-kensetu.jp/works/', NULL, NULL, 'ChIJMX_i8b2lGWARdY51GAJJlpE');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 11);

  -- Facility 69: 高山マテリアル株式会社
  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)
  VALUES (2, NULL, 11, NULL, gen_random_uuid(), NULL)
  RETURNING id INTO facility_id;
  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)
  VALUES (facility_id, '高山マテリアル株式会社', NULL, NULL, 'https://maps.app.goo.gl/Lf7gKTiCMDYLCgdx7', 'https://takayama-mt.co.jp/', '211-0034', '神奈川県川崎市中原区井田中ノ町28番2号', '0447885156', 35.5638427, 139.6435417, NULL, 'https://takayama-mt.co.jp/case', 'https://takayama-mt.co.jp/event', NULL, 'ChIJ8cLBV4f1GGARtdCJJw4Dsi8');
  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, 10);

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
