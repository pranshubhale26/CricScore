import React, { useState, useEffect } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";

function Field({ label, children, span }) {
  return (
    <div style={span ? { gridColumn: `span ${span}` } : {}}>
      <label style={{
        fontSize: 11, fontWeight: 700, color: "var(--gray-600)",
        display: "block", marginBottom: 5,
        textTransform: "uppercase", letterSpacing: "0.5px"
      }}>{label}</label>
      {children}
    </div>
  );
}

export default function PastMatch() {
  const [teams, setTeams]       = useState([]);
  const [venues, setVenues]     = useState([]);
  const [step, setStep]         = useState(1);
  const [msg, setMsg]           = useState({ text: "", ok: true });
  const [matchId, setMatchId]   = useState(null);

  // Store team IDs as plain variables after match creation
  const [team1Id, setTeam1Id]   = useState("");
  const [team2Id, setTeam2Id]   = useState("");

  // Players fetched directly — stored as arrays per team
  const [team1Players, setTeam1Players] = useState([]);
  const [team2Players, setTeam2Players] = useState([]);

  const [matchForm, setMatchForm] = useState({
    team1_id: "", team2_id: "", venue_id: "",
    match_date: "", match_format: "ODI",
    toss_winner_id: "", toss_decision: "Bat",
    series_name: "", series_type: "Tournament",
  });

  const [result, setResult] = useState({
    winning_team_id: "", win_margin: "",
    win_margin_type: "Runs", man_of_match: "",
    result_description: "",
  });

  const [innings, setInnings] = useState([
    { inning_number: 1, batting_team_id: "", bowling_team_id: "",
      total_runs: "", total_wickets: "", completed_overs: "",
      extras_total: "", batting: [], bowling: [] },
    { inning_number: 2, batting_team_id: "", bowling_team_id: "",
      total_runs: "", total_wickets: "", completed_overs: "",
      extras_total: "", batting: [], bowling: [] },
  ]);

  useEffect(() => {
    Promise.all([axios.get(`${API}/teams`), axios.get(`${API}/venues`)])
      .then(([t, v]) => { setTeams(t.data); setVenues(v.data); });
  }, []);

  const show = (text, ok = true) => {
    setMsg({ text, ok });
    setTimeout(() => setMsg({ text: "", ok: true }), 5000);
  };

  // Called after match is created — directly fetch players for both teams
  const fetchPlayersForTeams = async (t1, t2) => {
    try {
      const [r1, r2] = await Promise.all([
        axios.get(`${API}/players?team_id=${t1}`),
        axios.get(`${API}/players?team_id=${t2}`),
      ]);
      setTeam1Players(r1.data);
      setTeam2Players(r2.data);
    } catch (e) {
      console.error("Failed to fetch players:", e);
    }
  };

  const createMatch = async () => {
    if (!matchForm.team1_id || !matchForm.team2_id || !matchForm.venue_id || !matchForm.match_date) {
      show("Please fill Team 1, Team 2, Venue and Date.", false);
      return;
    }
    try {
      let sid = null;
      if (matchForm.series_name.trim()) {
        const sr = await axios.post(`${API}/series`, {
          series_name: matchForm.series_name,
          series_type: matchForm.series_type,
          format: matchForm.match_format,
        });
        sid = sr.data.series_id;
      }

      const r = await axios.post(`${API}/matches`, { ...matchForm, series_id: sid });
      const newMatchId = r.data.match_id;
      setMatchId(newMatchId);

      const t1 = matchForm.team1_id;
      const t2 = matchForm.team2_id;
      setTeam1Id(t1);
      setTeam2Id(t2);

      // Fetch players immediately and directly
      await fetchPlayersForTeams(t1, t2);

      // Pre-fill inning teams
      setInnings(prev => prev.map((inn, i) => ({
        ...inn,
        batting_team_id: i === 0 ? t1 : t2,
        bowling_team_id: i === 0 ? t2 : t1,
      })));

      setStep(2);
      show("Match created! Now fill in the innings.");
    } catch (e) {
      show("Error: " + (e.response?.data?.error || e.message), false);
    }
  };

  const submitAll = async () => {
    try {
      await axios.post(`${API}/scoring/past-match`, { match_id: matchId, innings });
      if (result.winning_team_id) {
        await axios.post(`${API}/matches/${matchId}/result`, result);
      }
      show("Match saved successfully!");
      setStep(3);
    } catch (e) {
      show("Error: " + (e.response?.data?.error || e.message), false);
    }
  };

  const addBatsman = (idx) => {
    const u = [...innings];
    u[idx].batting.push({
      player_id: "", runs: 0, balls: 0, fours: 0, sixes: 0,
      out_status: "Not Out", dismissal_type: "",
      fielder_id: "", dismissal_bowler_id: ""
    });
    setInnings(u);
  };

  const addBowler = (idx) => {
    const u = [...innings];
    u[idx].bowling.push({
      player_id: "", overs: 0, runs_conceded: 0,
      wickets: 0, maidens: 0, wides: 0, no_balls: 0
    });
    setInnings(u);
  };

  const updateBat  = (idx, bi, f, v) => { const u = [...innings]; u[idx].batting[bi][f] = v; setInnings(u); };
  const updateBowl = (idx, bi, f, v) => { const u = [...innings]; u[idx].bowling[bi][f] = v; setInnings(u); };
  const updateInn  = (idx, f, v)     => { const u = [...innings]; u[idx][f] = v; setInnings(u); };

  // Get players for a given team ID using the directly fetched arrays
  const getPlayers = (tid) => {
    if (!tid) return [];
    if (String(tid) === String(team1Id)) return team1Players;
    if (String(tid) === String(team2Id)) return team2Players;
    return [];
  };

  const allPlayers = [...team1Players, ...team2Players];
  const activeTeams = teams.filter(t =>
    [String(team1Id), String(team2Id)].includes(String(t.TEAM_ID))
  );

  const inp = "inp";

  return (
    <div style={{ padding: "28px 32px" }} className="fade-in">
      <h1 style={{ fontSize: 22, fontWeight: 800, letterSpacing: "-0.4px", marginBottom: 6 }}>
        Past Match Entry
      </h1>
      <p style={{ color: "var(--gray-400)", fontSize: 13, marginBottom: 24 }}>
        Record historical match scorecards into the database
      </p>

      {msg.text && (
        <div style={{
          marginBottom: 16, padding: "11px 16px",
          borderRadius: "var(--radius-sm)", fontWeight: 500, fontSize: 13,
          background: msg.ok ? "var(--green-lt)" : "#FFF0F0",
          color: msg.ok ? "var(--green)" : "var(--primary)",
          border: `1px solid ${msg.ok ? "#A5D6A7" : "#FFCDD2"}`,
        }}>{msg.text}</div>
      )}

      {/* STEP 1 */}
      <div className="card" style={{ padding: 24, marginBottom: 16 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 18 }}>
          <h2 style={{ fontSize: 15, fontWeight: 700, margin: 0 }}>Step 1 — Match Details</h2>
          {matchId && <span className="tag tag-green">Match #{matchId} created</span>}
        </div>

        {!matchId ? (
          <>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
              <Field label="Team 1 *">
                <select className={inp} value={matchForm.team1_id}
                  onChange={e => setMatchForm({ ...matchForm, team1_id: e.target.value })}>
                  <option value="">Select Team</option>
                  {teams.map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
                </select>
              </Field>
              <Field label="Team 2 *">
                <select className={inp} value={matchForm.team2_id}
                  onChange={e => setMatchForm({ ...matchForm, team2_id: e.target.value })}>
                  <option value="">Select Team</option>
                  {teams.map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
                </select>
              </Field>
              <Field label="Venue *">
                <select className={inp} value={matchForm.venue_id}
                  onChange={e => setMatchForm({ ...matchForm, venue_id: e.target.value })}>
                  <option value="">Select Venue</option>
                  {venues.map(v => <option key={v.VENUE_ID} value={v.VENUE_ID}>{v.VENUE_NAME}, {v.CITY}</option>)}
                </select>
              </Field>
              <Field label="Format">
                <select className={inp} value={matchForm.match_format}
                  onChange={e => setMatchForm({ ...matchForm, match_format: e.target.value })}>
                  <option>T20</option><option>ODI</option><option>Test</option>
                </select>
              </Field>
              <Field label="Date *">
                <input type="date" className={inp} value={matchForm.match_date}
                  onChange={e => setMatchForm({ ...matchForm, match_date: e.target.value })} />
              </Field>
              <Field label="Toss Decision">
                <select className={inp} value={matchForm.toss_decision}
                  onChange={e => setMatchForm({ ...matchForm, toss_decision: e.target.value })}>
                  <option>Bat</option><option>Field</option>
                </select>
              </Field>
              <Field label="Toss Winner">
                <select className={inp} value={matchForm.toss_winner_id}
                  onChange={e => setMatchForm({ ...matchForm, toss_winner_id: e.target.value })}>
                  <option value="">Select</option>
                  {teams.filter(t =>
                    [String(matchForm.team1_id), String(matchForm.team2_id)].includes(String(t.TEAM_ID))
                  ).map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
                </select>
              </Field>
            </div>

            <div style={{ borderTop: "1px solid var(--gray-200)", paddingTop: 16, marginBottom: 16 }}>
              <div style={{ fontSize: 11, fontWeight: 700, color: "var(--gray-600)", marginBottom: 12, textTransform: "uppercase", letterSpacing: "0.5px" }}>
                Series / Tournament (optional)
              </div>
              <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr", gap: 16 }}>
                <Field label="Series / Tournament Name">
                  <input className={inp}
                    placeholder="e.g. ICC World Cup 2023, IPL 2024"
                    value={matchForm.series_name}
                    onChange={e => setMatchForm({ ...matchForm, series_name: e.target.value })} />
                </Field>
                <Field label="Type">
                  <select className={inp} value={matchForm.series_type}
                    onChange={e => setMatchForm({ ...matchForm, series_type: e.target.value })}>
                    <option>Tournament</option>
                    <option>World Cup</option>
                    <option>Bilateral</option>
                    <option>League</option>
                  </select>
                </Field>
              </div>
            </div>
            <button className="btn-primary" onClick={createMatch}>Create Match</button>
          </>
        ) : (
          <div style={{ fontSize: 13, color: "var(--gray-600)" }}>
            Match #{matchId} ready.
            Team 1 players loaded: <b>{team1Players.length}</b> |
            Team 2 players loaded: <b>{team2Players.length}</b>
          </div>
        )}
      </div>

      {/* STEP 2 — Innings */}
      {step >= 2 && innings.map((inn, idx) => (
        <div key={idx} className="card" style={{ padding: 24, marginBottom: 16 }}>
          <h2 style={{ fontSize: 15, fontWeight: 700, marginBottom: 18 }}>
            Step 2 — Inning {inn.inning_number}
          </h2>

          <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 14, marginBottom: 20 }}>
            <Field label="Batting Team">
              <select className={inp} value={inn.batting_team_id}
                onChange={e => updateInn(idx, "batting_team_id", e.target.value)}>
                <option value="">Select</option>
                {activeTeams.map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
              </select>
            </Field>
            <Field label="Bowling Team">
              <select className={inp} value={inn.bowling_team_id}
                onChange={e => updateInn(idx, "bowling_team_id", e.target.value)}>
                <option value="">Select</option>
                {activeTeams.map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
              </select>
            </Field>
            <Field label="Total Runs">
              <input type="number" min="0" className={inp} value={inn.total_runs}
                onChange={e => updateInn(idx, "total_runs", e.target.value)} />
            </Field>
            <Field label="Wickets">
              <input type="number" min="0" max="10" className={inp} value={inn.total_wickets}
                onChange={e => updateInn(idx, "total_wickets", e.target.value)} />
            </Field>
            <Field label="Overs">
              <input type="number" min="0" className={inp} value={inn.completed_overs}
                onChange={e => updateInn(idx, "completed_overs", e.target.value)} />
            </Field>
            <Field label="Extras">
              <input type="number" min="0" className={inp} value={inn.extras_total}
                onChange={e => updateInn(idx, "extras_total", e.target.value)} />
            </Field>
          </div>

          {/* Batting */}
          <div style={{ marginBottom: 20 }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
              <span style={{ fontSize: 12, fontWeight: 700, color: "var(--gray-600)", textTransform: "uppercase", letterSpacing: "0.5px" }}>
                Batting Scorecard ({getPlayers(inn.batting_team_id).length} players available)
              </span>
              <button onClick={() => addBatsman(idx)}
                style={{ background: "var(--blue)", color: "#fff", border: "none", borderRadius: "var(--radius-sm)", padding: "6px 14px", cursor: "pointer", fontSize: 12, fontWeight: 600 }}>
                + Add Batsman
              </button>
            </div>

            {inn.batting.map((b, bi) => (
              <div key={bi} style={{ display: "grid", gridTemplateColumns: "2fr 60px 60px 50px 50px 140px 160px", gap: 8, marginBottom: 8 }}>
                <select className={inp} value={b.player_id}
                  onChange={e => updateBat(idx, bi, "player_id", e.target.value)}>
                  <option value="">Select Batsman</option>
                  {getPlayers(inn.batting_team_id).map(p =>
                    <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>
                  )}
                </select>
                <input type="number" min="0" placeholder="R" className={inp} value={b.runs}
                  onChange={e => updateBat(idx, bi, "runs", e.target.value)} />
                <input type="number" min="0" placeholder="B" className={inp} value={b.balls}
                  onChange={e => updateBat(idx, bi, "balls", e.target.value)} />
                <input type="number" min="0" placeholder="4s" className={inp} value={b.fours}
                  onChange={e => updateBat(idx, bi, "fours", e.target.value)} />
                <input type="number" min="0" placeholder="6s" className={inp} value={b.sixes}
                  onChange={e => updateBat(idx, bi, "sixes", e.target.value)} />
                <select className={inp} value={b.out_status}
                  onChange={e => updateBat(idx, bi, "out_status", e.target.value)}>
                  <option>Not Out</option><option>Out</option><option>Retired Hurt</option>
                </select>
                <select className={inp} value={b.dismissal_type}
                  onChange={e => updateBat(idx, bi, "dismissal_type", e.target.value)}>
                  <option value="">How out?</option>
                  {["Bowled","Caught","LBW","Run Out","Stumped","Hit Wicket"].map(d =>
                    <option key={d}>{d}</option>
                  )}
                </select>
              </div>
            ))}
          </div>

          {/* Bowling */}
          <div>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 10 }}>
              <span style={{ fontSize: 12, fontWeight: 700, color: "var(--gray-600)", textTransform: "uppercase", letterSpacing: "0.5px" }}>
                Bowling Scorecard ({getPlayers(inn.bowling_team_id).length} players available)
              </span>
              <button onClick={() => addBowler(idx)}
                style={{ background: "var(--primary)", color: "#fff", border: "none", borderRadius: "var(--radius-sm)", padding: "6px 14px", cursor: "pointer", fontSize: 12, fontWeight: 600 }}>
                + Add Bowler
              </button>
            </div>

            {inn.bowling.map((b, bi) => (
              <div key={bi} style={{ display: "grid", gridTemplateColumns: "2fr 70px 70px 70px 70px 70px", gap: 8, marginBottom: 8 }}>
                <select className={inp} value={b.player_id}
                  onChange={e => updateBowl(idx, bi, "player_id", e.target.value)}>
                  <option value="">Select Bowler</option>
                  {getPlayers(inn.bowling_team_id).map(p =>
                    <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>
                  )}
                </select>
                {[["Ov","overs"],["R","runs_conceded"],["W","wickets"],["M","maidens"],["Wd","wides"]].map(([ph, f]) => (
                  <input key={f} type="number" min="0" placeholder={ph} className={inp} value={b[f]}
                    onChange={e => updateBowl(idx, bi, f, e.target.value)} />
                ))}
              </div>
            ))}
          </div>
        </div>
      ))}

      {/* STEP 3 — Result */}
      {step >= 2 && (
        <div className="card" style={{ padding: 24, marginBottom: 16 }}>
          <h2 style={{ fontSize: 15, fontWeight: 700, marginBottom: 18 }}>Step 3 — Match Result</h2>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 16 }}>
            <Field label="Winning Team">
              <select className={inp} value={result.winning_team_id}
                onChange={e => setResult({ ...result, winning_team_id: e.target.value })}>
                <option value="">Select</option>
                {activeTeams.map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
              </select>
            </Field>
            <Field label="Win Margin">
              <input type="number" className={inp} value={result.win_margin}
                onChange={e => setResult({ ...result, win_margin: e.target.value })} />
            </Field>
            <Field label="Margin Type">
              <select className={inp} value={result.win_margin_type}
                onChange={e => setResult({ ...result, win_margin_type: e.target.value })}>
                {["Runs","Wickets","Draw","Tie","No Result"].map(t => <option key={t}>{t}</option>)}
              </select>
            </Field>
            <Field label="Man of the Match">
              <select className={inp} value={result.man_of_match}
                onChange={e => setResult({ ...result, man_of_match: e.target.value })}>
                <option value="">Select</option>
                {allPlayers.map(p => <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>)}
              </select>
            </Field>
            <Field label="Result Description" span={2}>
              <input className={inp}
                placeholder="e.g. India won by 7 wickets"
                value={result.result_description}
                onChange={e => setResult({ ...result, result_description: e.target.value })} />
            </Field>
          </div>
          <button className="btn-primary" style={{ marginTop: 16 }} onClick={submitAll}>
            Save All Match Data
          </button>
        </div>
      )}

      {step === 3 && (
        <div style={{
          background: "var(--green-lt)", border: "1px solid #A5D6A7",
          borderRadius: "var(--radius-md)", padding: "20px 24px", textAlign: "center"
        }}>
          <div style={{ fontWeight: 700, fontSize: 16, color: "var(--green)" }}>Match saved successfully!</div>
          <div style={{ fontSize: 13, color: "var(--green)", opacity: 0.8, marginTop: 4 }}>
            View the scorecard in the Matches section.
          </div>
        </div>
      )}
    </div>
  );
}