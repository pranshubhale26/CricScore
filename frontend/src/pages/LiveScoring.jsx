import React, { useState, useEffect } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";
const DISMISSALS = ["Bowled","Caught","LBW","Run Out","Stumped","Hit Wicket","Retired","Obstructing"];
const EXTRAS     = ["Wide","No-Ball","Bye","Leg-Bye"];

function Field({ label, children }) {
  return (
    <div>
      <label style={{
        fontSize: 11, fontWeight: 700, color: "var(--gray-600)",
        display: "block", marginBottom: 5,
        textTransform: "uppercase", letterSpacing: "0.5px"
      }}>{label}</label>
      {children}
    </div>
  );
}

export default function LiveScoring() {
  const [step, setStep]     = useState("setup");
  const [teams, setTeams]   = useState([]);
  const [venues, setVenues] = useState([]);
  const [msg, setMsg]       = useState({ text: "", ok: true });

  // Single flat array of all players for both teams
  const [allPlayers, setAllPlayers] = useState([]);

  const [matchForm, setMatchForm] = useState({
    team1_id: "", team2_id: "", venue_id: "",
    match_date: new Date().toISOString().split("T")[0],
    match_format: "T20", toss_winner_id: "",
    toss_decision: "Bat", series_name: "", series_type: "Tournament",
  });
  const [matchId, setMatchId] = useState(null);

  // Store team IDs after match is locked in
  const [lockedTeam1, setLockedTeam1] = useState("");
  const [lockedTeam2, setLockedTeam2] = useState("");

  const [inningForm, setInningForm] = useState({
    batting_team_id: "", bowling_team_id: "", inning_number: 1
  });
  const [inningId, setInningId] = useState(null);

  const [overForm, setOverForm] = useState({ bowler_id: "", over_number: 1 });
  const [overId, setOverId]     = useState(null);

  const [ballForm, setBallForm] = useState({
    batsman_id: "", non_striker_id: "", runs_scored: 0,
    is_wicket: "N", is_extra: "N", extra_type: "",
    extra_runs: 0, dismissal_type: "", fielder_id: "",
  });
  const [ballNumber, setBallNumber] = useState(1);
  const [balls, setBalls]           = useState([]);

  useEffect(() => {
    Promise.all([axios.get(`${API}/teams`), axios.get(`${API}/venues`)])
      .then(([t, v]) => { setTeams(t.data); setVenues(v.data); });
  }, []);

  const show = (text, ok = true) => {
    setMsg({ text, ok });
    setTimeout(() => setMsg({ text: "", ok: true }), 4000);
  };

  const createMatch = async () => {
    if (!matchForm.team1_id || !matchForm.team2_id || !matchForm.venue_id) {
      show("Please select Team 1, Team 2 and Venue.", false); return;
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
      setMatchId(r.data.match_id);

      // Fetch players for both teams immediately
      const [r1, r2] = await Promise.all([
        axios.get(`${API}/players?team_id=${matchForm.team1_id}`),
        axios.get(`${API}/players?team_id=${matchForm.team2_id}`),
      ]);
      setAllPlayers([...r1.data, ...r2.data]);
      setLockedTeam1(matchForm.team1_id);
      setLockedTeam2(matchForm.team2_id);

      // Pre-fill inning: team1 bats first
      setInningForm({
        batting_team_id: matchForm.team1_id,
        bowling_team_id: matchForm.team2_id,
        inning_number: 1,
      });

      setStep("inning");
      show(`Match created. Players loaded: ${r1.data.length + r2.data.length} total.`);
    } catch (e) { show("Error: " + (e.response?.data?.error || e.message), false); }
  };

  const startInning = async () => {
    if (!inningForm.batting_team_id || !inningForm.bowling_team_id) {
      show("Please select batting and bowling teams.", false); return;
    }
    try {
      const r = await axios.post(`${API}/innings`, { ...inningForm, match_id: matchId });
      setInningId(r.data.inning_id);
      setStep("over");
      show("Inning started. Now select a bowler to start Over 1.");
    } catch (e) { show("Error: " + (e.response?.data?.error || e.message), false); }
  };

  const startOver = async () => {
    if (!overForm.bowler_id) { show("Please select a bowler.", false); return; }
    try {
      const r = await axios.post(`${API}/innings/${inningId}/overs`, overForm);
      setOverId(r.data.over_id);
      setBallNumber(1);
      setBalls([]);
      setStep("ball");
      show(`Over ${overForm.over_number} started.`);
    } catch (e) { show("Error: " + (e.response?.data?.error || e.message), false); }
  };

  const recordBall = async () => {
    if (!ballForm.batsman_id || !ballForm.non_striker_id) {
      show("Please select batsman and non-striker.", false); return;
    }
    try {
      const payload = {
        over_id: overId, ball_number: ballNumber, ...ballForm,
        runs_scored: parseInt(ballForm.runs_scored) || 0,
        extra_runs:  parseInt(ballForm.extra_runs)  || 0,
        extra_type:  ballForm.is_extra === "Y" ? ballForm.extra_type : null,
        fielder_id:  ballForm.fielder_id || null,
        dismissal_type: ballForm.is_wicket === "Y" ? ballForm.dismissal_type : null,
      };
      const r = await axios.post(`${API}/scoring/ball`, payload);
      show(r.data.message);
      setBalls(p => [...p, payload]);
      setBallNumber(p => p + 1);
      setBallForm({
        batsman_id: "", non_striker_id: "", runs_scored: 0,
        is_wicket: "N", is_extra: "N", extra_type: "",
        extra_runs: 0, dismissal_type: "", fielder_id: "",
      });
      if (ballNumber >= 6) {
        show("Over complete! Select next bowler.");
        setStep("over");
        setOverForm(p => ({ ...p, over_number: p.over_number + 1, bowler_id: "" }));
      }
    } catch (e) { show("Error: " + (e.response?.data?.error || e.message), false); }
  };

  // ── Compute player lists at render time (no async state issues) ─────────
  const battingPlayers = allPlayers.filter(
    p => String(p.TEAM_ID) === String(inningForm.batting_team_id)
  );
  const bowlingPlayers = allPlayers.filter(
    p => String(p.TEAM_ID) === String(inningForm.bowling_team_id)
  );
  const matchTeams = teams.filter(t =>
    [String(lockedTeam1), String(lockedTeam2)].includes(String(t.TEAM_ID))
  );

  const steps = ["setup", "inning", "over", "ball"];
  const stepLabels = ["Create Match", "Start Inning", "Start Over", "Record Balls"];
  const inp = "inp";

  return (
    <div style={{ padding: "28px 32px" }} className="fade-in">
      <h1 style={{ fontSize: 22, fontWeight: 800, letterSpacing: "-0.4px", marginBottom: 6 }}>
        Live Scoring
      </h1>
      <p style={{ color: "var(--gray-400)", fontSize: 13, marginBottom: 24 }}>
        Enter ball-by-ball data in real time
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

      {/* Progress steps */}
      <div style={{
        display: "flex", marginBottom: 24,
        background: "var(--white)", border: "1px solid var(--gray-200)",
        borderRadius: "var(--radius-md)", overflow: "hidden", boxShadow: "var(--shadow-sm)"
      }}>
        {steps.map((s, i) => {
          const done    = steps.indexOf(step) > i;
          const current = step === s;
          return (
            <div key={s} style={{
              flex: 1, padding: "12px 16px", textAlign: "center",
              background: current ? "var(--navy)" : done ? "var(--green-lt)" : "transparent",
              borderRight: i < 3 ? "1px solid var(--gray-200)" : "none",
            }}>
              <div style={{
                fontSize: 11, fontWeight: 700, textTransform: "uppercase",
                letterSpacing: "0.5px",
                color: current ? "rgba(255,255,255,0.6)" : done ? "var(--green)" : "var(--gray-400)"
              }}>Step {i + 1}</div>
              <div style={{
                fontSize: 13, fontWeight: 600, marginTop: 2,
                color: current ? "#fff" : done ? "var(--green)" : "var(--gray-600)"
              }}>{stepLabels[i]}</div>
            </div>
          );
        })}
      </div>

      <div className="card" style={{ padding: 28 }}>

        {/* ── STEP 1: Create Match ── */}
        {step === "setup" && (
          <div>
            <h2 style={{ fontSize: 16, fontWeight: 700, marginBottom: 20 }}>Match Details</h2>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 20 }}>
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
                  {venues.map(v =>
                    <option key={v.VENUE_ID} value={v.VENUE_ID}>{v.VENUE_NAME}, {v.CITY}</option>
                  )}
                </select>
              </Field>
              <Field label="Format">
                <select className={inp} value={matchForm.match_format}
                  onChange={e => setMatchForm({ ...matchForm, match_format: e.target.value })}>
                  <option>T20</option><option>ODI</option><option>Test</option>
                </select>
              </Field>
              <Field label="Match Date *">
                <input type="date" className={inp} value={matchForm.match_date}
                  onChange={e => setMatchForm({ ...matchForm, match_date: e.target.value })} />
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
              <Field label="Toss Decision">
                <select className={inp} value={matchForm.toss_decision}
                  onChange={e => setMatchForm({ ...matchForm, toss_decision: e.target.value })}>
                  <option>Bat</option><option>Field</option>
                </select>
              </Field>
            </div>

            <div style={{ borderTop: "1px solid var(--gray-200)", paddingTop: 20, marginBottom: 20 }}>
              <div style={{
                fontSize: 11, fontWeight: 700, color: "var(--gray-600)",
                marginBottom: 14, textTransform: "uppercase", letterSpacing: "0.5px"
              }}>
                Series / Tournament (optional)
              </div>
              <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr", gap: 16 }}>
                <Field label="Series / Tournament Name">
                  <input className={inp}
                    placeholder="e.g. ICC World Cup 2024, IPL 2024"
                    value={matchForm.series_name}
                    onChange={e => setMatchForm({ ...matchForm, series_name: e.target.value })} />
                </Field>
                <Field label="Type">
                  <select className={inp} value={matchForm.series_type}
                    onChange={e => setMatchForm({ ...matchForm, series_type: e.target.value })}>
                    <option>Tournament</option><option>World Cup</option>
                    <option>Bilateral</option><option>League</option>
                  </select>
                </Field>
              </div>
            </div>
            <button className="btn-primary" onClick={createMatch}>Create Match</button>
          </div>
        )}

        {/* ── STEP 2: Start Inning ── */}
        {step === "inning" && (
          <div>
            <h2 style={{ fontSize: 16, fontWeight: 700, marginBottom: 6 }}>
              Start Inning {inningForm.inning_number}
            </h2>
            <p style={{ fontSize: 12, color: "var(--gray-400)", marginBottom: 20 }}>
              {allPlayers.length} players loaded for both teams
            </p>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 20 }}>
              <Field label="Batting Team">
                <select className={inp} value={inningForm.batting_team_id}
                  onChange={e => setInningForm({ ...inningForm, batting_team_id: e.target.value })}>
                  <option value="">Select</option>
                  {matchTeams.map(t =>
                    <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>
                  )}
                </select>
              </Field>
              <Field label="Bowling Team">
                <select className={inp} value={inningForm.bowling_team_id}
                  onChange={e => setInningForm({ ...inningForm, bowling_team_id: e.target.value })}>
                  <option value="">Select</option>
                  {matchTeams.map(t =>
                    <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>
                  )}
                </select>
              </Field>
            </div>
            {inningForm.batting_team_id && (
              <div style={{ fontSize: 12, color: "var(--gray-400)", marginBottom: 16 }}>
                Batting players: {battingPlayers.length} | Bowling players: {bowlingPlayers.length}
              </div>
            )}
            <button className="btn-primary" onClick={startInning}>Start Inning</button>
          </div>
        )}

        {/* ── STEP 3: Start Over ── */}
        {step === "over" && (
          <div>
            <h2 style={{ fontSize: 16, fontWeight: 700, marginBottom: 6 }}>
              Over {overForm.over_number}
            </h2>
            <p style={{ fontSize: 12, color: "var(--gray-400)", marginBottom: 20 }}>
              {bowlingPlayers.length} bowling players available
            </p>
            <Field label="Select Bowler">
              <select className={inp} style={{ maxWidth: 360 }}
                value={overForm.bowler_id}
                onChange={e => setOverForm({ ...overForm, bowler_id: e.target.value })}>
                <option value="">Select Bowler</option>
                {bowlingPlayers.map(p =>
                  <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>
                )}
              </select>
            </Field>
            <button className="btn-primary" style={{ marginTop: 20 }} onClick={startOver}>
              Start Over {overForm.over_number}
            </button>
          </div>
        )}

        {/* ── STEP 4: Record Ball ── */}
        {step === "ball" && (
          <div>
            <div style={{
              display: "flex", justifyContent: "space-between",
              alignItems: "center", marginBottom: 20
            }}>
              <h2 style={{ fontSize: 16, fontWeight: 700, margin: 0 }}>
                Over {overForm.over_number} — Ball {ballNumber}
              </h2>
              <div style={{ display: "flex", gap: 6 }}>
                {balls.map((b, i) => (
                  <div key={i} style={{
                    width: 34, height: 34, borderRadius: "50%",
                    display: "flex", alignItems: "center", justifyContent: "center",
                    fontSize: 13, fontWeight: 800,
                    background:
                      b.is_wicket === "Y" ? "var(--primary)" :
                      b.is_extra  === "Y" ? "var(--amber)"   : "var(--navy)",
                    color: "#fff",
                  }}>
                    {b.is_wicket === "Y" ? "W" :
                     b.is_extra  === "Y" ? "E" : b.runs_scored}
                  </div>
                ))}
              </div>
            </div>

            {/* Batsman selectors */}
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
              <Field label={`Batsman on Strike — ${battingPlayers.length} available`}>
                <select className={inp} value={ballForm.batsman_id}
                  onChange={e => setBallForm({ ...ballForm, batsman_id: e.target.value })}>
                  <option value="">Select Batsman</option>
                  {battingPlayers.map(p =>
                    <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>
                  )}
                </select>
              </Field>
              <Field label="Non-Striker">
                <select className={inp} value={ballForm.non_striker_id}
                  onChange={e => setBallForm({ ...ballForm, non_striker_id: e.target.value })}>
                  <option value="">Select Non-Striker</option>
                  {battingPlayers.map(p =>
                    <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>
                  )}
                </select>
              </Field>
            </div>

            {/* Runs */}
            <Field label="Runs Scored">
              <div style={{ display: "flex", gap: 8, margin: "8px 0 16px", flexWrap: "wrap" }}>
                {[0, 1, 2, 3, 4, 6].map(r => (
                  <button key={r}
                    onClick={() => setBallForm({ ...ballForm, runs_scored: r })}
                    style={{
                      width: 44, height: 44, borderRadius: "50%", cursor: "pointer",
                      border: `2px solid ${ballForm.runs_scored === r ? "var(--primary)" : "var(--gray-200)"}`,
                      background: ballForm.runs_scored === r ? "var(--primary)" : "var(--white)",
                      color: ballForm.runs_scored === r ? "#fff" : "var(--gray-800)",
                      fontWeight: 800, fontSize: 15, transition: "all 0.15s",
                    }}>{r}</button>
                ))}
              </div>
            </Field>

            {/* Extra / Wicket toggles */}
            <div style={{ display: "flex", gap: 24, marginBottom: 16 }}>
              <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", fontSize: 13, fontWeight: 500 }}>
                <input type="checkbox" checked={ballForm.is_extra === "Y"}
                  onChange={e => setBallForm({ ...ballForm, is_extra: e.target.checked ? "Y" : "N", extra_type: "" })} />
                Extra
              </label>
              <label style={{ display: "flex", alignItems: "center", gap: 8, cursor: "pointer", fontSize: 13, fontWeight: 500 }}>
                <input type="checkbox" checked={ballForm.is_wicket === "Y"}
                  onChange={e => setBallForm({ ...ballForm, is_wicket: e.target.checked ? "Y" : "N", dismissal_type: "" })} />
                Wicket
              </label>
            </div>

            {ballForm.is_extra === "Y" && (
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
                <Field label="Extra Type">
                  <select className={inp} value={ballForm.extra_type}
                    onChange={e => setBallForm({ ...ballForm, extra_type: e.target.value })}>
                    <option value="">Select</option>
                    {EXTRAS.map(e => <option key={e}>{e}</option>)}
                  </select>
                </Field>
                <Field label="Extra Runs">
                  <input type="number" min="0" className={inp} value={ballForm.extra_runs}
                    onChange={e => setBallForm({ ...ballForm, extra_runs: parseInt(e.target.value) || 0 })} />
                </Field>
              </div>
            )}

            {ballForm.is_wicket === "Y" && (
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
                <Field label="Dismissal Type">
                  <select className={inp} value={ballForm.dismissal_type}
                    onChange={e => setBallForm({ ...ballForm, dismissal_type: e.target.value })}>
                    <option value="">Select</option>
                    {DISMISSALS.map(d => <option key={d}>{d}</option>)}
                  </select>
                </Field>
                <Field label="Fielder (if Caught / Stumped)">
                  <select className={inp} value={ballForm.fielder_id}
                    onChange={e => setBallForm({ ...ballForm, fielder_id: e.target.value })}>
                    <option value="">None</option>
                    {bowlingPlayers.map(p =>
                      <option key={p.PLAYER_ID} value={p.PLAYER_ID}>{p.PLAYER_NAME}</option>
                    )}
                  </select>
                </Field>
              </div>
            )}

            <button
              className="btn-primary"
              onClick={recordBall}
              disabled={!ballForm.batsman_id || !ballForm.non_striker_id}
              style={{ opacity: (!ballForm.batsman_id || !ballForm.non_striker_id) ? 0.5 : 1 }}
            >
              Record Ball {ballNumber}
            </button>
          </div>
        )}

      </div>
    </div>
  );
}