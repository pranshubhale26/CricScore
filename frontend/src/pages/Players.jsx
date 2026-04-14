import React, { useEffect, useState } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";

const ROLES = ["Batsman", "Bowler", "All-Rounder", "Wicket-Keeper"];
const roleColor = { Batsman: "#1565C0", Bowler: "#C62828", "All-Rounder": "#2E7D32", "Wicket-Keeper": "#6A1B9A" };
const roleBg    = { Batsman: "#E3F2FD", Bowler: "#FFEBEE", "All-Rounder": "#E8F5E9", "Wicket-Keeper": "#F3E5F5" };

export default function Players() {
  const [players, setPlayers]   = useState([]);
  const [teams, setTeams]       = useState([]);
  const [filter, setFilter]     = useState({ team: "", role: "" });
  const [selected, setSelected] = useState(null);
  const [stats, setStats]       = useState(null);
  const [loading, setLoading]   = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [msg, setMsg]           = useState("");
  const [form, setForm]         = useState({
    team_id: "", player_name: "", role: "Batsman",
    batting_style: "Right-hand", bowling_style: "", jersey_number: "",
  });

  useEffect(() => {
    Promise.all([axios.get(`${API}/players`), axios.get(`${API}/teams`)])
      .then(([p, t]) => { setPlayers(p.data); setTeams(t.data); setLoading(false); });
  }, []);

  const loadPlayers = () => {
    axios.get(`${API}/players`).then(r => setPlayers(r.data));
  };

  const loadStats = (id) => {
    axios.get(`${API}/players/${id}/stats`).then(r => setStats(r.data));
  };

  const createPlayer = async () => {
    if (!form.team_id || !form.player_name) {
      setMsg("❌ Team and player name are required.");
      return;
    }
    try {
      await axios.post(`${API}/players`, form);
      setMsg("✅ Player added successfully!");
      setShowForm(false);
      setForm({ team_id: "", player_name: "", role: "Batsman", batting_style: "Right-hand", bowling_style: "", jersey_number: "" });
      loadPlayers();
    } catch (e) {
      setMsg("❌ " + (e.response?.data?.error || e.message));
    }
    setTimeout(() => setMsg(""), 4000);
  };

  const filtered = players.filter(p => {
    if (filter.team && p.TEAM_NAME !== filter.team) return false;
    if (filter.role && p.ROLE !== filter.role) return false;
    return true;
  });

  const inp = { width: "100%", padding: "9px 12px", borderRadius: 8, border: "1px solid #DDD", fontSize: 13, boxSizing: "border-box", marginBottom: 12, background: "#FFF" };
  const sel = { padding: "9px 12px", borderRadius: 8, border: "1px solid #DDD", fontSize: 13, background: "#FFF" };

  // Player detail view
  if (selected) {
    const s = stats;
    return (
      <div>
        <button
          onClick={() => { setSelected(null); setStats(null); }}
          style={{ background: "none", border: "1px solid #CCC", borderRadius: 8, padding: "7px 16px", cursor: "pointer", marginBottom: 20, fontSize: 13 }}
        >
          ← Back to Players
        </button>

        <div style={{ background: "#1B5E20", borderRadius: 12, padding: "24px 28px", color: "#FFF", marginBottom: 24 }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
            <div>
              <div style={{ fontSize: 26, fontWeight: 800 }}>{selected.PLAYER_NAME}</div>
              <div style={{ fontSize: 13, opacity: 0.8, marginTop: 6 }}>
                {selected.TEAM_NAME} · {selected.ROLE} · #{selected.JERSEY_NUMBER || "N/A"}
              </div>
              {selected.BATTING_STYLE && (
                <div style={{ fontSize: 12, opacity: 0.7, marginTop: 4 }}>
                  {selected.BATTING_STYLE} bat {selected.BOWLING_STYLE ? `· ${selected.BOWLING_STYLE}` : ""}
                </div>
              )}
            </div>
            <span style={{
              background: roleBg[selected.ROLE], color: roleColor[selected.ROLE],
              fontSize: 13, fontWeight: 700, padding: "6px 14px", borderRadius: 20,
            }}>
              {selected.ROLE}
            </span>
          </div>
        </div>

        {s ? (
          <div>
            <h2 style={{ fontSize: 18, fontWeight: 700, marginBottom: 16 }}>Career Statistics</h2>
            <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 14, marginBottom: 24 }}>
              {[
                { label: "Innings Batted", value: s.INNINGS_BATTED },
                { label: "Total Runs",     value: s.TOTAL_RUNS },
                { label: "Highest Score",  value: s.HIGHEST_SCORE },
                { label: "Batting Avg",    value: s.BATTING_AVG },
                { label: "Strike Rate",    value: s.STRIKE_RATE },
                { label: "Fours",          value: s.TOTAL_FOURS },
                { label: "Sixes",          value: s.TOTAL_SIXES },
                { label: "Wickets",        value: s.TOTAL_WICKETS },
              ].map((c, i) => (
                <div key={i} style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 10, padding: "14px 16px", textAlign: "center" }}>
                  <div style={{ fontSize: 26, fontWeight: 800, color: "#1B5E20" }}>{c.value ?? "-"}</div>
                  <div style={{ fontSize: 11, color: "#888", marginTop: 4, fontWeight: 600 }}>{c.label}</div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          <div style={{ color: "#888", fontSize: 13 }}>No career stats available yet.</div>
        )}
      </div>
    );
  }

  return (
    <div>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
        <div>
          <h1 style={{ fontSize: 24, fontWeight: 800, margin: 0 }}>Players</h1>
          <p style={{ color: "#888", fontSize: 13, marginTop: 4 }}>{filtered.length} players</p>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          style={{ background: "#1B5E20", color: "#FFF", border: "none", borderRadius: 8, padding: "10px 20px", cursor: "pointer", fontSize: 13, fontWeight: 600 }}
        >
          {showForm ? "✕ Cancel" : "+ Add Player"}
        </button>
      </div>

      {/* Message */}
      {msg && (
        <div style={{
          marginBottom: 16, padding: "10px 16px", borderRadius: 8, fontWeight: 600, fontSize: 13,
          background: msg.startsWith("✅") ? "#E8F5E9" : "#FFEBEE",
          color: msg.startsWith("✅") ? "#2E7D32" : "#C62828",
          border: `1px solid ${msg.startsWith("✅") ? "#A5D6A7" : "#FFCDD2"}`,
        }}>{msg}</div>
      )}

      {/* Add Player Form */}
      {showForm && (
        <div style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 12, padding: 24, marginBottom: 24 }}>
          <h2 style={{ fontSize: 16, fontWeight: 700, margin: "0 0 16px" }}>New Player</h2>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>TEAM *</label>
              <select style={inp} value={form.team_id} onChange={e => setForm({ ...form, team_id: e.target.value })}>
                <option value="">Select Team</option>
                {teams.map(t => <option key={t.TEAM_ID} value={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
              </select>
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>PLAYER NAME *</label>
              <input style={inp} placeholder="Full name" value={form.player_name} onChange={e => setForm({ ...form, player_name: e.target.value })} />
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>ROLE</label>
              <select style={inp} value={form.role} onChange={e => setForm({ ...form, role: e.target.value })}>
                {ROLES.map(r => <option key={r}>{r}</option>)}
              </select>
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>BATTING STYLE</label>
              <select style={inp} value={form.batting_style} onChange={e => setForm({ ...form, batting_style: e.target.value })}>
                <option>Right-hand</option>
                <option>Left-hand</option>
              </select>
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>BOWLING STYLE</label>
              <input style={inp} placeholder="e.g. Right-arm Fast (optional)" value={form.bowling_style} onChange={e => setForm({ ...form, bowling_style: e.target.value })} />
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>JERSEY NUMBER</label>
              <input style={inp} type="number" placeholder="e.g. 18" value={form.jersey_number} onChange={e => setForm({ ...form, jersey_number: e.target.value })} />
            </div>
          </div>
          <div style={{ display: "flex", gap: 10 }}>
            <button onClick={createPlayer} style={{ background: "#1B5E20", color: "#FFF", border: "none", borderRadius: 8, padding: "10px 22px", cursor: "pointer", fontSize: 13, fontWeight: 600 }}>
              Add Player
            </button>
            <button onClick={() => setShowForm(false)} style={{ background: "#EEE", color: "#555", border: "none", borderRadius: 8, padding: "10px 22px", cursor: "pointer", fontSize: 13, fontWeight: 600 }}>
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Filters */}
      <div style={{ display: "flex", gap: 12, marginBottom: 20 }}>
        <select style={sel} value={filter.team} onChange={e => setFilter({ ...filter, team: e.target.value })}>
          <option value="">All Teams</option>
          {teams.map(t => <option key={t.TEAM_ID}>{t.TEAM_NAME}</option>)}
        </select>
        <select style={sel} value={filter.role} onChange={e => setFilter({ ...filter, role: e.target.value })}>
          <option value="">All Roles</option>
          {ROLES.map(r => <option key={r}>{r}</option>)}
        </select>
      </div>

      {/* Players grid */}
      {loading ? <div style={{ color: "#888" }}>Loading...</div> : (
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(240px, 1fr))", gap: 14 }}>
          {filtered.map((p) => (
            <div
              key={p.PLAYER_ID}
              onClick={() => { setSelected(p); loadStats(p.PLAYER_ID); }}
              style={{
                background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 10,
                padding: "16px 18px", cursor: "pointer", transition: "box-shadow 0.15s",
              }}
              onMouseEnter={e => e.currentTarget.style.boxShadow = "0 4px 12px rgba(0,0,0,0.08)"}
              onMouseLeave={e => e.currentTarget.style.boxShadow = "none"}
            >
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <div style={{ fontWeight: 700, fontSize: 14 }}>{p.PLAYER_NAME}</div>
                <span style={{ fontSize: 12, color: "#AAA" }}>#{p.JERSEY_NUMBER || "?"}</span>
              </div>
              <div style={{ fontSize: 12, color: "#888", marginTop: 2 }}>{p.TEAM_NAME}</div>
              <div style={{ marginTop: 10, display: "flex", gap: 6, flexWrap: "wrap" }}>
                <span style={{ background: roleBg[p.ROLE], color: roleColor[p.ROLE], fontSize: 11, fontWeight: 600, padding: "2px 8px", borderRadius: 10 }}>
                  {p.ROLE}
                </span>
                {p.BATTING_STYLE && (
                  <span style={{ background: "#F5F5F5", color: "#666", fontSize: 11, padding: "2px 8px", borderRadius: 10 }}>
                    {p.BATTING_STYLE}
                  </span>
                )}
              </div>
              {p.BOWLING_STYLE && <div style={{ fontSize: 11, color: "#AAA", marginTop: 6 }}>{p.BOWLING_STYLE}</div>}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}