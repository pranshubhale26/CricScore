-- ============================================================
-- CRICKET SCORING SYSTEM — PL/SQL
-- User: cricket | DB: XEPDB1
-- Lab 7: Basics | Lab 8: Cursors | Lab 9: Procedures/Functions/Packages
-- ============================================================

SET SERVEROUTPUT ON;

-- ============================================================
-- LAB 7: ANONYMOUS BLOCKS
-- ============================================================

-- Block 1: IF-ELSIF — Grade an innings score
DECLARE
    v_runs  Innings.total_runs%TYPE;
    v_wkts  Innings.total_wickets%TYPE;
    v_grade VARCHAR2(20);
BEGIN
    SELECT total_runs, total_wickets
    INTO v_runs, v_wkts
    FROM Innings WHERE inning_id = 1;

    IF v_runs >= 300 THEN
        v_grade := 'Excellent';
    ELSIF v_runs >= 250 THEN
        v_grade := 'Good';
    ELSIF v_runs >= 200 THEN
        v_grade := 'Competitive';
    ELSIF v_runs >= 150 THEN
        v_grade := 'Below Par';
    ELSE
        v_grade := 'Poor';
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== Inning 1 ===');
    DBMS_OUTPUT.PUT_LINE('Runs   : ' || v_runs);
    DBMS_OUTPUT.PUT_LINE('Wickets: ' || v_wkts);
    DBMS_OUTPUT.PUT_LINE('Grade  : ' || v_grade);
END;
/

-- Block 2: FOR loop — Print top 5 scorers
DECLARE
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Top 5 Scorers ===');
    FOR rec IN (
        SELECT p.player_name, bs.runs, bs.balls
        FROM Batting_Scorecard bs
        JOIN Players p ON bs.player_id = p.player_id
        ORDER BY bs.runs DESC
    ) LOOP
        EXIT WHEN v_count >= 5;
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE(
            v_count || '. ' || RPAD(rec.player_name, 20) ||
            ' Runs: ' || LPAD(rec.runs, 4) ||
            ' Balls: ' || LPAD(rec.balls, 4)
        );
    END LOOP;
END;
/

-- Block 3: Exception handling
DECLARE
    v_name Teams.team_name%TYPE;
BEGIN
    SELECT team_name INTO v_name FROM Teams WHERE team_id = 999;
    DBMS_OUTPUT.PUT_LINE('Team: ' || v_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Team ID 999 does not exist.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Multiple rows returned.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

-- ============================================================
-- LAB 8: CURSORS
-- ============================================================

-- Implicit cursor — check SQL%ROWCOUNT
DECLARE
BEGIN
    UPDATE Innings SET extras_total = extras_total + 1
    WHERE total_wickets = 10;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Updated ' || SQL%ROWCOUNT || ' all-out innings.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No rows matched.');
    END IF;
    ROLLBACK;
END;
/

-- Explicit cursor — list India squad
DECLARE
    CURSOR c_players(p_team_id NUMBER) IS
        SELECT player_name, role, jersey_number
        FROM Players
        WHERE team_id = p_team_id AND is_active = 'Y'
        ORDER BY role, player_name;
    v_player c_players%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== India Squad ===');
    OPEN c_players(1);
    LOOP
        FETCH c_players INTO v_player;
        EXIT WHEN c_players%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            '#' || LPAD(NVL(TO_CHAR(v_player.jersey_number),'?'), 2) ||
            ' ' || RPAD(v_player.player_name, 20) ||
            ' [' || v_player.role || ']'
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total: ' || c_players%ROWCOUNT);
    CLOSE c_players;
END;
/

-- Cursor FOR LOOP — innings run rate
DECLARE
    v_rr NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Team', 15) || RPAD('Runs', 8) || RPAD('Overs', 10) || 'Run Rate'
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
    FOR rec IN (
        SELECT i.inning_id, t.team_name, i.total_runs,
               i.completed_overs, i.balls_in_current_over
        FROM Innings i
        JOIN Teams t ON i.batting_team_id = t.team_id
    ) LOOP
        IF rec.completed_overs > 0 THEN
            v_rr := ROUND(
                rec.total_runs / (rec.completed_overs + rec.balls_in_current_over / 6.0), 2
            );
        ELSE
            v_rr := 0;
        END IF;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.team_name, 15) ||
            RPAD(rec.total_runs, 8) ||
            RPAD(rec.completed_overs || '.' || rec.balls_in_current_over, 10) ||
            v_rr
        );
    END LOOP;
END;
/

-- WHERE CURRENT OF demo
DECLARE
    CURSOR c_bowl IS
        SELECT * FROM Bowling_Scorecard FOR UPDATE;
BEGIN
    FOR rec IN c_bowl LOOP
        IF rec.overs > 0 AND (rec.runs_conceded / rec.overs) < 5 THEN
            UPDATE Bowling_Scorecard
            SET maidens = rec.maidens
            WHERE CURRENT OF c_bowl;
        END IF;
    END LOOP;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('WHERE CURRENT OF demo complete.');
END;
/

-- Parameterized cursor — batting scorecard for a specific inning
DECLARE
    CURSOR c_scorecard(p_inning_id NUMBER) IS
        SELECT p.player_name, bs.runs, bs.balls,
               bs.fours, bs.sixes, bs.out_status, bs.dismissal_type
        FROM Batting_Scorecard bs
        JOIN Players p ON bs.player_id = p.player_id
        WHERE bs.inning_id = p_inning_id
        ORDER BY bs.batting_position;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Batting Scorecard - Inning 1 ===');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Player', 22) || RPAD('R', 6) || RPAD('B', 6) ||
        RPAD('4s', 5) || RPAD('6s', 5) || 'Status'
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
    FOR rec IN c_scorecard(1) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.player_name, 22) ||
            RPAD(rec.runs, 6)         ||
            RPAD(rec.balls, 6)        ||
            RPAD(rec.fours, 5)        ||
            RPAD(rec.sixes, 5)        ||
            NVL(rec.dismissal_type, rec.out_status)
        );
    END LOOP;
END;
/

-- ============================================================
-- LAB 9: STORED PROCEDURE — Record a ball delivery
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_record_ball (
    p_over_id        IN  Balls.over_id%TYPE,
    p_ball_number    IN  Balls.ball_number%TYPE,
    p_batsman_id     IN  Balls.batsman_id%TYPE,
    p_non_striker_id IN  Balls.non_striker_id%TYPE,
    p_bowler_id      IN  Balls.bowler_id%TYPE,
    p_runs_scored    IN  Balls.runs_scored%TYPE,
    p_extra_runs     IN  Balls.extra_runs%TYPE    DEFAULT 0,
    p_extra_type     IN  Balls.extra_type%TYPE    DEFAULT NULL,
    p_is_wicket      IN  Balls.is_wicket%TYPE     DEFAULT 'N',
    p_is_extra       IN  Balls.is_extra%TYPE      DEFAULT 'N',
    p_dismissal_type IN  Batting_Scorecard.dismissal_type%TYPE DEFAULT NULL,
    p_fielder_id     IN  Batting_Scorecard.fielder_id%TYPE     DEFAULT NULL,
    p_message        OUT VARCHAR2
) AS
    v_inning_id   Innings.inning_id%TYPE;
    v_total_runs  NUMBER;
    v_is_boundary CHAR(1) := 'N';
BEGIN
    IF p_runs_scored IN (4, 6) AND p_is_extra = 'N' THEN
        v_is_boundary := 'Y';
    END IF;

    INSERT INTO Balls (
        ball_id, over_id, ball_number, batsman_id, non_striker_id,
        bowler_id, runs_scored, extra_runs, extra_type,
        is_wicket, is_extra, is_boundary
    ) VALUES (
        SEQ_BALL.NEXTVAL, p_over_id, p_ball_number, p_batsman_id, p_non_striker_id,
        p_bowler_id, p_runs_scored, p_extra_runs, p_extra_type,
        p_is_wicket, p_is_extra, v_is_boundary
    );

    SELECT o.inning_id INTO v_inning_id
    FROM Overs o WHERE o.over_id = p_over_id;

    v_total_runs := p_runs_scored + p_extra_runs;

    UPDATE Overs SET
        runs_in_over    = runs_in_over + v_total_runs,
        wickets_in_over = wickets_in_over + CASE WHEN p_is_wicket = 'Y' THEN 1 ELSE 0 END
    WHERE over_id = p_over_id;

    UPDATE Innings SET
        total_runs    = total_runs + v_total_runs,
        total_wickets = total_wickets + CASE WHEN p_is_wicket = 'Y' THEN 1 ELSE 0 END,
        balls_in_current_over = balls_in_current_over +
            CASE WHEN p_extra_type IN ('Wide','No-Ball') THEN 0 ELSE 1 END,
        extras_total  = extras_total + p_extra_runs
    WHERE inning_id = v_inning_id;

    UPDATE Batting_Scorecard SET
        runs           = runs + p_runs_scored,
        balls          = balls + CASE WHEN p_extra_type IN ('Wide','No-Ball') THEN 0 ELSE 1 END,
        fours          = fours + CASE WHEN p_runs_scored = 4 AND p_is_extra = 'N' THEN 1 ELSE 0 END,
        sixes          = sixes + CASE WHEN p_runs_scored = 6 AND p_is_extra = 'N' THEN 1 ELSE 0 END,
        out_status     = CASE WHEN p_is_wicket = 'Y' THEN 'Out'            ELSE out_status     END,
        dismissal_type = CASE WHEN p_is_wicket = 'Y' THEN p_dismissal_type ELSE dismissal_type END,
        fielder_id     = CASE WHEN p_is_wicket = 'Y' THEN p_fielder_id     ELSE fielder_id     END
    WHERE inning_id = v_inning_id AND player_id = p_batsman_id;

    UPDATE Bowling_Scorecard SET
        runs_conceded = runs_conceded + v_total_runs,
        wickets       = wickets  + CASE WHEN p_is_wicket = 'Y' AND p_extra_type IS NULL THEN 1 ELSE 0 END,
        wides         = wides    + CASE WHEN p_extra_type = 'Wide'    THEN 1 ELSE 0 END,
        no_balls      = no_balls + CASE WHEN p_extra_type = 'No-Ball' THEN 1 ELSE 0 END
    WHERE inning_id = v_inning_id AND player_id = p_bowler_id;

    COMMIT;
    p_message := 'Ball recorded. Runs: ' || v_total_runs ||
                 CASE WHEN p_is_wicket = 'Y' THEN ' | WICKET! ' || NVL(p_dismissal_type,'') ELSE '' END;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_message := 'ERROR: Over or Inning not found.';
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_message := 'ERROR: Ball ' || p_ball_number || ' already exists for this over.';
    WHEN OTHERS THEN
        ROLLBACK;
        p_message := 'ERROR: ' || SQLERRM;
END sp_record_ball;
/

-- Procedure 2: Team summary
CREATE OR REPLACE PROCEDURE sp_team_summary (
    p_team_id IN Teams.team_id%TYPE
) AS
    v_team_name Teams.team_name%TYPE;
    v_matches   NUMBER := 0;
    v_wins      NUMBER := 0;
BEGIN
    SELECT team_name INTO v_team_name FROM Teams WHERE team_id = p_team_id;

    SELECT COUNT(*) INTO v_matches FROM Matches
    WHERE team1_id = p_team_id OR team2_id = p_team_id;

    SELECT COUNT(*) INTO v_wins FROM Match_Result
    WHERE winning_team_id = p_team_id;

    DBMS_OUTPUT.PUT_LINE('=== ' || v_team_name || ' ===');
    DBMS_OUTPUT.PUT_LINE('Played : ' || v_matches);
    DBMS_OUTPUT.PUT_LINE('Won    : ' || v_wins);
    DBMS_OUTPUT.PUT_LINE('Lost   : ' || (v_matches - v_wins));
    DBMS_OUTPUT.PUT_LINE('Win %  : ' ||
        ROUND(CASE WHEN v_matches = 0 THEN 0 ELSE v_wins * 100.0 / v_matches END, 1) || '%');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Team not found.');
END sp_team_summary;
/

-- Test procedure
BEGIN
    sp_team_summary(1);
    sp_team_summary(2);
END;
/

-- ============================================================
-- LAB 9: FUNCTIONS
-- ============================================================

-- Function 1: Strike rate
CREATE OR REPLACE FUNCTION fn_strike_rate (
    p_runs  IN NUMBER,
    p_balls IN NUMBER
) RETURN NUMBER AS
BEGIN
    IF p_balls = 0 OR p_balls IS NULL THEN RETURN 0; END IF;
    RETURN ROUND(p_runs * 100.0 / p_balls, 2);
END fn_strike_rate;
/

-- Function 2: Bowling economy
CREATE OR REPLACE FUNCTION fn_economy (
    p_runs  IN NUMBER,
    p_overs IN NUMBER
) RETURN NUMBER AS
BEGIN
    IF p_overs = 0 OR p_overs IS NULL THEN RETURN 0; END IF;
    RETURN ROUND(p_runs / p_overs, 2);
END fn_economy;
/

-- Function 3: Highest score for a player
CREATE OR REPLACE FUNCTION fn_highest_score (
    p_player_id IN Players.player_id%TYPE
) RETURN NUMBER AS
    v_high NUMBER := 0;
BEGIN
    SELECT NVL(MAX(runs), 0) INTO v_high
    FROM Batting_Scorecard WHERE player_id = p_player_id;
    RETURN v_high;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
END fn_highest_score;
/

-- Function 4: Player impact category
CREATE OR REPLACE FUNCTION fn_player_category (
    p_player_id IN Players.player_id%TYPE
) RETURN VARCHAR2 AS
    v_runs    NUMBER;
    v_wickets NUMBER;
BEGIN
    SELECT NVL(SUM(runs), 0)    INTO v_runs    FROM Batting_Scorecard WHERE player_id = p_player_id;
    SELECT NVL(SUM(wickets), 0) INTO v_wickets FROM Bowling_Scorecard WHERE player_id = p_player_id;

    IF    v_runs >= 30 AND v_wickets >= 2 THEN RETURN 'Impact Player';
    ELSIF v_runs >= 30                    THEN RETURN 'Key Batsman';
    ELSIF v_wickets >= 2                  THEN RETURN 'Key Bowler';
    ELSE                                       RETURN 'Regular';
    END IF;
END fn_player_category;
/

-- Test functions
SELECT p.player_name,
       fn_strike_rate(SUM(bs.runs), SUM(bs.balls)) AS strike_rate,
       fn_highest_score(p.player_id)                AS highest_score,
       fn_player_category(p.player_id)              AS category
FROM Batting_Scorecard bs
JOIN Players p ON bs.player_id = p.player_id
GROUP BY p.player_id, p.player_name
ORDER BY strike_rate DESC;

-- ============================================================
-- LAB 9: PACKAGE
-- ============================================================

-- Package specification
CREATE OR REPLACE PACKAGE pkg_cricket AS
    PROCEDURE get_match_scorecard (p_match_id IN NUMBER);
    PROCEDURE get_player_card     (p_player_id IN NUMBER);
    FUNCTION  get_net_run_rate    (p_team_id IN NUMBER) RETURN NUMBER;
    FUNCTION  count_team_players  (p_team_id IN NUMBER) RETURN NUMBER;
END pkg_cricket;
/

-- Package body
CREATE OR REPLACE PACKAGE BODY pkg_cricket AS

    PROCEDURE get_match_scorecard (p_match_id IN NUMBER) AS
        v_t1 Teams.team_name%TYPE;
        v_t2 Teams.team_name%TYPE;
        v_m  Matches%ROWTYPE;
    BEGIN
        SELECT * INTO v_m FROM Matches WHERE match_id = p_match_id;
        SELECT team_name INTO v_t1 FROM Teams WHERE team_id = v_m.team1_id;
        SELECT team_name INTO v_t2 FROM Teams WHERE team_id = v_m.team2_id;
        DBMS_OUTPUT.PUT_LINE('==========================================');
        DBMS_OUTPUT.PUT_LINE(v_t1 || ' vs ' || v_t2);
        DBMS_OUTPUT.PUT_LINE('Format : ' || v_m.match_format ||
                             '  Date: ' || TO_CHAR(v_m.match_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Status : ' || v_m.status);
        DBMS_OUTPUT.PUT_LINE('==========================================');
        FOR inn IN (
            SELECT i.inning_number, t.team_name AS bat_team,
                   i.total_runs, i.total_wickets, i.completed_overs
            FROM Innings i JOIN Teams t ON i.batting_team_id = t.team_id
            WHERE i.match_id = p_match_id ORDER BY i.inning_number
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Inn ' || inn.inning_number || ': ' ||
                RPAD(inn.bat_team, 15) || ' ' ||
                inn.total_runs || '/' || inn.total_wickets ||
                ' (' || inn.completed_overs || ' ov)'
            );
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Match not found.');
    END get_match_scorecard;

    PROCEDURE get_player_card (p_player_id IN NUMBER) AS
        v_player Players%ROWTYPE;
        v_team   Teams.team_name%TYPE;
    BEGIN
        SELECT * INTO v_player FROM Players WHERE player_id = p_player_id;
        SELECT team_name INTO v_team FROM Teams WHERE team_id = v_player.team_id;
        DBMS_OUTPUT.PUT_LINE('--- Player Card ---');
        DBMS_OUTPUT.PUT_LINE('Name  : ' || v_player.player_name);
        DBMS_OUTPUT.PUT_LINE('Team  : ' || v_team);
        DBMS_OUTPUT.PUT_LINE('Role  : ' || v_player.role);
        DBMS_OUTPUT.PUT_LINE('Jersey: #' || NVL(TO_CHAR(v_player.jersey_number), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Top Score: ' || fn_highest_score(p_player_id));
        DBMS_OUTPUT.PUT_LINE('Class : ' || fn_player_category(p_player_id));
    END get_player_card;

    FUNCTION get_net_run_rate (p_team_id IN NUMBER) RETURN NUMBER AS
        v_runs_scored  NUMBER := 0;
        v_overs_faced  NUMBER := 0;
        v_runs_against NUMBER := 0;
        v_overs_bowled NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(total_runs), 0), NVL(SUM(completed_overs), 0)
        INTO v_runs_scored, v_overs_faced
        FROM Innings WHERE batting_team_id = p_team_id;

        SELECT NVL(SUM(total_runs), 0), NVL(SUM(completed_overs), 0)
        INTO v_runs_against, v_overs_bowled
        FROM Innings WHERE bowling_team_id = p_team_id;

        IF v_overs_faced = 0 OR v_overs_bowled = 0 THEN RETURN 0; END IF;
        RETURN ROUND((v_runs_scored / v_overs_faced) - (v_runs_against / v_overs_bowled), 3);
    END get_net_run_rate;

    FUNCTION count_team_players (p_team_id IN NUMBER) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Players
        WHERE team_id = p_team_id AND is_active = 'Y';
        RETURN v_count;
    END count_team_players;

END pkg_cricket;
/

-- Test the package
BEGIN
    pkg_cricket.get_match_scorecard(1);
    DBMS_OUTPUT.PUT_LINE('');
    pkg_cricket.get_player_card(3);
    DBMS_OUTPUT.PUT_LINE('India NRR    : ' || pkg_cricket.get_net_run_rate(1));
    DBMS_OUTPUT.PUT_LINE('India Players: ' || pkg_cricket.count_team_players(1));
END;
/