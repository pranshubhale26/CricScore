-- ============================================================
-- CRICKET SCORING SYSTEM — SAMPLE DATA
-- User: cricket | DB: XEPDB1
-- Real match data: IND vs AUS, ENG vs AUS, IND vs AUS T20
-- ============================================================

-- ============================================================
-- TEAMS
-- ============================================================
INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL, 'India',        'India',        'Rahul Dravid',     'Wankhede Stadium',        1932);
INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL, 'Australia',    'Australia',    'Andrew McDonald',  'Melbourne Cricket Ground', 1877);
INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL, 'England',      'England',      'Brendon McCullum', 'Lords Cricket Ground',     1877);
INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL, 'Pakistan',     'Pakistan',     'Grant Bradburn',   'National Stadium Karachi', 1952);
INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL, 'South Africa', 'South Africa', 'Shukri Conrad',    'Newlands Cricket Ground',  1889);
INSERT INTO Teams VALUES (SEQ_TEAM.NEXTVAL, 'New Zealand',  'New Zealand',  'Gary Stead',       'Eden Park',                1894);

-- ============================================================
-- VENUES
-- ============================================================
INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL, 'Wankhede Stadium',        'Mumbai',    'India',     33108,  'Flat');
INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL, 'Melbourne Cricket Ground', 'Melbourne', 'Australia', 100024, 'Bouncy');
INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL, 'Lords Cricket Ground',     'London',    'England',   28000,  'Seam-friendly');
INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL, 'Eden Gardens',             'Kolkata',   'India',     66349,  'Flat');
INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL, 'The Oval',                 'London',    'England',   25500,  'Seam-friendly');
INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL, 'Sydney Cricket Ground',    'Sydney',    'Australia', 48000,  'Spin-friendly');

-- ============================================================
-- PLAYERS — India (player_id 1-11)
-- ============================================================
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Rohit Sharma',    'Batsman',      'Right-hand', NULL,                   45, TO_DATE('30-APR-1987','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Shubman Gill',    'Batsman',      'Right-hand', NULL,                   77, TO_DATE('08-SEP-1999','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Virat Kohli',     'Batsman',      'Right-hand', NULL,                   18, TO_DATE('05-NOV-1988','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Shreyas Iyer',    'Batsman',      'Right-hand', NULL,                   41, TO_DATE('06-DEC-1994','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'KL Rahul',        'Wicket-Keeper','Right-hand', NULL,                   1,  TO_DATE('18-APR-1992','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Hardik Pandya',   'All-Rounder',  'Right-hand', 'Right-arm Medium',     33, TO_DATE('11-OCT-1993','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Ravindra Jadeja', 'All-Rounder',  'Left-hand',  'Left-arm Spin',        8,  TO_DATE('06-DEC-1988','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Mohammed Shami',  'Bowler',       'Right-hand', 'Right-arm Fast',       11, TO_DATE('03-SEP-1990','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Jasprit Bumrah',  'Bowler',       'Right-hand', 'Right-arm Fast',       93, TO_DATE('06-DEC-1993','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Kuldeep Yadav',   'Bowler',       'Left-hand',  'Left-arm Wrist Spin',  23, TO_DATE('14-DEC-1994','DD-MON-YYYY'), 'Indian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Mohammed Siraj',  'Bowler',       'Right-hand', 'Right-arm Fast',       13, TO_DATE('13-MAR-1994','DD-MON-YYYY'), 'Indian', 'Y');

-- PLAYERS — Australia (player_id 12-22)
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'David Warner',      'Batsman',      'Left-hand',  NULL,                    31, TO_DATE('27-OCT-1986','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Travis Head',       'Batsman',      'Left-hand',  'Right-arm Off-spin',    35, TO_DATE('29-DEC-1993','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Steven Smith',      'Batsman',      'Right-hand', 'Right-arm Leg-spin',    49, TO_DATE('02-JUN-1989','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Marnus Labuschagne','Batsman',      'Right-hand', 'Right-arm Leg-spin',    70, TO_DATE('22-JUN-1994','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Mitchell Marsh',    'All-Rounder',  'Right-hand', 'Right-arm Medium',      8,  TO_DATE('20-OCT-1991','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Alex Carey',        'Wicket-Keeper','Left-hand',  NULL,                    36, TO_DATE('27-AUG-1991','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Pat Cummins',       'Bowler',       'Right-hand', 'Right-arm Fast',        30, TO_DATE('08-MAY-1993','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Mitchell Starc',    'Bowler',       'Left-hand',  'Left-arm Fast',         56, TO_DATE('30-JAN-1990','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Josh Hazlewood',    'Bowler',       'Right-hand', 'Right-arm Fast',        38, TO_DATE('08-JAN-1991','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Adam Zampa',        'Bowler',       'Right-hand', 'Right-arm Leg-spin',    45, TO_DATE('31-MAR-1992','DD-MON-YYYY'), 'Australian', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 2, 'Glenn Maxwell',     'All-Rounder',  'Right-hand', 'Right-arm Off-spin',    32, TO_DATE('14-OCT-1988','DD-MON-YYYY'), 'Australian', 'Y');

-- PLAYERS — England (player_id 23-28)
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 3, 'Joe Root',       'Batsman',      'Right-hand', 'Right-arm Off-spin', 66, TO_DATE('30-DEC-1990','DD-MON-YYYY'), 'English', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 3, 'Ben Stokes',     'All-Rounder',  'Left-hand',  'Right-arm Fast',     55, TO_DATE('04-JUN-1991','DD-MON-YYYY'), 'English', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 3, 'Jonny Bairstow', 'Wicket-Keeper','Right-hand', NULL,                 46, TO_DATE('26-SEP-1989','DD-MON-YYYY'), 'English', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 3, 'James Anderson', 'Bowler',       'Right-hand', 'Right-arm Seam',     9,  TO_DATE('30-JUL-1982','DD-MON-YYYY'), 'English', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 3, 'Stuart Broad',   'Bowler',       'Right-hand', 'Right-arm Seam',     16, TO_DATE('24-JUN-1986','DD-MON-YYYY'), 'English', 'Y');
INSERT INTO Players VALUES (SEQ_PLAYER.NEXTVAL, 3, 'Moeen Ali',      'All-Rounder',  'Left-hand',  'Right-arm Off-spin', 18, TO_DATE('18-JUN-1987','DD-MON-YYYY'), 'English', 'Y');

-- ============================================================
-- SERIES
-- ============================================================
INSERT INTO Series VALUES (SEQ_SERIES.NEXTVAL, 'ICC Cricket World Cup 2023',         'Tournament', 'ODI',   TO_DATE('05-OCT-2023','DD-MON-YYYY'), TO_DATE('19-NOV-2023','DD-MON-YYYY'), 'India');
INSERT INTO Series VALUES (SEQ_SERIES.NEXTVAL, 'India vs Australia ODI Series 2023', 'Bilateral',  'ODI',   TO_DATE('01-SEP-2023','DD-MON-YYYY'), TO_DATE('10-SEP-2023','DD-MON-YYYY'), 'India');
INSERT INTO Series VALUES (SEQ_SERIES.NEXTVAL, 'The Ashes 2023',                     'Bilateral',  'Test',  TO_DATE('16-JUN-2023','DD-MON-YYYY'), TO_DATE('31-JUL-2023','DD-MON-YYYY'), 'England');

-- ============================================================
-- MATCHES
-- ============================================================
-- Match 1: IND vs AUS ODI World Cup Final
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 1, 1, 2, 1, TO_DATE('19-NOV-2023','DD-MON-YYYY'), 'ODI',  'Completed', 2, 'Bat',   1,  18, 1);
-- Match 2: ENG vs AUS Test (Ashes)
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 3, 3, 2, 3, TO_DATE('16-JUN-2023','DD-MON-YYYY'), 'Test', 'Completed', 3, 'Field', 23, 18, 2);
-- Match 3: IND vs AUS T20
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 2, 1, 2, 4, TO_DATE('02-SEP-2023','DD-MON-YYYY'), 'T20',  'Completed', 1, 'Bat',   1,  18, 3);

-- ============================================================
-- SERIES_MATCHES
-- ============================================================
INSERT INTO Series_Matches VALUES (SEQ_SERIES_M.NEXTVAL, 1, 1);
INSERT INTO Series_Matches VALUES (SEQ_SERIES_M.NEXTVAL, 3, 2);
INSERT INTO Series_Matches VALUES (SEQ_SERIES_M.NEXTVAL, 2, 3);

-- ============================================================
-- INNINGS
-- Match 1: AUS bat first, IND chase
-- ============================================================
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 1, 1, 2, 1, 240, 10, 49, 4, 15, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 1, 2, 1, 2, 241, 6,  42, 2, 8,  'N', 241);
-- Match 2: AUS bat first, ENG chase
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 2, 1, 2, 3, 393, 10, 90, 0, 22, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 2, 2, 3, 2, 325, 8,  88, 2, 14, 'Y', NULL);
-- Match 3: IND bat first, AUS chase
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 3, 1, 1, 2, 176, 4,  20, 0, 11, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 3, 2, 2, 1, 169, 10, 19, 3, 13, 'N', 177);

-- ============================================================
-- OVERS (sample overs for innings 1 and 2)
-- ============================================================
-- Inning 1 overs (AUS batting, IND bowling)
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 1, 1,  9,  6,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 1, 2,  11, 4,  1, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 1, 3,  9,  8,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 1, 4,  8,  3,  0, 'Y');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 1, 5,  11, 12, 1, 'N');
-- Inning 2 overs (IND batting, AUS bowling)
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 2, 1,  18, 8,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 2, 2,  19, 6,  0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 2, 3,  18, 4,  1, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 2, 4,  21, 12, 0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 2, 5,  22, 5,  0, 'Y');
-- Inning 5 overs (IND T20 batting)
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 5, 1,  18, 12, 0, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 5, 2,  19, 8,  1, 'N');
INSERT INTO Overs VALUES (SEQ_OVER.NEXTVAL, 5, 3,  21, 7,  0, 'N');

-- ============================================================
-- BALLS (sample balls for overs 1 and 2)
-- ============================================================
-- Over 1 balls
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 1, 1, 12, 13, 9,  4, 0, NULL,   'N', 'N', 'Y');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 1, 2, 12, 13, 9,  0, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 1, 3, 12, 13, 9,  1, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 1, 4, 13, 12, 9,  0, 1, 'Wide', 'N', 'Y', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 1, 5, 13, 12, 9,  0, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 1, 6, 13, 12, 9,  6, 0, NULL,   'N', 'N', 'Y');
-- Over 2 balls
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 2, 1, 14, 12, 11, 0, 0, NULL,   'Y', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 2, 2, 13, 12, 11, 4, 0, NULL,   'N', 'N', 'Y');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 2, 3, 13, 12, 11, 0, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 2, 4, 13, 12, 11, 0, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 2, 5, 13, 12, 11, 0, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 2, 6, 13, 12, 11, 0, 0, NULL,   'N', 'N', 'N');
-- Inning 2 over 1 balls (IND batting)
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 6, 1, 1,  2,  18, 6, 0, NULL,   'N', 'N', 'Y');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 6, 2, 1,  2,  18, 0, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 6, 3, 1,  2,  18, 4, 0, NULL,   'N', 'N', 'Y');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 6, 4, 2,  1,  18, 1, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 6, 5, 1,  2,  18, 1, 0, NULL,   'N', 'N', 'N');
INSERT INTO Balls VALUES (SEQ_BALL.NEXTVAL, 6, 6, 2,  1,  18, 2, 0, NULL,   'N', 'N', 'N');

-- ============================================================
-- BATTING SCORECARD
-- ============================================================
-- Match 1 Inning 1 (AUS batting)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 12, 1,  47,  53, 3, 1, 'Out',     'Bowled',   NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 13, 2,  137, 120,15, 4, 'Out',     'Caught',   3,    11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 14, 3,  4,   11, 0, 0, 'Out',     'LBW',      NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 15, 4,  0,   1,  0, 0, 'Out',     'Caught',   3,    11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 16, 5,  15,  20, 1, 0, 'Out',     'Run Out',  3,    NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 22, 6,  0,   5,  0, 0, 'Out',     'Bowled',   NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 17, 7,  12,  18, 1, 0, 'Out',     'Caught',   7,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 19, 8,  9,   12, 0, 0, 'Out',     'Bowled',   NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 20, 9,  0,   3,  0, 0, 'Out',     'Caught',   5,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 18, 10, 8,   13, 0, 0, 'Out',     'Caught',   9,    11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 1, 21, 11, 0,   2,  0, 0, 'Out',     'Bowled',   NULL, 8);

-- Match 1 Inning 2 (IND batting)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 1,  1,  47,  56, 6, 0, 'Out',     'Caught',   16,   18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 2,  2,  4,   9,  0, 0, 'Out',     'Bowled',   NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 3,  3,  54,  63, 6, 0, 'Out',     'LBW',      NULL, 20);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 4,  4,  4,   8,  0, 0, 'Out',     'Caught',   14,   18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 5,  5,  66,  72, 8, 1, 'Not Out', NULL,       NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 6,  6,  42,  39, 4, 1, 'Not Out', NULL,       NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 2, 7,  7,  9,   10, 1, 0, 'Out',     'Run Out',  18,   NULL);

-- Match 3 Inning 1 (IND T20 batting)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 5, 1,  1,  56,  36, 5, 3, 'Out',     'Caught',   22,   20);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 5, 2,  2,  11,  14, 1, 0, 'Out',     'Bowled',   NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 5, 3,  3,  72,  44, 7, 3, 'Not Out', NULL,       NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 5, 6,  4,  22,  15, 2, 1, 'Out',     'Caught',   17,   18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 5, 7,  5,  15,  10, 1, 1, 'Not Out', NULL,       NULL, NULL);

-- Match 3 Inning 2 (AUS T20 batting)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 12, 1,  44,  32, 4, 2, 'Out',     'Caught',   1,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 13, 2,  28,  24, 3, 1, 'Out',     'Bowled',   NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 14, 3,  32,  25, 3, 1, 'Out',     'LBW',      NULL, 11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 22, 4,  19,  18, 1, 1, 'Out',     'Stumped',  5,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 16, 5,  18,  17, 2, 0, 'Out',     'Caught',   7,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 17, 6,  14,  14, 1, 0, 'Out',     'Run Out',  3,    NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 19, 7,  9,   12, 0, 0, 'Out',     'Caught',   6,    8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 18, 8,  3,   5,  0, 0, 'Out',     'Bowled',   NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 20, 9,  2,   4,  0, 0, 'Out',     'Caught',   1,    11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 6, 21, 10, 0,   3,  0, 0, 'Out',     'Bowled',   NULL, 8);

-- ============================================================
-- BOWLING SCORECARD
-- ============================================================
-- Match 1 Inning 1 (IND bowling)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 1, 8,  9,  0, 43, 2, 0, 2, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 1, 9,  9,  0, 48, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 1, 10, 10, 0, 54, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 1, 11, 10, 0, 55, 2, 0, 3, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 1, 7,  7,  0, 33, 1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 1, 6,  4,  0, 22, 2, 0, 1, 1);
-- Match 1 Inning 2 (AUS bowling)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 2, 18, 9,  0, 55, 2, 0, 2, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 2, 19, 9,  0, 44, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 2, 20, 9,  0, 56, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 2, 21, 8,  0, 50, 0, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 2, 22, 7,  0, 36, 2, 1, 0, 0);
-- Match 3 Inning 2 (IND bowling vs AUS T20)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 6, 9,  4,  0, 28, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 6, 8,  4,  0, 32, 2, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 6, 11, 4,  0, 38, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 6, 10, 4,  0, 42, 1, 0, 0, 1);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 6, 7,  4,  0, 29, 2, 0, 0, 0);

-- ============================================================
-- MATCH RESULTS
-- ============================================================
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 1, 1, 6, 'Wickets', 3,  'India won by 6 wickets to claim ICC World Cup 2023');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 2, 2, 2, 'Wickets', 23, 'Australia won by 2 wickets in thrilling Ashes Test');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 3, 1, 7, 'Runs',    3,  'India defended 176 to win T20 by 7 runs');

COMMIT;

-- Verify all tables have data
SELECT 'Teams'             AS tbl, COUNT(*) AS cnt FROM Teams            UNION ALL
SELECT 'Venues',                   COUNT(*)        FROM Venues            UNION ALL
SELECT 'Players',                  COUNT(*)        FROM Players           UNION ALL
SELECT 'Series',                   COUNT(*)        FROM Series            UNION ALL
SELECT 'Matches',                  COUNT(*)        FROM Matches           UNION ALL
SELECT 'Series_Matches',           COUNT(*)        FROM Series_Matches    UNION ALL
SELECT 'Innings',                  COUNT(*)        FROM Innings           UNION ALL
SELECT 'Overs',                    COUNT(*)        FROM Overs             UNION ALL
SELECT 'Balls',                    COUNT(*)        FROM Balls             UNION ALL
SELECT 'Batting_Scorecard',        COUNT(*)        FROM Batting_Scorecard UNION ALL
SELECT 'Bowling_Scorecard',        COUNT(*)        FROM Bowling_Scorecard UNION ALL
SELECT 'Match_Result',             COUNT(*)        FROM Match_Result;