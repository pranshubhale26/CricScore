const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET all teams
router.get('/', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT t.team_id, t.team_name, t.country, t.coach,
             t.home_venue, t.founded_yr,
             COUNT(p.player_id) AS player_count
      FROM Teams t
      LEFT JOIN Players p ON t.team_id = p.team_id AND p.is_active = 'Y'
      GROUP BY t.team_id, t.team_name, t.country,
               t.coach, t.home_venue, t.founded_yr
      ORDER BY t.team_name
    `);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET single team with squad
router.get('/:id', async (req, res) => {
  try {
    const team = await db.query(
      `SELECT * FROM Teams WHERE team_id = :1`, [req.params.id]
    );
    if (!team.rows.length) return res.status(404).json({ error: 'Team not found' });

    const players = await db.query(
      `SELECT player_id, player_name, role, batting_style,
              bowling_style, jersey_number, is_active
       FROM Players WHERE team_id = :1
       ORDER BY role, player_name`, [req.params.id]
    );
    res.json({ ...team.rows[0], squad: players.rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST create team
router.post('/', async (req, res) => {
  const { team_name, country, coach, home_venue, founded_yr } = req.body;
  try {
    await db.execute(
      `INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL,:1,:2,:3,:4,:5)`,
      [team_name, country, coach||null, home_venue||null, founded_yr||null]
    );
    res.status(201).json({ message: 'Team created' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;