const express  = require('express');
const router   = express.Router();
const oracledb = require('oracledb');
const db       = require('../db');

// POST record a ball — calls sp_record_ball stored procedure
router.post('/ball', async (req, res) => {
  const {
    over_id, ball_number, batsman_id, non_striker_id, bowler_id,
    runs_scored, extra_runs, extra_type, is_wicket, is_extra,
    dismissal_type, fielder_id
  } = req.body;

  try {
    const result = await db.callProc(
      `BEGIN sp_record_ball(
         :over_id,:ball_number,:batsman_id,:non_striker_id,:bowler_id,
         :runs_scored,:extra_runs,:extra_type,:is_wicket,:is_extra,
         :dismissal_type,:fielder_id,:p_message
       ); END;`,
      {
        over_id:        { val: over_id,               dir: oracledb.BIND_IN },
        ball_number:    { val: ball_number,            dir: oracledb.BIND_IN },
        batsman_id:     { val: batsman_id,             dir: oracledb.BIND_IN },
        non_striker_id: { val: non_striker_id,         dir: oracledb.BIND_IN },
        bowler_id:      { val: bowler_id,              dir: oracledb.BIND_IN },
        runs_scored:    { val: runs_scored    || 0,    dir: oracledb.BIND_IN },
        extra_runs:     { val: extra_runs     || 0,    dir: oracledb.BIND_IN },
        extra_type:     { val: extra_type     || null, dir: oracledb.BIND_IN },
        is_wicket:      { val: is_wicket      || 'N',  dir: oracledb.BIND_IN },
        is_extra:       { val: is_extra       || 'N',  dir: oracledb.BIND_IN },
        dismissal_type: { val: dismissal_type || null, dir: oracledb.BIND_IN },
        fielder_id:     { val: fielder_id     || null, dir: oracledb.BIND_IN },
        p_message: {
          dir: oracledb.BIND_OUT,
          type: oracledb.STRING,
          maxSize: 500
        }
      }
    );
    const message = result.outBinds.p_message;
    if (message && message.startsWith('ERROR')) {
      return res.status(400).json({ error: message });
    }
    res.json({ message, success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET current over details
router.get('/over/:over_id', async (req, res) => {
  try {
    const over = await db.query(
      `SELECT o.over_number, o.runs_in_over, o.wickets_in_over,
              o.is_maiden, p.player_name AS bowler
       FROM Overs o JOIN Players p ON o.bowler_id = p.player_id
       WHERE o.over_id = :1`, [req.params.over_id]
    );
    const balls = await db.query(
      `SELECT b.ball_number, b.runs_scored, b.extra_runs,
              b.extra_type, b.is_wicket, b.is_extra, b.is_boundary,
              bat.player_name  AS batsman,
              bowl.player_name AS bowler
       FROM Balls b
       JOIN Players bat  ON b.batsman_id = bat.player_id
       JOIN Players bowl ON b.bowler_id  = bowl.player_id
       WHERE b.over_id = :1 ORDER BY b.ball_number`, [req.params.over_id]
    );
    res.json({ over: over.rows[0], balls: balls.rows });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

// POST enter full past match data
router.post('/past-match', async (req, res) => {
  const { match_id, innings } = req.body;
  try {
    for (const inn of innings) {
      await db.execute(
        `INSERT INTO Innings (
           inning_id, match_id, inning_number, batting_team_id, bowling_team_id,
           total_runs, total_wickets, completed_overs, balls_in_current_over, extras_total
         ) VALUES (SEQ_INNING.NEXTVAL,:1,:2,:3,:4,:5,:6,:7,:8,:9)`,
        [match_id, inn.inning_number, inn.batting_team_id, inn.bowling_team_id,
         inn.total_runs, inn.total_wickets, inn.completed_overs,
         inn.balls_in_current_over||0, inn.extras_total||0]
      );

      const innIdRes = await db.query(`SELECT SEQ_INNING.CURRVAL AS iid FROM DUAL`);
      const inning_id = innIdRes.rows[0].IID;

      for (let i = 0; i < inn.batting.length; i++) {
        const b = inn.batting[i];
        await db.execute(
          `INSERT INTO Batting_Scorecard (
             scorecard_id,inning_id,player_id,batting_position,
             runs,balls,fours,sixes,out_status,dismissal_type,
             fielder_id,dismissal_bowler_id
           ) VALUES (SEQ_BSC.NEXTVAL,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11)`,
          [inning_id, b.player_id, i+1, b.runs, b.balls,
           b.fours||0, b.sixes||0, b.out_status||'Not Out',
           b.dismissal_type||null, b.fielder_id||null, b.dismissal_bowler_id||null]
        );
      }

      for (const bwl of inn.bowling) {
        await db.execute(
          `INSERT INTO Bowling_Scorecard (
             bowling_id,inning_id,player_id,overs,balls_bowled,
             runs_conceded,wickets,maidens,wides,no_balls
           ) VALUES (SEQ_BLSC.NEXTVAL,:1,:2,:3,:4,:5,:6,:7,:8,:9)`,
          [inning_id, bwl.player_id, bwl.overs, bwl.balls_bowled||0,
           bwl.runs_conceded, bwl.wickets||0, bwl.maidens||0,
           bwl.wides||0, bwl.no_balls||0]
        );
      }
    }
    res.status(201).json({ message: 'Past match data saved' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;