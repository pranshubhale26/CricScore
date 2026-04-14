const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET live scorecard for a match
router.get('/match/:match_id', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT * FROM vw_live_scorecard WHERE match_id = :1 ORDER BY inning_number`,
      [req.params.match_id]
    );
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST start a new inning
router.post('/', async (req, res) => {
  const { match_id, inning_number, batting_team_id, bowling_team_id } = req.body;
  try {
    await db.execute(
      `INSERT INTO Innings (
         inning_id, match_id, inning_number,
         batting_team_id, bowling_team_id,
         total_runs, total_wickets, completed_overs,
         balls_in_current_over, extras_total
       ) VALUES (SEQ_INNING.NEXTVAL,:1,:2,:3,:4,0,0,0,0,0)`,
      [match_id, inning_number, batting_team_id, bowling_team_id]
    );
    await db.execute(
      `UPDATE Matches SET status = 'Live' WHERE match_id = :1`, [match_id]
    );
    const newId = await db.query(`SELECT SEQ_INNING.CURRVAL AS inning_id FROM DUAL`);
    res.status(201).json({ message: 'Inning started', inning_id: newId.rows[0].INNING_ID });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST start a new over
router.post('/:inning_id/overs', async (req, res) => {
  const { bowler_id, over_number } = req.body;
  try {
    await db.execute(
      `INSERT INTO Overs
         (over_id, inning_id, over_number, bowler_id, runs_in_over, wickets_in_over, is_maiden)
       VALUES (SEQ_OVER.NEXTVAL,:1,:2,:3,0,0,'N')`,
      [req.params.inning_id, over_number, bowler_id]
    );
    // Init bowling scorecard entry if not exists
    await db.execute(
      `MERGE INTO Bowling_Scorecard bsc
       USING (SELECT :1 AS iid, :2 AS pid FROM DUAL) src
       ON (bsc.inning_id = src.iid AND bsc.player_id = src.pid)
       WHEN NOT MATCHED THEN
         INSERT (bowling_id,inning_id,player_id,overs,balls_bowled,
                 runs_conceded,wickets,maidens,wides,no_balls)
         VALUES (SEQ_BLSC.NEXTVAL,:1,:2,0,0,0,0,0,0,0)`,
      [req.params.inning_id, bowler_id]
    );
    const newId = await db.query(`SELECT SEQ_OVER.CURRVAL AS over_id FROM DUAL`);
    res.status(201).json({ message: 'Over started', over_id: newId.rows[0].OVER_ID });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST add batsman to scorecard
router.post('/:inning_id/batsmen', async (req, res) => {
  const { player_id, batting_position } = req.body;
  try {
    await db.execute(
      `INSERT INTO Batting_Scorecard
         (scorecard_id,inning_id,player_id,batting_position,
          runs,balls,fours,sixes,out_status)
       VALUES (SEQ_BSC.NEXTVAL,:1,:2,:3,0,0,0,0,'Not Out')`,
      [req.params.inning_id, player_id, batting_position]
    );
    res.status(201).json({ message: 'Batsman added' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;