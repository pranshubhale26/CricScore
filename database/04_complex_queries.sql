-- ============================================================
-- CRICKET SCORING SYSTEM — COMPLEX QUERIES
-- User: cricket | DB: XEPDB1
-- Lab 3: Set Ops, Subqueries, Views
-- Lab 4: GROUP BY, HAVING, ORDER BY, WITH, COMMIT/ROLLBACK
-- ============================================================

-- ============================================================
-- LAB 3: SET OPERATIONS
-- ============================================================

-- UNION: Players who batted OR bowled
SELECT p.player_name, 'Batted' AS activity
FROM Players p JOIN Batting_Scorecard bs ON p.player_id = bs.player_id
UNION
SELECT p.player_name, 'Bowled'
FROM Players p JOIN Bowling_Scorecard bwl ON p.player_id = bwl.player_id
ORDER BY player_name;

-- INTERSECT: Players who BOTH batted AND bowled
SELECT p.player_name FROM Players p
JOIN Batting_Scorecard bs ON p.player_id = bs.player_id
INTERSECT
SELECT p.player_name FROM Players p
JOIN Bowling_Scorecard bwl ON p.player_id = bwl.player_id;

-- MINUS: Players who batted but did NOT bowl
SELECT p.player_name FROM Players p
JOIN Batting_Scorecard bs ON p.player_id = bs.player_id
MINUS
SELECT p.player_name FROM Players p
JOIN Bowling_Scorecard bwl ON p.player_id = bwl.player_id;

-- ============================================================
-- LAB 3: NESTED SUBQUERIES
-- ============================================================

-- IN: Players who scored more than average in their inning
SELECT p.player_name, bs.runs, bs.inning_id
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
WHERE bs.runs > (
    SELECT AVG(runs) FROM Batting_Scorecard
    WHERE inning_id = bs.inning_id
)
ORDER BY bs.runs DESC;

-- EXISTS: Matches that have a recorded result
SELECT m.match_id,
       t1.team_name || ' vs ' || t2.team_name AS match_title,
       m.match_format,
       m.match_date
FROM Matches m
JOIN Teams t1 ON m.team1_id = t1.team_id
JOIN Teams t2 ON m.team2_id = t2.team_id
WHERE EXISTS (
    SELECT 1 FROM Match_Result mr WHERE mr.match_id = m.match_id
);

-- NOT EXISTS: Matches with no result yet
SELECT m.match_id, m.match_format, m.match_date
FROM Matches m
WHERE NOT EXISTS (
    SELECT 1 FROM Match_Result mr WHERE mr.match_id = m.match_id
);

-- Subquery in FROM clause (Derived Relation)
-- Average runs per team
SELECT team_name, ROUND(avg_runs, 2) AS average_runs
FROM (
    SELECT t.team_name, AVG(bs.runs) AS avg_runs
    FROM Batting_Scorecard bs
    JOIN Players p ON bs.player_id = p.player_id
    JOIN Teams   t ON p.team_id    = t.team_id
    GROUP BY t.team_name
) team_avg
WHERE avg_runs > 15
ORDER BY avg_runs DESC;

-- ============================================================
-- LAB 4: GROUP BY + HAVING
-- ============================================================

-- Top scorers per match format
SELECT m.match_format,
       p.player_name,
       SUM(bs.runs)        AS total_runs,
       COUNT(bs.inning_id) AS innings
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
JOIN Innings i ON bs.inning_id = i.inning_id
JOIN Matches m ON i.match_id   = m.match_id
GROUP BY m.match_format, p.player_name
HAVING SUM(bs.runs) > 20
ORDER BY m.match_format, total_runs DESC;

-- Bowling economy — bowlers with more than 3 overs
SELECT p.player_name,
       t.team_name,
       SUM(bwl.overs)         AS total_overs,
       SUM(bwl.runs_conceded) AS total_runs,
       SUM(bwl.wickets)       AS total_wickets,
       ROUND(SUM(bwl.runs_conceded) / NULLIF(SUM(bwl.overs), 0), 2) AS economy
FROM Bowling_Scorecard bwl
JOIN Players p ON bwl.player_id = p.player_id
JOIN Teams   t ON p.team_id     = t.team_id
GROUP BY p.player_name, t.team_name
HAVING SUM(bwl.overs) >= 3
ORDER BY economy ASC;

-- Boundaries per team per inning
SELECT t.team_name,
       i.inning_id,
       SUM(bs.fours) AS total_fours,
       SUM(bs.sixes) AS total_sixes,
       SUM(bs.fours * 4 + bs.sixes * 6) AS boundary_runs
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
JOIN Teams   t ON p.team_id    = t.team_id
JOIN Innings i ON bs.inning_id = i.inning_id
GROUP BY t.team_name, i.inning_id
ORDER BY boundary_runs DESC;

-- Players ranked by strike rate (min 10 balls)
SELECT p.player_name,
       t.team_name,
       SUM(bs.runs)  AS runs,
       SUM(bs.balls) AS balls,
       ROUND(SUM(bs.runs) * 100.0 / NULLIF(SUM(bs.balls), 0), 2) AS strike_rate
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
JOIN Teams   t ON p.team_id    = t.team_id
GROUP BY p.player_name, t.team_name
HAVING SUM(bs.balls) >= 10
ORDER BY strike_rate DESC;

-- ============================================================
-- LAB 4: WITH CLAUSE
-- ============================================================

-- Find highest run scorer across all matches
WITH player_totals AS (
    SELECT p.player_name, t.team_name, SUM(bs.runs) AS career_runs
    FROM Batting_Scorecard bs
    JOIN Players p ON bs.player_id = p.player_id
    JOIN Teams   t ON p.team_id    = t.team_id
    GROUP BY p.player_name, t.team_name
),
max_runs AS (
    SELECT MAX(career_runs) AS top_score FROM player_totals
)
SELECT pt.player_name, pt.team_name, pt.career_runs
FROM player_totals pt, max_runs mr
WHERE pt.career_runs = mr.top_score;

-- Innings where team scored above average
WITH inning_avg AS (
    SELECT AVG(total_runs) AS avg_score FROM Innings
)
SELECT i.inning_id,
       t.team_name,
       i.total_runs,
       ROUND(ia.avg_score, 2) AS avg_score
FROM Innings i
JOIN Teams   t  ON i.batting_team_id = t.team_id
CROSS JOIN inning_avg ia
WHERE i.total_runs > ia.avg_score
ORDER BY i.total_runs DESC;

-- ============================================================
-- LAB 4: ORDER BY
-- ============================================================

-- Players ranked by total runs descending
SELECT p.player_name, t.team_name, SUM(bs.runs) AS total_runs
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
JOIN Teams   t ON p.team_id    = t.team_id
GROUP BY p.player_name, t.team_name
ORDER BY total_runs DESC;

-- Matches ordered by date ascending
SELECT match_id, match_format, match_date, status
FROM Matches
ORDER BY match_date ASC;

-- ============================================================
-- LAB 4: COMMIT / ROLLBACK / SAVEPOINT DEMO
-- ============================================================
-- Run this block in SQL*Plus to demonstrate transactions
/*
BEGIN
    INSERT INTO Players (player_id, team_id, player_name, role, is_active)
    VALUES (SEQ_PLAYER.NEXTVAL, 1, 'Test Player', 'Batsman', 'Y');

    SAVEPOINT after_insert;

    UPDATE Players SET jersey_number = 99 WHERE player_name = 'Test Player';

    SAVEPOINT after_update;

    -- Mistake: wrong update, rollback to before update
    ROLLBACK TO after_insert;

    -- Confirm jersey is still NULL
    SELECT player_name, jersey_number FROM Players WHERE player_name = 'Test Player';

    COMMIT;
END;
/
*/

-- ============================================================
-- BUILT-IN FUNCTIONS DEMO (Lab 2)
-- ============================================================
SELECT
    UPPER(player_name)                                          AS name_upper,
    LENGTH(player_name)                                         AS name_length,
    SUBSTR(player_name, 1, 5)                                  AS first_5_chars,
    NVL(TO_CHAR(date_of_birth, 'DD-MON-YYYY'), 'Unknown')     AS dob,
    ROUND(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12, 0)     AS age
FROM Players
WHERE date_of_birth IS NOT NULL
ORDER BY date_of_birth;

-- ============================================================
-- ADDITIONAL QUERIES (Viva ready)
-- ============================================================

-- Players who scored 50+ in any inning
SELECT p.player_name, t.team_name,
       bs.runs, bs.balls,
       ROUND(bs.runs * 100.0 / NULLIF(bs.balls, 0), 2) AS strike_rate,
       m.match_format,
       TO_CHAR(m.match_date, 'DD-MON-YYYY') AS match_date
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
JOIN Teams   t ON p.team_id    = t.team_id
JOIN Innings i ON bs.inning_id = i.inning_id
JOIN Matches m ON i.match_id   = m.match_id
WHERE bs.runs >= 50
ORDER BY bs.runs DESC;

-- Maiden overs per bowler
SELECT p.player_name, COUNT(*) AS maiden_overs
FROM Overs o
JOIN Players p ON o.bowler_id = p.player_id
WHERE o.is_maiden = 'Y'
GROUP BY p.player_name
ORDER BY maiden_overs DESC;

-- Match with highest combined score
SELECT match_title, combined_runs FROM (
    SELECT t1.team_name || ' vs ' || t2.team_name AS match_title,
           SUM(i.total_runs) AS combined_runs
    FROM Innings i
    JOIN Matches m ON i.match_id  = m.match_id
    JOIN Teams  t1 ON m.team1_id  = t1.team_id
    JOIN Teams  t2 ON m.team2_id  = t2.team_id
    GROUP BY t1.team_name, t2.team_name
    ORDER BY combined_runs DESC
)
WHERE ROWNUM = 1;