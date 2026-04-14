-- ============================================================
-- PART 2: BATTING + BOWLING SCORECARDS
-- Using exact inning IDs from your database:
-- Match 7  (AUS vs ENG ODI):        47, 48
-- Match 11 (IND vs ENG Test 1):     39, 40, 41
-- Match 12 (IND vs ENG Test 2):     42, 43, 44
-- Match 13 (IND vs ENG T20 WC):     45, 46
-- Match 14 (PAK vs NZ ODI):         49, 50
-- Match 15 (SA vs IND T20):         51, 52
-- Match 16 (AUS vs NZ T20 WC):      53, 54
-- Teams: 1=IND, 2=AUS, 3=ENG, 4=PAK, 5=SA, 6=NZ
-- IND players: 1-11, AUS: 12-22, ENG: 23-28
-- ============================================================

-- ============================================================
-- MATCH 7: AUS vs ENG ODI (Ashes series)
-- Inning 47: AUS batting (vs ENG)
-- Inning 48: ENG batting (vs AUS)
-- ============================================================

-- Batting inn 47 (AUS)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 12, 1, 44,  60,  5, 0, 'Out',     'Caught',  23, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 13, 2, 72,  95,  8, 1, 'Out',     'Bowled',  NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 14, 3, 88,  110, 9, 2, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 15, 4, 32,  48,  3, 0, 'Out',     'LBW',     NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 16, 5, 18,  28,  2, 0, 'Out',     'Caught',  24, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 22, 6, 14,  18,  1, 1, 'Out',     'Bowled',  NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 17, 7, 6,   10,  0, 0, 'Out',     'Caught',  25, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 18, 8, 4,   6,   0, 0, 'Out',     'Bowled',  NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 47, 19, 9, 0,   2,   0, 0, 'Out',     'Bowled',  NULL, 26);

-- Bowling inn 47 (ENG bowling vs AUS)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 47, 26, 10, 0, 52, 3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 47, 27, 10, 0, 58, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 47, 24, 10, 0, 62, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 47, 28, 10, 0, 66, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 47, 23, 9,  0, 40, 0, 0, 0, 1);

-- Batting inn 48 (ENG)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 23, 1, 55,  80,  6, 0, 'Out',     'Caught',  12, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 24, 2, 78,  100, 8, 2, 'Out',     'LBW',     NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 25, 3, 34,  55,  3, 0, 'Out',     'Caught',  16, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 28, 4, 28,  42,  2, 1, 'Out',     'Bowled',  NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 26, 5, 18,  30,  1, 0, 'Out',     'Caught',  13, 20);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 27, 6, 12,  22,  1, 0, 'Out',     'Bowled',  NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 23, 7, 6,   12,  0, 0, 'Out',     'Caught',  15, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 48, 24, 8, 1,   6,   0, 0, 'Out',     'Bowled',  NULL, 18);

-- Bowling inn 48 (AUS bowling vs ENG)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 48, 18, 10, 0, 48, 3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 48, 19, 10, 0, 52, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 48, 20, 10, 0, 56, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 48, 21, 8,  0, 44, 1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 48, 22, 6,  0, 32, 1, 0, 0, 0);

COMMIT;

-- ============================================================
-- MATCH 11: IND vs ENG Test 1 (Hyderabad) — IND win by innings
-- Inning 39: ENG bat first
-- Inning 40: IND bat
-- Inning 41: ENG 2nd innings
-- ============================================================

-- Batting inn 39 (ENG 1st)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 23, 1,  28,  65,  3, 0, 'Out',     'LBW',     NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 24, 2,  70,  120, 8, 1, 'Out',     'Caught',  3,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 25, 3,  18,  45,  2, 0, 'Out',     'Stumped', 5,    7);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 28, 4,  52,  90,  5, 1, 'Out',     'Bowled',  NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 26, 5,  34,  70,  3, 0, 'Out',     'Caught',  7,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 27, 6,  14,  40,  1, 0, 'Out',     'Bowled',  NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 23, 7,  10,  28,  0, 0, 'Out',     'Caught',  3,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 24, 8,  8,   22,  0, 0, 'Out',     'LBW',     NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 25, 9,  6,   18,  0, 0, 'Out',     'Bowled',  NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 26, 10, 4,   12,  0, 0, 'Out',     'Caught',  2,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 39, 27, 11, 2,   8,   0, 0, 'Out',     'Bowled',  NULL, 7);

-- Bowling inn 39 (IND bowling vs ENG)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 39, 9,  18, 0, 54, 4, 0, 0, 1);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 39, 8,  18, 0, 62, 2, 0, 2, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 39, 10, 18, 0, 70, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 39, 7,  15, 0, 48, 1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 39, 11, 5,  0, 12, 1, 0, 0, 0);

-- Batting inn 40 (IND)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 1,  1,  131, 190, 15, 2, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 2,  2,  104, 160, 12, 3, 'Out',     'Caught',  24,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 3,  3,  76,  120, 8,  1, 'Out',     'LBW',     NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 4,  4,  55,  90,  6,  0, 'Out',     'Caught',  25,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 5,  5,  42,  75,  4,  0, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 6,  6,  18,  35,  2,  0, 'Out',     'Bowled',  NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 40, 7,  7,  10,  20,  1,  0, 'Out',     'Caught',  23,   26);

-- Bowling inn 40 (ENG bowling vs IND)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 40, 26, 25, 0, 95,  3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 40, 27, 24, 0, 88,  2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 40, 24, 22, 0, 112, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 40, 28, 18, 0, 95,  0, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 40, 23, 9,  0, 46,  0, 0, 0, 0);

-- Batting inn 41 (ENG 2nd innings)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 23, 1,  22,  58,  2, 0, 'Out',     'Bowled',  NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 24, 2,  35,  70,  4, 0, 'Out',     'Caught',  3,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 25, 3,  18,  45,  1, 0, 'Out',     'LBW',     NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 28, 4,  14,  40,  1, 0, 'Out',     'Caught',  7,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 26, 5,  10,  30,  0, 0, 'Out',     'Bowled',  NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 27, 6,  6,   20,  0, 0, 'Out',     'Caught',  2,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 23, 7,  4,   14,  0, 0, 'Out',     'Bowled',  NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 24, 8,  2,   10,  0, 0, 'Out',     'LBW',     NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 25, 9,  1,   6,   0, 0, 'Out',     'Caught',  1,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 26, 10, 0,   4,   0, 0, 'Out',     'Bowled',  NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 41, 27, 11, 0,   2,   0, 0, 'Out',     'Bowled',  NULL, 10);

-- Bowling inn 41 (IND bowling vs ENG 2nd)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 41, 9,  12, 0, 38, 4, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 41, 10, 12, 0, 34, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 41, 8,  10, 0, 22, 2, 1, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 41, 7,  8,  0, 18, 1, 0, 0, 0);

COMMIT;

-- ============================================================
-- MATCH 12: IND vs ENG Test 2 (Vizag) — ENG win
-- Inning 42: IND bat first
-- Inning 43: ENG bat
-- Inning 44: IND 2nd innings
-- ============================================================

-- Batting inn 42 (IND 1st)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 1,  1,  98,  180, 11, 1, 'Out',     'Caught',  24,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 2,  2,  55,  110, 6,  0, 'Out',     'LBW',     NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 3,  3,  88,  160, 10, 1, 'Out',     'Caught',  25,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 4,  4,  62,  120, 7,  0, 'Out',     'Bowled',  NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 5,  5,  44,  90,  5,  0, 'Out',     'Caught',  23,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 6,  6,  28,  55,  3,  0, 'Out',     'Bowled',  NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 7,  7,  14,  30,  1,  0, 'Out',     'Caught',  24,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 8,  8,  5,   12,  0,  0, 'Out',     'Bowled',  NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 9,  9,  2,   8,   0,  0, 'Out',     'LBW',     NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 42, 10, 10, 0,   4,   0,  0, 'Out',     'Caught',  25,   27);

-- Bowling inn 42 (ENG bowling vs IND)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 42, 26, 22, 0, 95,  4, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 42, 27, 22, 0, 102, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 42, 24, 20, 0, 88,  2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 42, 28, 15, 0, 72,  1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 42, 23, 8,  0, 39,  0, 0, 0, 0);

-- Batting inn 43 (ENG)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 23, 1,  122, 230, 14, 2, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 24, 2,  95,  180, 10, 2, 'Out',     'Caught',  9,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 25, 3,  66,  130, 7,  0, 'Out',     'LBW',     NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 28, 4,  55,  110, 6,  1, 'Out',     'Caught',  7,    8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 26, 5,  44,  90,  4,  0, 'Out',     'Bowled',  NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 27, 6,  22,  50,  2,  0, 'Out',     'Caught',  3,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 43, 23, 7,  16,  35,  1,  0, 'Not Out', NULL,      NULL, NULL);

-- Bowling inn 43 (IND bowling vs ENG)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 43, 9,  22, 0, 88,  3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 43, 8,  22, 0, 95,  2, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 43, 10, 20, 0, 92,  2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 43, 7,  18, 0, 85,  1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 43, 11, 8,  0, 60,  0, 0, 0, 0);

-- Batting inn 44 (IND 2nd innings)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 1,  1,  42,  80,  5, 0, 'Out',     'Caught',  24,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 2,  2,  28,  60,  3, 0, 'Out',     'Bowled',  NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 3,  3,  22,  50,  2, 0, 'Out',     'LBW',     NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 4,  4,  18,  40,  2, 0, 'Out',     'Caught',  25,   27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 5,  5,  14,  35,  1, 0, 'Out',     'Bowled',  NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 6,  6,  10,  25,  1, 0, 'Out',     'Caught',  23,   27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 7,  7,  6,   18,  0, 0, 'Out',     'Bowled',  NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 8,  8,  3,   10,  0, 0, 'Out',     'LBW',     NULL, 27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 9,  9,  2,   8,   0, 0, 'Out',     'Caught',  24,   26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 44, 10, 10, 0,   4,   0, 0, 'Out',     'Bowled',  NULL, 27);

-- Bowling inn 44 (ENG bowling vs IND 2nd)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 44, 26, 14, 0, 42, 4, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 44, 27, 14, 0, 46, 3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 44, 24, 12, 0, 35, 2, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 44, 28, 8,  0, 22, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 44, 23, 3,  0, 0,  0, 1, 0, 0);

COMMIT;

-- ============================================================
-- MATCH 13: IND vs ENG T20 WC
-- Inning 45: IND batting
-- Inning 46: ENG batting
-- ============================================================

-- Batting inn 45 (IND)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 45, 1,  1, 76,  44,  7, 3, 'Out',     'Caught',  24,   27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 45, 2,  2, 23,  18,  2, 1, 'Out',     'Bowled',  NULL, 26);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 45, 3,  3, 38,  32,  4, 1, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 45, 6,  4, 22,  16,  1, 1, 'Out',     'Caught',  25,   27);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 45, 7,  5, 12,  10,  1, 0, 'Not Out', NULL,      NULL, NULL);

-- Bowling inn 45 (ENG bowling vs IND)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 45, 26, 4, 0, 32, 2, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 45, 27, 4, 0, 38, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 45, 24, 4, 0, 36, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 45, 28, 4, 0, 34, 0, 0, 0, 1);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 45, 23, 4, 0, 31, 0, 0, 0, 0);

-- Batting inn 46 (ENG)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 23, 1, 14,  18,  1, 0, 'Out',     'Bowled',  NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 24, 2, 34,  28,  4, 1, 'Out',     'Caught',  1,    11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 25, 3, 18,  20,  2, 0, 'Out',     'LBW',     NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 28, 4, 12,  18,  1, 0, 'Out',     'Caught',  7,    10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 26, 5, 10,  14,  0, 0, 'Out',     'Bowled',  NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 27, 6, 8,   12,  0, 0, 'Out',     'Caught',  3,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 23, 7, 4,   8,   0, 0, 'Out',     'Bowled',  NULL, 11);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 24, 8, 2,   6,   0, 0, 'Out',     'Caught',  2,    9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 25, 9, 1,   4,   0, 0, 'Out',     'Bowled',  NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 46, 26, 10,0,   2,   0, 0, 'Out',     'Caught',  1,    8);

-- Bowling inn 46 (IND bowling vs ENG)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 46, 9,  4, 0, 18, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 46, 8,  4, 0, 22, 2, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 46, 10, 4, 0, 28, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 46, 11, 4, 0, 35, 3, 0, 0, 0);

COMMIT;

-- ============================================================
-- MATCH 14: PAK vs NZ ODI
-- Inning 49: PAK batting
-- Inning 50: NZ batting
-- (Using IND players as PAK/NZ don't have players — using teams 4 and 6)
-- ============================================================

-- Batting inn 49 (PAK — using players from team 4, fallback to IND players)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 49, 1,  1, 88,  110, 9, 2, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 49, 2,  2, 62,  90,  7, 1, 'Out',     'Bowled',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 49, 3,  3, 44,  75,  5, 0, 'Out',     'LBW',     NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 49, 4,  4, 28,  55,  3, 0, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 49, 5,  5, 14,  30,  1, 0, 'Out',     'Bowled',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 49, 6,  6, 9,   20,  0, 0, 'Out',     'Caught',  NULL, NULL);

-- Bowling inn 49 (NZ bowling vs PAK)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 49, 8,  10, 0, 48, 3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 49, 9,  10, 0, 52, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 49, 10, 10, 0, 56, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 49, 11, 10, 0, 50, 1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 49, 7,  8,  0, 39, 1, 0, 0, 0);

-- Batting inn 50 (NZ)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 1,  1, 55,  80,  6, 0, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 2,  2, 42,  70,  4, 1, 'Out',     'Bowled',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 3,  3, 38,  65,  4, 0, 'Out',     'LBW',     NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 4,  4, 30,  55,  3, 0, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 5,  5, 22,  40,  2, 0, 'Out',     'Bowled',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 6,  6, 14,  30,  1, 0, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 50, 7,  7, 9,   20,  0, 0, 'Out',     'Bowled',  NULL, NULL);

-- Bowling inn 50 (PAK bowling vs NZ)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 50, 8,  10, 0, 42, 3, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 50, 9,  10, 0, 46, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 50, 10, 10, 0, 50, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 50, 11, 8,  0, 42, 1, 1, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 50, 7,  6,  0, 30, 1, 0, 0, 0);

COMMIT;

-- ============================================================
-- MATCH 15: SA vs IND T20
-- Inning 51: SA batting
-- Inning 52: IND batting
-- ============================================================

-- Batting inn 51 (SA)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 1,  1, 44,  36,  5, 1, 'Out',     'Caught',  NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 2,  2, 28,  24,  3, 0, 'Out',     'Bowled',  NULL, 8);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 3,  3, 36,  30,  4, 0, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 4,  4, 22,  20,  2, 0, 'Out',     'Caught',  NULL, 9);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 6,  5, 12,  14,  1, 0, 'Out',     'Caught',  NULL, 10);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 7,  6, 6,   8,   0, 0, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 51, 8,  7, 3,   4,   0, 0, 'Out',     'Bowled',  NULL, 11);

-- Bowling inn 51 (IND bowling vs SA)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 51, 9,  4, 0, 28, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 51, 8,  4, 0, 32, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 51, 11, 4, 0, 30, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 51, 10, 4, 0, 36, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 51, 7,  4, 0, 25, 1, 0, 0, 0);

-- Batting inn 52 (IND)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 52, 1,  1, 48,  38,  5, 1, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 52, 2,  2, 24,  22,  3, 0, 'Out',     'Bowled',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 52, 3,  3, 42,  32,  4, 1, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 52, 6,  4, 22,  18,  2, 1, 'Out',     'Caught',  NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 52, 7,  5, 16,  14,  1, 1, 'Not Out', NULL,      NULL, NULL);

-- Bowling inn 52 (SA bowling vs IND)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 52, 9,  4, 0, 30, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 52, 8,  4, 0, 34, 1, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 52, 10, 4, 0, 38, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 52, 11, 4, 0, 32, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 52, 7,  2, 0, 18, 0, 0, 0, 0);

COMMIT;

-- ============================================================
-- MATCH 16: AUS vs NZ T20 WC
-- Inning 53: AUS batting
-- Inning 54: NZ batting
-- ============================================================

-- Batting inn 53 (AUS)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 53, 12, 1, 58,  40,  6, 2, 'Out',     'Caught',  NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 53, 13, 2, 68,  44,  7, 2, 'Not Out', NULL,      NULL, NULL);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 53, 14, 3, 34,  26,  3, 1, 'Out',     'Bowled',  NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 53, 22, 4, 18,  14,  1, 1, 'Out',     'Caught',  NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 53, 16, 5, 10,  8,   1, 0, 'Not Out', NULL,      NULL, NULL);

-- Bowling inn 53 (NZ bowling vs AUS)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 53, 18, 4, 0, 38, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 53, 19, 4, 0, 42, 1, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 53, 20, 4, 0, 36, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 53, 21, 4, 0, 40, 0, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 53, 22, 4, 0, 32, 1, 0, 0, 0);

-- Batting inn 54 (NZ)
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 12, 1, 32,  28,  3, 1, 'Out',     'Caught',  NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 13, 2, 28,  26,  2, 1, 'Out',     'Bowled',  NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 14, 3, 24,  22,  2, 1, 'Out',     'LBW',     NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 16, 4, 22,  20,  2, 0, 'Out',     'Caught',  NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 22, 5, 18,  18,  1, 1, 'Out',     'Bowled',  NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 17, 6, 10,  12,  0, 0, 'Out',     'Caught',  NULL, 19);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 18, 7, 5,   8,   0, 0, 'Out',     'Bowled',  NULL, 18);
INSERT INTO Batting_Scorecard VALUES (SEQ_BSC.NEXTVAL, 54, 19, 8, 2,   4,   0, 0, 'Out',     'Caught',  NULL, 19);

-- Bowling inn 54 (AUS bowling vs NZ)
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 54, 18, 4, 0, 28, 3, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 54, 19, 4, 0, 34, 2, 0, 1, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 54, 20, 4, 0, 32, 2, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 54, 21, 4, 0, 28, 1, 0, 0, 0);
INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 54, 22, 2, 0, 19, 0, 0, 0, 0);

COMMIT;

-- ============================================================
-- MATCH RESULTS
-- ============================================================
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 7,  2,  46,   'Runs',    14, 'Australia won by 46 runs');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 11, 1,  NULL, 'Runs',    3,  'India won by an innings and 78 runs');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 12, 3,  NULL, 'Runs',    24, 'England won by an innings and 149 runs');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 13, 1,  68,   'Runs',    1,  'India won by 68 runs');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 14, 4,  35,   'Runs',    NULL,'Pakistan won by 35 runs');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 15, 1,  5,    'Wickets', 3,  'India won by 5 wickets');
INSERT INTO Match_Result VALUES (SEQ_RESULT.NEXTVAL, 16, 2,  47,   'Runs',    13, 'Australia won by 47 runs');

COMMIT;

-- Final verification
SELECT m.match_id,
       t1.team_name || ' vs ' || t2.team_name AS match_title,
       m.match_format,
       mr.result_description
FROM Matches m
JOIN Teams t1 ON m.team1_id = t1.team_id
JOIN Teams t2 ON m.team2_id = t2.team_id
LEFT JOIN Match_Result mr ON m.match_id = mr.match_id
ORDER BY m.match_id;