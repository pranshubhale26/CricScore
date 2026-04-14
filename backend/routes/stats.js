const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET batting leaderboard
router.get('/batting', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT player_name, team_name, total_runs, highest_score,
             batting_avg, strike_rate, total_fours, total_sixes, innings_batted
      FROM vw_career_stats
      WHERE innings_batted > 0
      ORDER BY total_runs DESC
      FETCH FIRST 20 ROWS ONLY
    `);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET bowling leaderboard
router.get('/bowling', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT p.player_name, t.team_name,
             SUM(bwl.overs)         AS total_overs,
             SUM(bwl.runs_conceded) AS total_runs,
             SUM(bwl.wickets)       AS total_wickets,
             SUM(bwl.maidens)       AS total_maidens,
             ROUND(SUM(bwl.runs_conceded)/NULLIF(SUM(bwl.overs),0),2) AS economy,
             ROUND(SUM(bwl.runs_conceded)/NULLIF(SUM(bwl.wickets),0),2) AS bowling_avg
      FROM Bowling_Scorecard bwl
      JOIN Players p ON bwl.player_id = p.player_id
      JOIN Teams   t ON p.team_id     = t.team_id
      GROUP BY p.player_name, t.team_name
      HAVING SUM(bwl.wickets) > 0
      ORDER BY total_wickets DESC, economy ASC
      FETCH FIRST 20 ROWS ONLY
    `);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET team standings
router.get('/standings', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT t.team_name,
             COUNT(DISTINCT m.match_id) AS played,
             COUNT(DISTINCT mr.result_id) AS won,
             COUNT(DISTINCT m.match_id) - COUNT(DISTINCT mr.result_id) AS lost,
             ROUND(
               CASE WHEN COUNT(DISTINCT m.match_id) = 0 THEN 0
                    ELSE COUNT(DISTINCT mr.result_id) * 100.0 / COUNT(DISTINCT m.match_id)
               END, 1
             ) AS win_pct
      FROM Teams t
      LEFT JOIN Matches m ON (m.team1_id = t.team_id OR m.team2_id = t.team_id)
                         AND m.status = 'Completed'
      LEFT JOIN Match_Result mr ON m.match_id = mr.match_id
                               AND mr.winning_team_id = t.team_id
      GROUP BY t.team_name
      HAVING COUNT(DISTINCT m.match_id) > 0
      ORDER BY win_pct DESC, won DESC
    `);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET dashboard summary
router.get('/dashboard', async (req, res) => {
  try {
    const [teams, players, matches, venues, live] = await Promise.all([
      db.query(`SELECT COUNT(*) AS cnt FROM Teams`),
      db.query(`SELECT COUNT(*) AS cnt FROM Players WHERE is_active = 'Y'`),
      db.query(`SELECT COUNT(*) AS cnt FROM Matches`),
      db.query(`SELECT COUNT(*) AS cnt FROM Venues`),
      db.query(`SELECT COUNT(*) AS cnt FROM Matches WHERE status = 'Live'`),
    ]);

    const recent = await db.query(`
      SELECT match_id, match_date, match_format, status,
             team1, team2, winning_team, result_description
      FROM vw_match_summary
      ORDER BY match_date DESC
      FETCH FIRST 5 ROWS ONLY
    `);

    res.json({
      counts: {
        teams:   teams.rows[0].CNT,
        players: players.rows[0].CNT,
        matches: matches.rows[0].CNT,
        venues:  venues.rows[0].CNT,
        live:    live.rows[0].CNT,
      },
      recentMatches: recent.rows,
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET audit log
router.get('/audit', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT audit_id, table_name, operation, record_id,
             changed_by,
             TO_CHAR(changed_at,'DD-MON-YYYY HH24:MI:SS') AS changed_at,
             old_value, new_value, description
      FROM Audit_Log
      ORDER BY changed_at DESC
      FETCH FIRST 50 ROWS ONLY
    `);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;