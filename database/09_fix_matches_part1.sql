-- ============================================================
-- FIXED: 7 NEW MATCHES + MISSING BOWLING DATA
-- Uses exact IDs from your database
-- Teams: 1=India, 2=Australia, 3=England, 4=Pakistan, 5=South Africa, 6=New Zealand
-- Series: 4=ICC T20 WC 2024, 5=IND vs ENG Test 2024, 6=PAK vs NZ ODI 2023, 7=SA vs IND T20 2023
-- Existing innings: 1-6 (matches 1-3)
-- New matches will be 4-10, new innings will start from 7
-- ============================================================

-- ── FIX: Missing bowling for Match 3 Inning 1 (IND T20 batting, inning_id=5)
-- Check if already inserted, skip if duplicate
BEGIN
    INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 5, 18, 4, 0, 38, 1, 0, 0, 1);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
BEGIN
    INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 5, 19, 4, 0, 42, 1, 0, 1, 0);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
BEGIN
    INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 5, 20, 4, 0, 35, 1, 0, 0, 0);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
BEGIN
    INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 5, 21, 4, 0, 30, 0, 1, 0, 0);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
BEGIN
    INSERT INTO Bowling_Scorecard VALUES (SEQ_BLSC.NEXTVAL, 5, 22, 4, 0, 31, 1, 0, 0, 0);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

-- ============================================================
-- 7 NEW MATCHES (IDs 4-10)
-- ============================================================
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 5, 1, 3, 1, TO_DATE('25-JAN-2024','DD-MON-YYYY'), 'Test', 'Completed', 3, 'Bat',   3,  23, 1);
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 5, 1, 3, 4, TO_DATE('02-FEB-2024','DD-MON-YYYY'), 'Test', 'Completed', 1, 'Field', 3,  23, 2);
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 4, 1, 3, 1, TO_DATE('09-JUN-2024','DD-MON-YYYY'), 'T20',  'Completed', 1, 'Bat',   1,  23, 4);
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 3, 2, 3, 2, TO_DATE('22-JUN-2023','DD-MON-YYYY'), 'ODI',  'Completed', 2, 'Bat',   18, 23, 5);
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 6, 4, 6, 5, TO_DATE('09-JAN-2023','DD-MON-YYYY'), 'ODI',  'Completed', 4, 'Bat',   NULL, NULL, 1);
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 7, 5, 1, 6, TO_DATE('28-SEP-2023','DD-MON-YYYY'), 'T20',  'Completed', 5, 'Bat',   NULL, NULL, 1);
INSERT INTO Matches VALUES (SEQ_MATCH.NEXTVAL, 4, 2, 6, 2, TO_DATE('22-JUN-2024','DD-MON-YYYY'), 'T20',  'Completed', 2, 'Field', 18,  NULL, 6);

COMMIT;

-- Verify matches
SELECT match_id, team1_id, team2_id, match_format FROM Matches ORDER BY match_id;

-- ============================================================
-- INNINGS for matches 4-10
-- After inserting above 7 matches, innings will get IDs 7-24
-- We insert them and use SEQ_INNING.CURRVAL to track
-- ============================================================

-- Match 4: IND vs ENG Test (Hyderabad) — 3 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 4, 1, 3, 1, 246, 10, 74, 3, 18, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 4, 2, 1, 3, 436, 6,  98, 1, 25, 'Y', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 4, 3, 3, 1, 112, 10, 42, 3, 12, 'N', NULL);

-- Match 5: IND vs ENG Test (Vizag) — 3 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 5, 1, 1, 3, 396, 10, 87, 2, 22, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 5, 2, 3, 1, 420, 8,  90, 1, 28, 'Y', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 5, 3, 1, 3, 145, 10, 51, 2, 14, 'N', NULL);

-- Match 6: IND vs ENG T20 WC — 2 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 6, 1, 1, 3, 171, 4,  20, 0, 8,  'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 6, 2, 3, 1, 103, 10, 16, 3, 7,  'N', 172);

-- Match 7: AUS vs ENG ODI — 2 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 7, 1, 2, 3, 278, 9,  49, 5, 16, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 7, 2, 3, 2, 232, 10, 44, 3, 14, 'N', 279);

-- Match 8: PAK vs NZ ODI — 2 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 8, 1, 4, 6, 245, 10, 48, 4, 18, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 8, 2, 6, 4, 210, 10, 44, 2, 16, 'N', 246);

-- Match 9: SA vs IND T20 — 2 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 9, 1, 5, 1, 151, 7,  20, 0, 9,  'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 9, 2, 1, 5, 152, 5,  18, 3, 10, 'N', 152);

-- Match 10: AUS vs NZ T20 WC — 2 innings
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 10, 1, 2, 6, 188, 5,  20, 0, 14, 'N', NULL);
INSERT INTO Innings VALUES (SEQ_INNING.NEXTVAL, 10, 2, 6, 2, 141, 10, 18, 2, 11, 'N', 189);

COMMIT;

-- !! CRITICAL: Check actual inning IDs before continuing !!
SELECT inning_id, match_id, inning_number, batting_team_id, bowling_team_id
FROM Innings
WHERE match_id >= 4
ORDER BY match_id, inning_number;