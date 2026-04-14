-- ============================================================
-- FIX: Add missing scorecard data for Match 2 (ENG vs AUS Ashes)
-- Innings 3 = AUS batting (inning_id = 3)
-- Innings 4 = ENG batting (inning_id = 4)
-- Run this in SQL*Plus as cricket user
-- ============================================================

-- ── OVERS for Inning 3 (AUS batting in Test) ─────────────────
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 3, 1,  26, 7,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 3, 2,  27, 5,  1, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 3, 3,  26, 9,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 3, 4,  27, 3,  0, 'Y');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 3, 5,  26, 11, 1, 'N');

-- ── OVERS for Inning 4 (ENG batting in Test) ─────────────────
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 4, 1,  18, 8,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 4, 2,  19, 6,  1, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 4, 3,  18, 4,  0, 'N');

-- ── BATTING SCORECARD — Inning 3 (AUS batting vs ENG) ────────
-- AUS players: Warner=12, Head=13, Smith=14, Labuschagne=15, Marsh=16
-- Carey=17, Cummins=18, Starc=19, Hazlewood=20, Zampa=21, Maxwell=22
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 12, 1,  60,  110, 8, 0, 'Out',     'Caught',   24, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 13, 2,  82,  140, 9, 2, 'Out',     'Bowled',   NULL,27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 14, 3,  110, 220,12, 1, 'Out',     'LBW',      NULL,26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 15, 4,  44,  90, 5, 0, 'Out',     'Caught',   23, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 16, 5,  36,  58, 4, 0, 'Out',     'Caught',   25, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 22, 6,  21,  40, 2, 1, 'Out',     'Stumped',  25, 28);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 17, 7,  18,  35, 2, 0, 'Out',     'Caught',   24, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 18, 8,  10,  22, 1, 0, 'Out',     'Bowled',   NULL,27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 19, 9,  6,   14, 0, 0, 'Out',     'Caught',   23, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 20, 10, 4,   10, 0, 0, 'Out',     'Bowled',   NULL,27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 3, 21, 11, 2,   8,  0, 0, 'Out',     'LBW',      NULL,26);

-- ── BATTING SCORECARD — Inning 4 (ENG batting vs AUS) ────────
-- ENG players: Root=23, Stokes=24, Bairstow=25, Anderson=26, Broad=27, Ali=28
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 23, 1,  112, 210,14, 1, 'Not Out', NULL,       NULL,NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 24, 2,  85,  160, 9, 2, 'Out',     'Caught',   12, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 25, 3,  42,  90,  5, 0, 'Out',     'LBW',      NULL,19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 28, 4,  35,  75,  3, 1, 'Out',     'Caught',   15, 21);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 26, 5,  18,  45,  2, 0, 'Out',     'Bowled',   NULL,18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 27, 6,  14,  38,  1, 0, 'Out',     'Caught',   13, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 23, 7,  9,   25,  0, 0, 'Out',     'Run Out',  16, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 4, 24, 8,  10,  30,  1, 0, 'Not Out', NULL,       NULL,NULL);

-- ── BOWLING SCORECARD — Inning 3 (ENG bowling vs AUS) ────────
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 3, 26, 22, 0, 88,  4, 1, 2, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 3, 27, 22, 0, 95,  3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 3, 24, 18, 0, 78,  2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 3, 28, 18, 0, 82,  1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 3, 23, 10, 0, 50,  0, 0, 0, 0);

-- ── BOWLING SCORECARD — Inning 4 (AUS bowling vs ENG) ────────
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 4, 18, 22, 0, 80,  3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 4, 19, 22, 0, 75,  2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 4, 20, 20, 0, 70,  1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 4, 21, 18, 0, 68,  2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 4, 22, 6,  0, 32,  0, 0, 0, 0);

COMMIT;

-- Verify
SELECT i.inning_id, i.inning_number, t.team_name AS batting_team,
       i.total_runs, i.total_wickets,
       COUNT(bs.scorecard_id) AS batsmen_entered,
       COUNT(bwl.bowling_id)  AS bowlers_entered
FROM Innings i
JOIN Teams t ON i.batting_team_id = t.team_id
LEFT JOIN Batting_Scorecard bs ON i.inning_id = bs.inning_id
LEFT JOIN Bowling_Scorecard bwl ON i.inning_id = bwl.inning_id
WHERE i.match_id = 2
GROUP BY i.inning_id, i.inning_number, t.team_name, i.total_runs, i.total_wickets
ORDER BY i.inning_number;