const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET all matches
router.get('/', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT * FROM vw_match_summary ORDER BY match_date DESC`
    );
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// GET single match with full scorecard
router.get('/:id', async (req, res) => {
  try {
    const match = await db.query(
      `SELECT * FROM vw_match_summary WHERE match_id = :1`, [req.params.id]
    );
    if (!match.rows.length) return res.status(404).json({ error: 'Match not found' });

    const innings = await db.query(
      `SELECT i.*, t.team_name AS batting_team, t2.team_name AS bowling_team
       FROM Innings i
       JOIN Teams t  ON i.batting_team_id = t.team_id
       JOIN Teams t2 ON i.bowling_team_id = t2.team_id
       WHERE i.match_id = :1 ORDER BY i.inning_number`, [req.params.id]
    );

    const inningsData = [];
    for (const inn of innings.rows) {
      const batting = await db.query(`
        SELECT p.player_name, bs.batting_position, bs.runs, bs.balls,
               bs.fours, bs.sixes, bs.out_status, bs.dismissal_type,
               f.player_name   AS fielder,
               bwl.player_name AS dismissal_bowler,
               ROUND(bs.runs * 100.0 / NULLIF(bs.balls,0), 2) AS strike_rate
        FROM Batting_Scorecard bs
        JOIN Players p    ON bs.player_id           = p.player_id
        LEFT JOIN Players f   ON bs.fielder_id      = f.player_id
        LEFT JOIN Players bwl ON bs.dismissal_bowler_id = bwl.player_id
        WHERE bs.inning_id = :1
        ORDER BY bs.batting_position`, [inn.INNING_ID]
      );

      const bowling = await db.query(`
        SELECT p.player_name, bwl.overs, bwl.runs_conceded,
               bwl.wickets, bwl.maidens, bwl.wides, bwl.no_balls,
               ROUND(bwl.runs_conceded / NULLIF(bwl.overs,0), 2) AS economy
        FROM Bowling_Scorecard bwl
        JOIN Players p ON bwl.player_id = p.player_id
        WHERE bwl.inning_id = :1
        ORDER BY bwl.overs DESC`, [inn.INNING_ID]
      );

      inningsData.push({ ...inn, batting: batting.rows, bowling: bowling.rows });
    }

    res.json({ ...match.rows[0], innings: inningsData });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST create match
router.post('/', async (req, res) => {
  const {
    team1_id, team2_id, venue_id, match_date,
    match_format, series_id, toss_winner_id,
    toss_decision, team1_captain_id, team2_captain_id
  } = req.body;
  try {
    await db.execute(
      `INSERT INTO Matches (
         match_id, series_id, team1_id, team2_id, venue_id,
         match_date, match_format, status,
         toss_winner_id, toss_decision,
         team1_captain_id, team2_captain_id
       ) VALUES (
         SEQ_MATCH.NEXTVAL,:1,:2,:3,:4,
         TO_DATE(:5,'YYYY-MM-DD'),:6,'Scheduled',
         :7,:8,:9,:10
       )`,
      [
        series_id||null, team1_id, team2_id, venue_id,
        match_date, match_format,
        toss_winner_id||null, toss_decision||null,
        team1_captain_id||null, team2_captain_id||null
      ]
    );
    const newId = await db.query(`SELECT SEQ_MATCH.CURRVAL AS match_id FROM DUAL`);
    res.status(201).json({ message: 'Match created', match_id: newId.rows[0].MATCH_ID });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// PATCH update match status
router.patch('/:id/status', async (req, res) => {
  try {
    await db.execute(
      `UPDATE Matches SET status = :1 WHERE match_id = :2`,
      [req.body.status, req.params.id]
    );
    res.json({ message: 'Status updated' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST record match result
router.post('/:id/result', async (req, res) => {
  const { winning_team_id, win_margin, win_margin_type, man_of_match, result_description } = req.body;
  try {
    await db.execute(
      `INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL,:1,:2,:3,:4,:5,:6)`,
      [req.params.id, winning_team_id||null, win_margin||null,
       win_margin_type||null, man_of_match||null, result_description||null]
    );
    res.status(201).json({ message: 'Result recorded' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;