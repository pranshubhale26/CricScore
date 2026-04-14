-- ============================================================
-- CRICKET SCORING SYSTEM — ORACLE SCHEMA
-- ============================================================

-- Drop existing tables (safe to re-run)
BEGIN
    FOR t IN (
        SELECT table_name FROM user_tables
        WHERE table_name IN (
            'AUDIT_LOG','MATCH_RESULT','BOWLING_SCORECARD',
            'BATTING_SCORECARD','BALLS','OVERS','INNINGS',
            'MATCHES','SERIES_MATCHES','SERIES',
            'PLAYERS','VENUES','TEAMS'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- Drop sequences
BEGIN
    FOR s IN (
        SELECT sequence_name FROM user_sequences
        WHERE sequence_name LIKE 'SEQ_%'
    ) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

-- ============================================================
-- SEQUENCES
-- ============================================================
CREATE SEQUENCE SEQ_TEAM      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_VENUE     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PLAYER    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_SERIES    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_MATCH     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_INNING    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_OVER      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_BALL      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_BSC       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_BLSC      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_RESULT    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_AUDIT     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_SERIES_M  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ============================================================
-- TABLE 1: TEAMS
-- ============================================================
CREATE TABLE Teams (
    team_id    NUMBER        CONSTRAINT pk_teams PRIMARY KEY,
    team_name  VARCHAR2(100) CONSTRAINT nn_team_name NOT NULL,
    country    VARCHAR2(100) CONSTRAINT nn_team_country NOT NULL,
    coach      VARCHAR2(100),
    home_venue VARCHAR2(100),
    founded_yr NUMBER        CONSTRAINT chk_founded CHECK (founded_yr > 1800 OR founded_yr IS NULL)
);

-- ============================================================
-- TABLE 2: VENUES
-- ============================================================
CREATE TABLE Venues (
    venue_id   NUMBER        CONSTRAINT pk_venues PRIMARY KEY,
    venue_name VARCHAR2(150) CONSTRAINT nn_venue_name NOT NULL,
    city       VARCHAR2(100) CONSTRAINT nn_venue_city NOT NULL,
    country    VARCHAR2(100),
    capacity   NUMBER        CONSTRAINT chk_capacity CHECK (capacity > 0),
    pitch_type VARCHAR2(50)  CONSTRAINT chk_pitch CHECK (
        pitch_type IN ('Flat','Bouncy','Spin-friendly','Seam-friendly','Green-top')
        OR pitch_type IS NULL
    )
);

-- ============================================================
-- TABLE 3: PLAYERS
-- ============================================================
CREATE TABLE Players (
    player_id     NUMBER        CONSTRAINT pk_players PRIMARY KEY,
    team_id       NUMBER        CONSTRAINT nn_player_team NOT NULL,
    player_name   VARCHAR2(100) CONSTRAINT nn_player_name NOT NULL,
    role          VARCHAR2(50)  CONSTRAINT chk_role CHECK (
                                    role IN ('Batsman','Bowler','All-Rounder','Wicket-Keeper')),
    batting_style VARCHAR2(50)  CONSTRAINT chk_bat_style CHECK (
                                    batting_style IN ('Right-hand','Left-hand')),
    bowling_style VARCHAR2(80),
    jersey_number NUMBER,
    date_of_birth DATE,
    nationality   VARCHAR2(100),
    is_active     CHAR(1) DEFAULT 'Y' CONSTRAINT chk_active CHECK (is_active IN ('Y','N')),
    CONSTRAINT fk_player_team FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

CREATE INDEX idx_players_team ON Players(team_id);

-- ============================================================
-- TABLE 4: SERIES
-- ============================================================
CREATE TABLE Series (
    series_id    NUMBER        CONSTRAINT pk_series PRIMARY KEY,
    series_name  VARCHAR2(200) CONSTRAINT nn_series_name NOT NULL,
    series_type  VARCHAR2(20)  CONSTRAINT chk_series_type CHECK (
                                   series_type IN ('Bilateral','Tournament','World Cup','League')),
    format       VARCHAR2(10)  CONSTRAINT chk_series_format CHECK (
                                   format IN ('T20','ODI','Test','Mixed')),
    start_date   DATE,
    end_date     DATE,
    host_country VARCHAR2(100),
    CONSTRAINT chk_series_dates CHECK (end_date >= start_date OR end_date IS NULL)
);

-- ============================================================
-- TABLE 5: MATCHES
-- ============================================================
CREATE TABLE Matches (
    match_id         NUMBER       CONSTRAINT pk_matches PRIMARY KEY,
    series_id        NUMBER,
    team1_id         NUMBER       CONSTRAINT nn_match_team1 NOT NULL,
    team2_id         NUMBER       CONSTRAINT nn_match_team2 NOT NULL,
    venue_id         NUMBER       CONSTRAINT nn_match_venue NOT NULL,
    match_date       DATE         CONSTRAINT nn_match_date NOT NULL,
    match_format     VARCHAR2(10) CONSTRAINT nn_match_format NOT NULL
                                  CONSTRAINT chk_match_format CHECK (
                                      match_format IN ('T20','ODI','Test')),
    status           VARCHAR2(20) DEFAULT 'Scheduled'
                                  CONSTRAINT chk_status CHECK (
                                      status IN ('Scheduled','Live','Completed','Abandoned')),
    toss_winner_id   NUMBER,
    toss_decision    VARCHAR2(10) CONSTRAINT chk_toss CHECK (
                                      toss_decision IN ('Bat','Field') OR toss_decision IS NULL),
    team1_captain_id NUMBER,
    team2_captain_id NUMBER,
    match_number     NUMBER,
    CONSTRAINT fk_match_team1      FOREIGN KEY (team1_id)         REFERENCES Teams(team_id),
    CONSTRAINT fk_match_team2      FOREIGN KEY (team2_id)         REFERENCES Teams(team_id),
    CONSTRAINT fk_match_venue      FOREIGN KEY (venue_id)         REFERENCES Venues(venue_id),
    CONSTRAINT fk_match_series     FOREIGN KEY (series_id)        REFERENCES Series(series_id),
    CONSTRAINT fk_toss_winner      FOREIGN KEY (toss_winner_id)   REFERENCES Teams(team_id),
    CONSTRAINT fk_match_t1_captain FOREIGN KEY (team1_captain_id) REFERENCES Players(player_id),
    CONSTRAINT fk_match_t2_captain FOREIGN KEY (team2_captain_id) REFERENCES Players(player_id),
    CONSTRAINT chk_diff_teams      CHECK (team1_id <> team2_id)
);

CREATE INDEX idx_matches_date   ON Matches(match_date);
CREATE INDEX idx_matches_series ON Matches(series_id);

-- ============================================================
-- TABLE 6: SERIES_MATCHES (Junction table — N:M)
-- ============================================================
CREATE TABLE Series_Matches (
    sm_id     NUMBER CONSTRAINT pk_series_matches PRIMARY KEY,
    series_id NUMBER CONSTRAINT nn_sm_series NOT NULL,
    match_id  NUMBER CONSTRAINT nn_sm_match  NOT NULL,
    CONSTRAINT fk_sm_series    FOREIGN KEY (series_id) REFERENCES Series(series_id),
    CONSTRAINT fk_sm_match     FOREIGN KEY (match_id)  REFERENCES Matches(match_id),
    CONSTRAINT uq_series_match UNIQUE (series_id, match_id)
);

-- ============================================================
-- TABLE 7: INNINGS
-- ============================================================
CREATE TABLE Innings (
    inning_id             NUMBER CONSTRAINT pk_innings PRIMARY KEY,
    match_id              NUMBER CONSTRAINT nn_inning_match NOT NULL,
    inning_number         NUMBER CONSTRAINT nn_inning_num NOT NULL
                                 CONSTRAINT chk_inning_num CHECK (inning_number BETWEEN 1 AND 4),
    batting_team_id       NUMBER CONSTRAINT nn_bat_team NOT NULL,
    bowling_team_id       NUMBER CONSTRAINT nn_bowl_team NOT NULL,
    total_runs            NUMBER DEFAULT 0 CONSTRAINT chk_total_runs CHECK (total_runs >= 0),
    total_wickets         NUMBER DEFAULT 0 CONSTRAINT chk_total_wkts CHECK (total_wickets BETWEEN 0 AND 10),
    completed_overs       NUMBER DEFAULT 0 CONSTRAINT chk_comp_overs CHECK (completed_overs >= 0),
    balls_in_current_over NUMBER DEFAULT 0 CONSTRAINT chk_balls_curr CHECK (balls_in_current_over BETWEEN 0 AND 5),
    extras_total          NUMBER DEFAULT 0 CONSTRAINT chk_extras CHECK (extras_total >= 0),
    is_declared           CHAR(1) DEFAULT 'N' CONSTRAINT chk_declared CHECK (is_declared IN ('Y','N')),
    target_runs           NUMBER,
    CONSTRAINT fk_innings_match FOREIGN KEY (match_id)        REFERENCES Matches(match_id),
    CONSTRAINT fk_innings_bat   FOREIGN KEY (batting_team_id) REFERENCES Teams(team_id),
    CONSTRAINT fk_innings_bowl  FOREIGN KEY (bowling_team_id) REFERENCES Teams(team_id),
    CONSTRAINT uq_inning        UNIQUE (match_id, inning_number)
);

CREATE INDEX idx_innings_match ON Innings(match_id);

-- ============================================================
-- TABLE 8: OVERS
-- ============================================================
CREATE TABLE Overs (
    over_id         NUMBER CONSTRAINT pk_overs PRIMARY KEY,
    inning_id       NUMBER CONSTRAINT nn_over_inning NOT NULL,
    over_number     NUMBER CONSTRAINT nn_over_num NOT NULL
                           CONSTRAINT chk_over_num CHECK (over_number >= 1),
    bowler_id       NUMBER CONSTRAINT nn_over_bowler NOT NULL,
    runs_in_over    NUMBER DEFAULT 0 CONSTRAINT chk_runs_over CHECK (runs_in_over >= 0),
    wickets_in_over NUMBER DEFAULT 0 CONSTRAINT chk_wkts_over CHECK (wickets_in_over BETWEEN 0 AND 10),
    is_maiden       CHAR(1) DEFAULT 'N' CONSTRAINT chk_maiden CHECK (is_maiden IN ('Y','N')),
    CONSTRAINT fk_overs_inning FOREIGN KEY (inning_id) REFERENCES Innings(inning_id),
    CONSTRAINT fk_overs_bowler FOREIGN KEY (bowler_id) REFERENCES Players(player_id),
    CONSTRAINT uq_over         UNIQUE (inning_id, over_number)
);

CREATE INDEX idx_overs_inning ON Overs(inning_id);

-- ============================================================
-- TABLE 9: BALLS
-- ============================================================
CREATE TABLE Balls (
    ball_id        NUMBER       CONSTRAINT pk_balls PRIMARY KEY,
    over_id        NUMBER       CONSTRAINT nn_ball_over NOT NULL,
    ball_number    NUMBER       CONSTRAINT nn_ball_num NOT NULL
                                CONSTRAINT chk_ball_num CHECK (ball_number >= 1),
    batsman_id     NUMBER       CONSTRAINT nn_ball_bat NOT NULL,
    non_striker_id NUMBER       CONSTRAINT nn_ball_ns NOT NULL,
    bowler_id      NUMBER       CONSTRAINT nn_ball_bowl NOT NULL,
    runs_scored    NUMBER DEFAULT 0  CONSTRAINT chk_runs_scored CHECK (runs_scored >= 0),
    extra_runs     NUMBER DEFAULT 0  CONSTRAINT chk_extra_runs CHECK (extra_runs >= 0),
    extra_type     VARCHAR2(20) CONSTRAINT chk_extra_type CHECK (
                                    extra_type IN ('Wide','No-Ball','Bye','Leg-Bye')
                                    OR extra_type IS NULL),
    is_wicket      CHAR(1) DEFAULT 'N' CONSTRAINT chk_is_wicket   CHECK (is_wicket   IN ('Y','N')),
    is_extra       CHAR(1) DEFAULT 'N' CONSTRAINT chk_is_extra    CHECK (is_extra    IN ('Y','N')),
    is_boundary    CHAR(1) DEFAULT 'N' CONSTRAINT chk_is_boundary CHECK (is_boundary IN ('Y','N')),
    CONSTRAINT fk_balls_over        FOREIGN KEY (over_id)        REFERENCES Overs(over_id),
    CONSTRAINT fk_balls_batsman     FOREIGN KEY (batsman_id)     REFERENCES Players(player_id),
    CONSTRAINT fk_balls_non_striker FOREIGN KEY (non_striker_id) REFERENCES Players(player_id),
    CONSTRAINT fk_balls_bowler      FOREIGN KEY (bowler_id)      REFERENCES Players(player_id),
    CONSTRAINT uq_ball              UNIQUE (over_id, ball_number)
);

CREATE INDEX idx_balls_over    ON Balls(over_id);
CREATE INDEX idx_balls_batsman ON Balls(batsman_id);
CREATE INDEX idx_balls_bowler  ON Balls(bowler_id);

-- ============================================================
-- TABLE 10: BATTING_SCORECARD
-- ============================================================
CREATE TABLE Batting_Scorecard (
    scorecard_id        NUMBER       CONSTRAINT pk_bsc PRIMARY KEY,
    inning_id           NUMBER       CONSTRAINT nn_bsc_inning NOT NULL,
    player_id           NUMBER       CONSTRAINT nn_bsc_player NOT NULL,
    batting_position    NUMBER       CONSTRAINT chk_bat_pos CHECK (batting_position BETWEEN 1 AND 11),
    runs                NUMBER DEFAULT 0  CONSTRAINT chk_bsc_runs  CHECK (runs  >= 0),
    balls               NUMBER DEFAULT 0  CONSTRAINT chk_bsc_balls CHECK (balls >= 0),
    fours               NUMBER DEFAULT 0  CONSTRAINT chk_bsc_fours CHECK (fours >= 0),
    sixes               NUMBER DEFAULT 0  CONSTRAINT chk_bsc_sixes CHECK (sixes >= 0),
    out_status          VARCHAR2(20) DEFAULT 'Not Out'
                                     CONSTRAINT chk_out_status CHECK (
                                         out_status IN ('Not Out','Out','Retired Hurt')),
    dismissal_type      VARCHAR2(30) CONSTRAINT chk_dismissal CHECK (
                                         dismissal_type IN (
                                             'Bowled','Caught','LBW','Run Out',
                                             'Stumped','Hit Wicket','Retired','Obstructing'
                                         ) OR dismissal_type IS NULL),
    fielder_id          NUMBER,
    dismissal_bowler_id NUMBER,
    CONSTRAINT fk_bsc_inning  FOREIGN KEY (inning_id)           REFERENCES Innings(inning_id),
    CONSTRAINT fk_bsc_player  FOREIGN KEY (player_id)           REFERENCES Players(player_id),
    CONSTRAINT fk_bsc_fielder FOREIGN KEY (fielder_id)          REFERENCES Players(player_id),
    CONSTRAINT fk_bsc_bowler  FOREIGN KEY (dismissal_bowler_id) REFERENCES Players(player_id),
    CONSTRAINT uq_bsc         UNIQUE (inning_id, player_id)
);

-- ============================================================
-- TABLE 11: BOWLING_SCORECARD
-- ============================================================
CREATE TABLE Bowling_Scorecard (
    bowling_id    NUMBER CONSTRAINT pk_blsc PRIMARY KEY,
    inning_id     NUMBER CONSTRAINT nn_blsc_inning NOT NULL,
    player_id     NUMBER CONSTRAINT nn_blsc_player NOT NULL,
    overs         NUMBER DEFAULT 0 CONSTRAINT chk_blsc_overs   CHECK (overs         >= 0),
    balls_bowled  NUMBER DEFAULT 0 CONSTRAINT chk_blsc_balls   CHECK (balls_bowled  BETWEEN 0 AND 5),
    runs_conceded NUMBER DEFAULT 0 CONSTRAINT chk_blsc_runs    CHECK (runs_conceded >= 0),
    wickets       NUMBER DEFAULT 0 CONSTRAINT chk_blsc_wkts    CHECK (wickets       BETWEEN 0 AND 10),
    maidens       NUMBER DEFAULT 0 CONSTRAINT chk_blsc_maidens CHECK (maidens       >= 0),
    wides         NUMBER DEFAULT 0 CONSTRAINT chk_blsc_wides   CHECK (wides         >= 0),
    no_balls      NUMBER DEFAULT 0 CONSTRAINT chk_blsc_nbs     CHECK (no_balls      >= 0),
    CONSTRAINT fk_blsc_inning FOREIGN KEY (inning_id) REFERENCES Innings(inning_id),
    CONSTRAINT fk_blsc_player FOREIGN KEY (player_id) REFERENCES Players(player_id),
    CONSTRAINT uq_blsc        UNIQUE (inning_id, player_id)
);

-- ============================================================
-- TABLE 12: MATCH_RESULT
-- ============================================================
CREATE TABLE Match_Result (
    result_id          NUMBER        CONSTRAINT pk_result PRIMARY KEY,
    match_id           NUMBER        CONSTRAINT nn_result_match NOT NULL UNIQUE,
    winning_team_id    NUMBER,
    win_margin         NUMBER        CONSTRAINT chk_win_margin CHECK (win_margin >= 0 OR win_margin IS NULL),
    win_margin_type    VARCHAR2(20)  CONSTRAINT chk_margin_type CHECK (
                                         win_margin_type IN ('Runs','Wickets','Draw','Tie','No Result')
                                         OR win_margin_type IS NULL),
    man_of_match       NUMBER,
    result_description VARCHAR2(255),
    CONSTRAINT fk_result_match  FOREIGN KEY (match_id)         REFERENCES Matches(match_id),
    CONSTRAINT fk_result_winner FOREIGN KEY (winning_team_id)  REFERENCES Teams(team_id),
    CONSTRAINT fk_result_mom    FOREIGN KEY (man_of_match)      REFERENCES Players(player_id)
);

-- ============================================================
-- TABLE 13: AUDIT_LOG
-- ============================================================
CREATE TABLE Audit_Log (
    audit_id    NUMBER        CONSTRAINT pk_audit PRIMARY KEY,
    table_name  VARCHAR2(50)  CONSTRAINT nn_audit_table NOT NULL,
    operation   VARCHAR2(10)  CONSTRAINT chk_audit_op CHECK (operation IN ('INSERT','UPDATE','DELETE')),
    record_id   NUMBER,
    changed_by  VARCHAR2(100) DEFAULT USER,
    changed_at  TIMESTAMP     DEFAULT SYSTIMESTAMP,
    old_value   VARCHAR2(4000),
    new_value   VARCHAR2(4000),
    description VARCHAR2(500)
);

COMMIT;

-- Verify
SELECT table_name FROM user_tables
WHERE table_name IN (
    'TEAMS','VENUES','PLAYERS','SERIES','MATCHES','SERIES_MATCHES',
    'INNINGS','OVERS','BALLS','BATTING_SCORECARD',
    'BOWLING_SCORECARD','MATCH_RESULT','AUDIT_LOG'
)
ORDER BY table_name;