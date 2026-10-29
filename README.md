# Interio — Architectural Interior Design Platform (Netlify + NeonDB)

**Interio** is a light-themed, ultra-responsive architectural interior design platform built for hosting on **Netlify** with **NeonDB Serverless PostgreSQL** (`@neondatabase/serverless`).

## Key Capabilities
1. **Breathtaking HD Interior Showcase**: High-definition architectural photography with interactive material hotspots and real-time daylight temperature controls.
2. **Try It Out — Live Room Customizer Studio**: Customize wall finishes (Limewash, Venetian Plaster, Sage Clay, Terracotta Blush), flooring materials, lighting Kelvin atmospheres, interactive before/after split comparison slider, architectural grid overlays, and live project cost estimation.
3. **Curated Interior Design Niches**: Filterable library of signature architectural interior niches with copyable hex palettes, acoustic & biophilic ratings, and full specification sheets.
4. **Designer Utility Suite**:
   - **Space & Furniture Clearance Calculator** (Area, Volume, Rug Sizing, ADA 36" Walkways, HVAC BTU)
   - **Architectural Lighting & Lumen Estimator** (Foot-candles, Lumens, Kelvin, Recessed Layout)
   - **Paint, Limewash & Wallpaper Calculator** (Gallons, Primer, Rolls, Cost Estimate)
   - **Project Budget Allocator** with interactive Chart.js visualization
5. **2D Floorplan Studio & Moodboard Builder**: Interactive HTML5 Canvas floorplan layout tool with rotatable scaled furniture blocks and custom material moodboard curation.
6. **NeonDB Serverless PostgreSQL Integration**: Built-in Netlify Function (`/api/*` -> `/.netlify/functions/api`) + interactive **NeonDB Studio Inspector** with instant in-browser PostgreSQL state replica fallback.

## Quick Deployment to Netlify + NeonDB
1. Create a free serverless Postgres database at [neon.tech](https://neon.tech) and copy your pooled connection string (`DATABASE_URL`).
2. Run `schema.sql` in your Neon SQL Editor to initialize the `design_niches`, `saved_projects`, `moodboards`, and `utility_calculations` tables.
3. Deploy this directory to **Netlify** (drag-and-drop or connect via Git).
4. In **Netlify Site Configuration -> Environment Variables**, add `DATABASE_URL` with your Neon connection string.
