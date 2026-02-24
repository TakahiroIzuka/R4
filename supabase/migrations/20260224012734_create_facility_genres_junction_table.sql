-- Create junction table for many-to-many relationship between facilities and genres
CREATE TABLE facility_genres (
  id SERIAL PRIMARY KEY,
  facility_id INTEGER NOT NULL REFERENCES facilities(id) ON DELETE CASCADE,
  genre_id INTEGER NOT NULL REFERENCES genres(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(facility_id, genre_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_facility_genres_facility_id ON facility_genres(facility_id);
CREATE INDEX idx_facility_genres_genre_id ON facility_genres(genre_id);

-- Migrate existing data from facilities.genre_id to facility_genres
INSERT INTO facility_genres (facility_id, genre_id)
SELECT id, genre_id
FROM facilities
WHERE genre_id IS NOT NULL;

-- Drop the old genre_id column from facilities
ALTER TABLE facilities DROP COLUMN genre_id;

-- Enable Row Level Security
ALTER TABLE facility_genres ENABLE ROW LEVEL SECURITY;

-- RLS Policies for facility_genres
-- Allow public read access (for public site)
CREATE POLICY "facility_genres_select_public" ON facility_genres
  FOR SELECT TO anon, public
  USING (true);

-- Admin: full access
CREATE POLICY "facility_genres_all_admin" ON facility_genres
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'admin'
    )
  );

-- Normal users: can only access facility_genres for their company's facilities
CREATE POLICY "facility_genres_select_user" ON facility_genres
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_genres.facility_id
    )
  );

CREATE POLICY "facility_genres_insert_user" ON facility_genres
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_genres.facility_id
    )
  );

CREATE POLICY "facility_genres_update_user" ON facility_genres
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_genres.facility_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_genres.facility_id
    )
  );

CREATE POLICY "facility_genres_delete_user" ON facility_genres
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      JOIN facilities ON facilities.company_id = users.company_id
      WHERE users.auth_user_id = auth.uid()
      AND users.type = 'user'
      AND facilities.id = facility_genres.facility_id
    )
  );
