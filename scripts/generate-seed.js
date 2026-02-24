const fs = require('fs');
const path = require('path');
const { parse } = require('csv-parse/sync');

// Paths
const CSV_PATH = path.join(__dirname, '..', 'facilities.csv');
const SEED_PATH = path.join(__dirname, '..', 'supabase', 'seed.sql');

// Read and parse CSV
function readCSV() {
  const csvContent = fs.readFileSync(CSV_PATH, 'utf-8');
  const records = parse(csvContent, {
    columns: true,
    skip_empty_lines: true,
    trim: true
  });
  return records;
}

// Extract master data from seed.sql
function extractMasterData() {
  const seedContent = fs.readFileSync(SEED_PATH, 'utf-8');

  // Extract services
  const servicesMatch = seedContent.match(/-- Seed services table\s+INSERT INTO services[^;]+;/s);
  const services = {};
  if (servicesMatch) {
    const matches = servicesMatch[0].matchAll(/\((\d+),\s*'([^']+)',\s*'[^']+'\)/g);
    for (const match of matches) {
      services[match[2]] = parseInt(match[1]);
    }
  }

  // Extract companies
  const companiesMatch = seedContent.match(/-- Seed companies table\s+INSERT INTO companies[^;]+;/s);
  const companies = {};
  if (companiesMatch) {
    const matches = companiesMatch[0].matchAll(/\((\d+),\s*'([^']+)',\s*'[^']+'\)/g);
    for (const match of matches) {
      companies[match[2]] = parseInt(match[1]);
    }
  }

  // Extract genres
  const genresMatch = seedContent.match(/-- Seed genres table\s+INSERT INTO genres[^;]+;/s);
  const genres = {};
  if (genresMatch) {
    const matches = genresMatch[0].matchAll(/\((\d+),\s*'([^']+)',\s*'[^']+',\s*\d+\)/g);
    for (const match of matches) {
      genres[match[2]] = parseInt(match[1]);
    }
  }

  // Extract prefectures
  const prefecturesMatch = seedContent.match(/-- Seed prefectures table\s+INSERT INTO prefectures[^;]+;/s);
  const prefectures = {};
  if (prefecturesMatch) {
    const matches = prefecturesMatch[0].matchAll(/\((\d+),\s*'([^']+)',\s*[\d.]+,\s*[\d.]+\)/g);
    for (const match of matches) {
      prefectures[match[2]] = parseInt(match[1]);
    }
  }

  // Extract areas
  const areasMatch = seedContent.match(/-- Seed areas table\s+INSERT INTO areas[^;]+;/s);
  const areas = {};
  if (areasMatch) {
    const matches = areasMatch[0].matchAll(/\((\d+),\s*\d+,\s*'([^']+)',\s*[\d.]+,\s*[\d.]+\)/g);
    for (const match of matches) {
      areas[match[2]] = parseInt(match[1]);
    }
  }

  return { services, companies, genres, prefectures, areas };
}

// Generate facility SQL
function generateFacilitySQL(records, masterData) {
  const { services, companies, genres, prefectures, areas } = masterData;

  let sql = `-- Seed facilities and facility_details table
-- Note: id and uuid are auto-generated
DO $$
DECLARE
  facility_id INTEGER;
BEGIN\n`;

  records.forEach((record, index) => {
    const facilityNum = index + 1;

    // Get service_id
    const serviceId = services[record.service_code];
    if (!serviceId) {
      console.warn(`Warning: Service code '${record.service_code}' not found. Skipping facility: ${record.name}`);
      return;
    }

    // Get company_id (can be null)
    const companyId = record.company_code ? (companies[record.company_code] || 'NULL') : 'NULL';

    // Get prefecture_id
    const prefectureId = prefectures[record.prefecture_name];
    if (!prefectureId) {
      console.warn(`Warning: Prefecture '${record.prefecture_name}' not found. Skipping facility: ${record.name}`);
      return;
    }

    // Get area_id (can be null)
    const areaId = record.area_name ? (areas[record.area_name] || 'NULL') : 'NULL';

    // Get gift_code_amount_id (can be null)
    const giftCodeAmountId = record.gift_code_amount_id || 'NULL';

    // Parse genre codes (comma-separated)
    const genreCodes = record.genre_code.split(',').map(code => code.trim()).filter(code => code);
    const genreIds = genreCodes.map(code => genres[code]).filter(id => id);

    if (genreIds.length === 0) {
      console.warn(`Warning: No valid genres found for facility: ${record.name}. Genre codes: ${record.genre_code}`);
      return;
    }

    // Escape single quotes in strings
    const escapeSql = (str) => str ? str.replace(/'/g, "''") : '';

    sql += `  -- Facility ${facilityNum}: ${record.name}\n`;
    sql += `  INSERT INTO facilities (service_id, company_id, prefecture_id, area_id, uuid, gift_code_amount_id)\n`;
    sql += `  VALUES (${serviceId}, ${companyId}, ${prefectureId}, ${areaId}, gen_random_uuid(), ${giftCodeAmountId})\n`;
    sql += `  RETURNING id INTO facility_id;\n`;

    // facility_details
    const star = record.star || 'NULL';
    const userReviewCount = record.user_review_count || 'NULL';
    const googleMapUrl = record.google_map_url ? `'${escapeSql(record.google_map_url)}'` : 'NULL';
    const siteUrl = record.site_url ? `'${escapeSql(record.site_url)}'` : 'NULL';
    const postalCode = record.postal_code ? `'${escapeSql(record.postal_code)}'` : 'NULL';
    const address = record.address ? `'${escapeSql(record.address)}'` : 'NULL';
    const tel = record.tel ? `'${escapeSql(record.tel)}'` : 'NULL';
    const lat = record.lat || '0';
    const lng = record.lng || '0';
    const reviewApprovalEmail = record.review_approval_email ? `'${escapeSql(record.review_approval_email)}'` : 'NULL';
    const portfolioUrl = record.portfolio_url ? `'${escapeSql(record.portfolio_url)}'` : 'NULL';
    const eventUrl = record.event_url ? `'${escapeSql(record.event_url)}'` : 'NULL';
    const youtubeUrl = record.youtube_url ? `'${escapeSql(record.youtube_url)}'` : 'NULL';
    const googlePlaceId = record.google_place_id ? `'${escapeSql(record.google_place_id)}'` : "'ChIJdummy'";

    sql += `  INSERT INTO facility_details (facility_id, name, star, user_review_count, google_map_url, site_url, postal_code, address, tel, lat, lng, review_approval_email, portfolio_url, event_url, youtube_url, google_place_id)\n`;
    sql += `  VALUES (facility_id, '${escapeSql(record.name)}', ${star}, ${userReviewCount}, ${googleMapUrl}, ${siteUrl}, ${postalCode}, ${address}, ${tel}, ${lat}, ${lng}, ${reviewApprovalEmail}, ${portfolioUrl}, ${eventUrl}, ${youtubeUrl}, ${googlePlaceId});\n`;

    // facility_genres (multiple genres)
    genreIds.forEach(genreId => {
      sql += `  INSERT INTO facility_genres (facility_id, genre_id) VALUES (facility_id, ${genreId});\n`;
    });

    sql += '\n';
  });

  sql += 'END $$;';

  return sql;
}

// Update seed.sql
function updateSeedSQL(facilitiesSQL) {
  const seedContent = fs.readFileSync(SEED_PATH, 'utf-8');

  // Find the start and end of facilities section
  const startMarker = '-- Seed facilities and facility_details table';
  const endMarker = '\n\n-- Seed users table';

  const startIndex = seedContent.indexOf(startMarker);
  const endIndex = seedContent.indexOf(endMarker);

  if (startIndex === -1 || endIndex === -1) {
    throw new Error('Could not find facilities section in seed.sql');
  }

  // Replace facilities section
  const beforeFacilities = seedContent.substring(0, startIndex);
  const afterFacilities = seedContent.substring(endIndex);

  const newSeedContent = beforeFacilities + facilitiesSQL + afterFacilities;

  fs.writeFileSync(SEED_PATH, newSeedContent, 'utf-8');
}

// Main
function main() {
  console.log('Reading CSV file...');
  const records = readCSV();
  console.log(`Found ${records.length} facilities in CSV`);

  console.log('\nExtracting master data from seed.sql...');
  const masterData = extractMasterData();
  console.log(`Services: ${Object.keys(masterData.services).length}`);
  console.log(`Companies: ${Object.keys(masterData.companies).length}`);
  console.log(`Genres: ${Object.keys(masterData.genres).length}`);
  console.log(`Prefectures: ${Object.keys(masterData.prefectures).length}`);
  console.log(`Areas: ${Object.keys(masterData.areas).length}`);

  console.log('\nGenerating facility SQL...');
  const facilitiesSQL = generateFacilitySQL(records, masterData);

  console.log('\nUpdating seed.sql...');
  updateSeedSQL(facilitiesSQL);

  console.log('\n✅ seed.sql has been updated successfully!');
}

main();
