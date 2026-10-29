import { neon } from '@neondatabase/serverless';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Neon-Connection',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Content-Type': 'application/json'
};

export async function handler(event) {
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers: corsHeaders, body: '' };
  }

  const dbUrl = event.headers['x-neon-connection'] || process.env.DATABASE_URL;
  const path = event.path.replace('/.netlify/functions/api', '').replace('/api', '') || '/health';

  if (!dbUrl) {
    return {
      statusCode: 200,
      headers: corsHeaders,
      body: JSON.stringify({
        ok: true,
        mode: 'local-replica-fallback',
        message: 'DATABASE_URL not set in environment; using Interio in-browser NeonDB state replica.',
        region: process.env.NEON_PROJECT_REGION || 'aws-us-east-2'
      })
    };
  }

  try {
    const sql = neon(dbUrl);

    if (path === '/health' && event.httpMethod === 'GET') {
      const start = Date.now();
      const versionRows = await sql`SELECT version(), current_database() AS db, current_user AS usr`;
      const latencyMs = Date.now() - start;
      return {
        statusCode: 200,
        headers: corsHeaders,
        body: JSON.stringify({
          ok: true,
          mode: 'neondb-serverless-live',
          latencyMs,
          info: versionRows[0]
        })
      };
    }

    if (path === '/projects' && event.httpMethod === 'GET') {
      const rows = await sql`SELECT * FROM saved_projects ORDER BY created_at DESC LIMIT 25`;
      return { statusCode: 200, headers: corsHeaders, body: JSON.stringify({ ok: true, rows }) };
    }

    if (path === '/projects' && event.httpMethod === 'POST') {
      const payload = JSON.parse(event.body || '{}');
      const inserted = await sql`
        INSERT INTO saved_projects (
          project_code, project_name, designer_name, room_scene,
          wall_finish, floor_material, lighting_preset, accent_palette,
          estimated_budget, area_sqft, notes
        ) VALUES (
          ${payload.project_code}, ${payload.project_name}, ${payload.designer_name || 'Lead Studio Designer'},
          ${payload.room_scene}, ${payload.wall_finish}, ${payload.floor_material},
          ${payload.lighting_preset}, ${payload.accent_palette},
          ${Number(payload.estimated_budget || 35000)}, ${Number(payload.area_sqft || 380)},
          ${payload.notes || ''}
        )
        RETURNING *
      `;
      return { statusCode: 201, headers: corsHeaders, body: JSON.stringify({ ok: true, project: inserted[0] }) };
    }

    if (path === '/calculations' && event.httpMethod === 'POST') {
      const payload = JSON.parse(event.body || '{}');
      const inserted = await sql`
        INSERT INTO utility_calculations (calc_type, room_label, inputs_json, outputs_json)
        VALUES (${payload.calc_type}, ${payload.room_label}, ${JSON.stringify(payload.inputs)}, ${JSON.stringify(payload.outputs)})
        RETURNING *
      `;
      return { statusCode: 201, headers: corsHeaders, body: JSON.stringify({ ok: true, calculation: inserted[0] }) };
    }

    return {
      statusCode: 200,
      headers: corsHeaders,
      body: JSON.stringify({ ok: true, path, status: 'NeonDB endpoint active' })
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: corsHeaders,
      body: JSON.stringify({ ok: false, error: err.message })
    };
  }
}
