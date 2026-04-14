const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET all players (optional ?team_id filter)
router.get('/', async (req, res) => {
  try {
    const { team_id } = req.query;
    let sql = `
      SELECT p.player_id, p.player_name, p.role, p.batting_style,
             p.bowling_style, p.jersey_number, p.is_active,
             t.team_name, t.country
      FROM Players p JOIN Teams t ON p.team_id = t.team_id
    `;
    const binds = [];
    if (team_id) { sql += ` WHERE p.team_id = :1`; binds.push(team_id); }
    sql += ` ORDER BY t.team_name, p.role, p.player_name`;
    const result = await db.query(sql, binds);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET player career stats
router.get('/:id/stats', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT * FROM vw_career_stats WHERE player_id = :1`, [req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Player not found' });
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST create player
router.post('/', async (req, res) => {
  const { team_id, player_name, role, batting_style, bowling_style, jersey_number } = req.body;
  try {
    await db.execute(
      `INSERT INTO Players
         (player_id,team_id,player_name,role,batting_style,bowling_style,jersey_number,is_active)
       VALUES (SEQ_PLAYER.NEXTVAL,:1,:2,:3,:4,:5,:6,'Y')`,
      [team_id, player_name, role, batting_style||null, bowling_style||null, jersey_number||null]
    );
    res.status(201).json({ message: 'Player created' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;