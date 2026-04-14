-- ============================================================
-- CRICKET SCORING SYSTEM — TRIGGERS
-- User: cricket | DB: XEPDB1
-- Lab 10: Row Triggers, DB Triggers, Instead-Of Triggers
-- ============================================================

-- ============================================================
-- TRIGGER 1: Auto-complete over when 6 balls bowled
-- Row Trigger — BEFORE UPDATE on Innings
-- ============================================================
CREATE OR REPLACE TRIGGER trg_over_completion
BEFORE UPDATE OF balls_in_current_over ON Innings
FOR EACH ROW
BEGIN
    IF :NEW.balls_in_current_over >= 6 THEN
        :NEW.completed_overs       := :OLD.completed_overs + 1;
        :NEW.balls_in_current_over := 0;
    END IF;
END;
/

-- ============================================================
-- TRIGGER 2: Auto-detect maiden over
-- Row Trigger — BEFORE UPDATE on Overs
-- ============================================================
CREATE OR REPLACE TRIGGER trg_maiden_detection
BEFORE UPDATE OF runs_in_over ON Overs
FOR EACH ROW
BEGIN
    IF :NEW.runs_in_over = 0 THEN
        :NEW.is_maiden := 'Y';
    ELSE
        :NEW.is_maiden := 'N';
    END IF;
END;
/

-- ============================================================
-- TRIGGER 3: Prevent deactivating a player in a live match
-- Database Trigger — BEFORE UPDATE on Players
-- ============================================================
CREATE OR REPLACE TRIGGER trg_player_deactivation
BEFORE UPDATE OF is_active ON Players
FOR EACH ROW
WHEN (NEW.is_active = 'N')
DECLARE
    v_live_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_live_count
    FROM Balls b
    JOIN Overs   o ON b.over_id   = o.over_id
    JOIN Innings i ON o.inning_id = i.inning_id
    JOIN Matches m ON i.match_id  = m.match_id
    WHERE (b.batsman_id = :OLD.player_id OR b.bowler_id = :OLD.player_id)
    AND m.status = 'Live';

    IF v_live_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Cannot deactivate ' || :OLD.player_name ||
            ' — player is in a Live match.');
    END IF;
END;
/

-- ============================================================
-- TRIGGER 4: Transparent Audit System (Lab 10 Exercise 4)
-- AFTER INSERT OR UPDATE OR DELETE on Batting_Scorecard
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_batting
AFTER INSERT OR UPDATE OR DELETE ON Batting_Scorecard
FOR EACH ROW
DECLARE
    v_op      VARCHAR2(10);
    v_old_val VARCHAR2(4000);
    v_new_val VARCHAR2(4000);
    v_rec_id  NUMBER;
BEGIN
    CASE
        WHEN INSERTING THEN
            v_op      := 'INSERT';
            v_rec_id  := :NEW.scorecard_id;
            v_old_val := NULL;
            v_new_val := 'player=' || :NEW.player_id || ',runs=' || :NEW.runs;
        WHEN UPDATING THEN
            v_op      := 'UPDATE';
            v_rec_id  := :OLD.scorecard_id;
            v_old_val := 'runs=' || :OLD.runs || ',balls=' || :OLD.balls ||
                         ',fours=' || :OLD.fours || ',sixes=' || :OLD.sixes;
            v_new_val := 'runs=' || :NEW.runs || ',balls=' || :NEW.balls ||
                         ',fours=' || :NEW.fours || ',sixes=' || :NEW.sixes;
        WHEN DELETING THEN
            v_op      := 'DELETE';
            v_rec_id  := :OLD.scorecard_id;
            v_old_val := 'player=' || :OLD.player_id || ',runs=' || :OLD.runs;
            v_new_val := NULL;
    END CASE;

    INSERT INTO Audit_Log (
        audit_id, table_name, operation, record_id,
        changed_by, changed_at, old_value, new_value, description
    ) VALUES (
        SEQ_AUDIT.NEXTVAL, 'BATTING_SCORECARD', v_op, v_rec_id,
        USER, SYSTIMESTAMP, v_old_val, v_new_val, 'Auto audit entry'
    );
END;
/

-- ============================================================
-- TRIGGER 5: Validate match data
-- Database Trigger — BEFORE INSERT OR UPDATE on Matches
-- ============================================================
CREATE OR REPLACE TRIGGER trg_validate_match
BEFORE INSERT OR UPDATE ON Matches
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    IF :NEW.team1_id = :NEW.team2_id THEN
        RAISE_APPLICATION_ERROR(-20002, 'A team cannot play against itself.');
    END IF;

    IF :NEW.team1_captain_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count FROM Players
        WHERE player_id = :NEW.team1_captain_id AND team_id = :NEW.team1_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Team 1 captain does not belong to Team 1.');
        END IF;
    END IF;

    IF :NEW.team2_captain_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count FROM Players
        WHERE player_id = :NEW.team2_captain_id AND team_id = :NEW.team2_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Team 2 captain does not belong to Team 2.');
        END IF;
    END IF;

    INSERT INTO Audit_Log (
        audit_id, table_name, operation, record_id,
        changed_by, changed_at, description
    ) VALUES (
        SEQ_AUDIT.NEXTVAL, 'MATCHES',
        CASE WHEN INSERTING THEN 'INSERT' ELSE 'UPDATE' END,
        :NEW.match_id, USER, SYSTIMESTAMP,
        'Match ' || CASE WHEN INSERTING THEN 'created' ELSE 'updated' END
    );
END;
/

-- ============================================================
-- TRIGGER 6: Auto-set match status to Completed when result inserted
-- AFTER INSERT on Match_Result
-- ============================================================
CREATE OR REPLACE TRIGGER trg_match_completion
AFTER INSERT ON Match_Result
FOR EACH ROW
BEGIN
    UPDATE Matches SET status = 'Completed'
    WHERE match_id = :NEW.match_id;
END;
/

-- ============================================================
-- TRIGGER 7: INSTEAD OF trigger on vw_live_scorecard
-- Lab 10: Instead-Of Triggers
-- Allows updating innings runs through the view
-- ============================================================
CREATE OR REPLACE TRIGGER trg_instead_of_scorecard
INSTEAD OF UPDATE ON vw_live_scorecard
FOR EACH ROW
BEGIN
    UPDATE Innings SET
        total_runs    = :NEW.total_runs,
        total_wickets = :NEW.total_wickets
    WHERE match_id      = :OLD.match_id
    AND   inning_number = :OLD.inning_number;

    DBMS_OUTPUT.PUT_LINE(
        'INSTEAD OF trigger: Updated innings for match ' || :OLD.match_id
    );
END;
/

COMMIT;

-- Verify all triggers created
SELECT trigger_name, trigger_type, triggering_event, status
FROM user_triggers
ORDER BY trigger_name;

-- Test audit trigger
UPDATE Batting_Scorecard SET runs = runs WHERE scorecard_id = 1;
SELECT table_name, operation, record_id, changed_by,
       TO_CHAR(changed_at, 'DD-MON-YYYY HH24:MI:SS') AS changed_at,
       old_value, new_value
FROM Audit_Log
ORDER BY changed_at DESC;
ROLLBACK;