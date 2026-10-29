-- Interio Platform: NeonDB Serverless PostgreSQL Schema & Seed Data
-- Run this in the Neon SQL Editor or let the /api/init endpoint auto-provision on first launch.

CREATE TABLE IF NOT EXISTS design_niches (
  id SERIAL PRIMARY KEY,
  slug VARCHAR(64) UNIQUE NOT NULL,
  title VARCHAR(140) NOT NULL,
  category VARCHAR(64) NOT NULL,
  era_origin VARCHAR(80) NOT NULL,
  cost_per_sqft INT NOT NULL,
  biophilic_score INT NOT NULL,
  daylight_kelvin INT NOT NULL,
  likes_count INT DEFAULT 120,
  palette_hex JSONB NOT NULL,
  materials JSONB NOT NULL,
  summary TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS saved_projects (
  id SERIAL PRIMARY KEY,
  project_code VARCHAR(32) UNIQUE NOT NULL,
  project_name VARCHAR(160) NOT NULL,
  designer_name VARCHAR(120) NOT NULL,
  room_scene VARCHAR(80) NOT NULL,
  wall_finish VARCHAR(80) NOT NULL,
  floor_material VARCHAR(80) NOT NULL,
  lighting_preset VARCHAR(80) NOT NULL,
  accent_palette VARCHAR(80) NOT NULL,
  estimated_budget NUMERIC(12, 2) NOT NULL,
  area_sqft INT NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS moodboards (
  id SERIAL PRIMARY KEY,
  board_title VARCHAR(160) NOT NULL,
  niche_style VARCHAR(80) NOT NULL,
  swatches JSONB NOT NULL,
  materials JSONB NOT NULL,
  target_room VARCHAR(80) NOT NULL,
  client_name VARCHAR(120) DEFAULT 'Private Atelier Client',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS utility_calculations (
  id SERIAL PRIMARY KEY,
  calc_type VARCHAR(64) NOT NULL,
  room_label VARCHAR(120) NOT NULL,
  inputs_json JSONB NOT NULL,
  outputs_json JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Initial Seed Rows for Saved Projects
INSERT INTO saved_projects (project_code, project_name, designer_name, room_scene, wall_finish, floor_material, lighting_preset, accent_palette, estimated_budget, area_sqft, notes)
VALUES
  ('INT-9041', 'Kyoto Nord Residence Living Wing', 'Elena Rostova, AIA', 'Japandi Living Sanctuary', 'Alabaster Limewash', 'Bleached Chevron Oak', 'Morning Daylight (5500K)', 'Travertine & Raw Boucle', 48500.00, 420, 'Custom quarter-sawn white oak acoustic slat partition with honed Roman travertine monolith table.'),
  ('INT-9042', 'Avenue Montaigne Haussmann Salon', 'Henri Laurent Studio', 'Parisian Haussmann Salon', 'Parisian Chalk White', 'Bleached Chevron Oak', 'Golden Hour Sunbeam (3200K)', 'Champagne Brass & Ivory Velvet', 74200.00, 560, 'Restored 19th-century plaster boiserie paired with curved ivory bouclé seating and alabaster hearth.'),
  ('INT-9043', 'Mallorca Limestone Atrium', 'Clara Soler Atelier', 'Mediterranean Coastal Villa', 'Warm Venetian Plaster', 'Honed Roman Travertine', 'Gallery Skylight (4500K)', 'Terracotta & Raw Linen', 62800.00, 610, 'Vaulted lime-plaster arches with hand-thrown terracotta vessels and modular Belgian linen daybeds.')
ON CONFLICT (project_code) DO NOTHING;
