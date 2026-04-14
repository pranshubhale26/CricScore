-- ============================================================
-- CRICKET SCORING SYSTEM — VIEWS
-- User: cricket | DB: XEPDB1
-- Lab 3: Intermediate SQL — Views
-- ============================================================

-- VIEW 1: Live Scorecard
CREATE OR REPLACE VIEW vw_live_scorecard AS
SELECT
    m.match_id,
    t1.team_name                                          AS batting_team,
    t2.team_name                                          AS bowling_team,
    i.inning_number,
    i.total_runs,
    i.total_wickets,
    i.completed_overs || '.' || i.balls_in_current_over  AS overs_faced,
    i.extras_total,
    m.match_format,
    m.status                                              AS match_status,
    v.venue_name,
    v.city
FROM Matches  m
JOIN Innings  i  ON m.match_id         = i.match_id
JOIN Teams    t1 ON i.batting_team_id  = t1.team_id
JOIN Teams    t2 ON i.bowling_team_id  = t2.team_id
JOIN Venues   v  ON m.venue_id         = v.venue_id;

-- VIEW 2: Career Statistics
CREATE OR REPLACE VIEW vw_career_stats AS
SELECT
    p.player_id,
    p.player_name,
    t.team_name,
    p.role,
    COUNT(DISTINCT bs.inning_id)                                        AS innings_batted,
    NVL(SUM(bs.runs), 0)                                                AS total_runs,
    NVL(MAX(bs.runs), 0)                                                AS highest_score,
    ROUND(NVL(AVG(bs.runs), 0), 2)                                     AS batting_avg,
    ROUND(
        CASE WHEN NVL(SUM(bs.balls), 0) = 0 THEN 0
             ELSE SUM(bs.runs) * 100.0 / SUM(bs.balls)
        END, 2
    )                                                                    AS strike_rate,
    NVL(SUM(bs.fours), 0)                                               AS total_fours,
    NVL(SUM(bs.sixes), 0)                                               AS total_sixes,
    COUNT(DISTINCT bwl.inning_id)                                       AS innings_bowled,
    NVL(SUM(bwl.wickets), 0)                                            AS total_wickets,
    NVL(SUM(bwl.runs_conceded), 0)                                     AS runs_conceded,
    NVL(SUM(bwl.maidens), 0)                                            AS total_maidens
FROM Players                p
JOIN Teams                  t   ON p.team_id    = t.team_id
LEFT JOIN Batting_Scorecard bs  ON p.player_id  = bs.player_id
LEFT JOIN Bowling_Scorecard bwl ON p.player_id  = bwl.player_id
GROUP BY p.player_id, p.player_name, t.team_name, p.role;

-- VIEW 3: Match Summary
CREATE OR REPLACE VIEW vw_match_summary AS
SELECT
    m.match_id,
    m.match_date,
    m.match_format,
    t1.team_name       AS team1,
    t2.team_name       AS team2,
    v.venue_name,
    v.city,
    s.series_name,
    tw.team_name       AS toss_winner,
    m.toss_decision,
    wt.team_name       AS winning_team,
    mr.win_margin,
    mr.win_margin_type,
    mr.result_description,
    mom.player_name    AS man_of_match,
    m.status
FROM Matches           m
JOIN Teams             t1  ON m.team1_id         = t1.team_id
JOIN Teams             t2  ON m.team2_id         = t2.team_id
JOIN Venues            v   ON m.venue_id          = v.venue_id
LEFT JOIN Series       s   ON m.series_id         = s.series_id
LEFT JOIN Teams        tw  ON m.toss_winner_id    = tw.team_id
LEFT JOIN Match_Result mr  ON m.match_id          = mr.match_id
LEFT JOIN Teams        wt  ON mr.winning_team_id  = wt.team_id
LEFT JOIN Players      mom ON mr.man_of_match     = mom.player_id;

-- VIEW 4: Bowling Economy
CREATE OR REPLACE VIEW vw_bowling_economy AS
SELECT
    p.player_name,
    t.team_name,
    bwl.inning_id,
    bwl.overs,
    bwl.runs_conceded,
    bwl.wickets,
    ROUND(
        CASE WHEN bwl.overs = 0 THEN 0
             ELSE bwl.runs_conceded / bwl.overs
        END, 2
    ) AS economy_rate,
    ROUND(
        CASE WHEN bwl.wickets = 0 THEN NULL
             ELSE bwl.runs_conceded / bwl.wickets
        END, 2
    ) AS bowling_avg
FROM Bowling_Scorecard bwl
JOIN Players p ON bwl.player_id = p.player_id
JOIN Teams   t ON p.team_id     = t.team_id;

COMMIT;

-- Test views
SELECT * FROM vw_live_scorecard;
SELECT * FROM vw_match_summary;
SELECT player_name, total_runs, strike_rate, total_wickets FROM vw_career_stats WHERE total_runs > 0;
SELECT * FROM vw_bowling_economy;