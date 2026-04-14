import React, { useEffect, useState } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";

const ROLES = ["Batsman", "Bowler", "All-Rounder", "Wicket-Keeper"];
const roleColor = { Batsman: "#1565C0", Bowler: "#C62828", "All-Rounder": "#2E7D32", "Wicket-Keeper": "#6A1B9A" };
const roleBg   = { Batsman: "#E3F2FD", Bowler: "#FFEBEE", "All-Rounder": "#E8F5E9", "Wicket-Keeper": "#F3E5F5" };

export default function Teams() {
  const [teams, setTeams]       = useState([]);
  const [selected, setSelected] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm]         = useState({ team_name: "", country: "", coach: "", home_venue: "", founded_yr: "" });
  const [playerForm, setPlayerForm] = useState({ player_name: "", role: "Batsman", batting_style: "Right-hand", bowling_style: "", jersey_number: "" });
  const [showPlayerForm, setShowPlayerForm] = useState(false);
  const [msg, setMsg] = useState("");

  useEffect(() => { loadTeams(); }, []);

  const loadTeams = () => {
    axios.get(`${API}/teams`).then(r => setTeams(r.data));
  };

  const loadTeam = (id) => {
    axios.get(`${API}/teams/${id}`).then(r => setSelected(r.data));
  };

  const createTeam = async () => {
    try {
      await axios.post(`${API}/teams`, form);
      setMsg("✅ Team created!"); setShowForm(false); setForm({ team_name:"",country:"",coach:"",home_venue:"",founded_yr:"" });
      loadTeams();
    } catch { setMsg("❌ Error creating team"); }
  };

  const createPlayer = async () => {
    try {
      await axios.post(`${API}/players`, { ...playerForm, team_id: selected.TEAM_ID });
      setMsg("✅ Player added!"); setShowPlayerForm(false);
      loadTeam(selected.TEAM_ID);
    } catch { setMsg("❌ Error adding player"); }
  };

  const inp = { width: "100%", padding: "9px 12px", borderRadius: 8, border: "1px solid #DDD", fontSize: 13, boxSizing: "border-box", marginBottom: 10 };
  const btn = (bg="#1B5E20") => ({ background: bg, color: "#FFF", border: "none", borderRadius: 8, padding: "9px 18px", cursor: "pointer", fontSize: 13, fontWeight: 600 });

  if (selected) return (
    <div>
      <button onClick={() => setSelected(null)} style={{ background: "none", border: "1px solid #CCC", borderRadius: 8, padding: "7px 16px", cursor: "pointer", marginBottom: 20, fontSize: 13 }}>
        ← Back to Teams
      </button>

      <div style={{ background: "#1B5E20", borderRadius: 12, padding: "24px 28px", color: "#FFF", marginBottom: 24 }}>
        <div style={{ fontSize: 24, fontWeight: 800 }}>{selected.TEAM_NAME}</div>
        <div style={{ fontSize: 13, opacity: 0.8, marginTop: 6 }}>
          {selected.COUNTRY} · Coach: {selected.COACH || "N/A"} · Est. {selected.FOUNDED_YR || "N/A"}
        </div>
      </div>

      {msg && <div style={{ marginBottom: 12, color: msg.startsWith("✅") ? "#2E7D32" : "#C62828", fontWeight: 600 }}>{msg}</div>}

      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
        <h2 style={{ margin: 0, fontSize: 18, fontWeight: 700 }}>Squad ({selected.squad?.length || 0} players)</h2>
        <button onClick={() => setShowPlayerForm(!showPlayerForm)} style={btn()}>+ Add Player</button>
      </div>

      {showPlayerForm && (
        <div style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 12, padding: 20, marginBottom: 20 }}>
          <h3 style={{ margin: "0 0 14px", fontSize: 15 }}>New Player</h3>
          <input style={inp} placeholder="Player Name" value={playerForm.player_name} onChange={e => setPlayerForm({ ...playerForm, player_name: e.target.value })} />
          <select style={inp} value={playerForm.role} onChange={e => setPlayerForm({ ...playerForm, role: e.target.value })}>
            {ROLES.map(r => <option key={r}>{r}</option>)}
          </select>
          <select style={inp} value={playerForm.batting_style} onChange={e => setPlayerForm({ ...playerForm, batting_style: e.target.value })}>
            <option>Right-hand</option><option>Left-hand</option>
          </select>
          <input style={inp} placeholder="Bowling Style (optional)" value={playerForm.bowling_style} onChange={e => setPlayerForm({ ...playerForm, bowling_style: e.target.value })} />
          <input style={inp} placeholder="Jersey Number" type="number" value={playerForm.jersey_number} onChange={e => setPlayerForm({ ...playerForm, jersey_number: e.target.value })} />
          <div style={{ display: "flex", gap: 10 }}>
            <button onClick={createPlayer} style={btn()}>Add Player</button>
            <button onClick={() => setShowPlayerForm(false)} style={btn("#888")}>Cancel</button>
          </div>
        </div>
      )}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(260px, 1fr))", gap: 14 }}>
        {(selected.squad || []).map((p) => (
          <div key={p.PLAYER_ID} style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 10, padding: "14px 16px" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
              <div style={{ fontWeight: 700, fontSize: 14 }}>{p.PLAYER_NAME}</div>
              <span style={{ fontSize: 12, color: "#888" }}>#{p.JERSEY_NUMBER || "?"}</span>
            </div>
            <div style={{ marginTop: 8, display: "flex", gap: 6, flexWrap: "wrap" }}>
              <span style={{ background: roleBg[p.ROLE], color: roleColor[p.ROLE], fontSize: 11, fontWeight: 600, padding: "2px 8px", borderRadius: 10 }}>{p.ROLE}</span>
              {p.BATTING_STYLE && <span style={{ background: "#F5F5F5", color: "#555", fontSize: 11, padding: "2px 8px", borderRadius: 10 }}>{p.BATTING_STYLE}</span>}
            </div>
            {p.BOWLING_STYLE && <div style={{ fontSize: 11, color: "#888", marginTop: 6 }}>{p.BOWLING_STYLE}</div>}
          </div>
        ))}
      </div>
    </div>
  );

  return (
    <div>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
        <h1 style={{ fontSize: 24, fontWeight: 800, margin: 0 }}>Teams</h1>
        <button onClick={() => setShowForm(!showForm)} style={btn()}>+ Add Team</button>
      </div>

      {msg && <div style={{ marginBottom: 12, color: msg.startsWith("✅") ? "#2E7D32" : "#C62828", fontWeight: 600 }}>{msg}</div>}

      {showForm && (
        <div style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 12, padding: 20, marginBottom: 24 }}>
          <h3 style={{ margin: "0 0 14px", fontSize: 15 }}>New Team</h3>
          {[["Team Name*","team_name"],["Country*","country"],["Coach","coach"],["Home Venue","home_venue"],["Founded Year","founded_yr"]].map(([ph, key]) => (
            <input key={key} style={inp} placeholder={ph} value={form[key]} onChange={e => setForm({ ...form, [key]: e.target.value })} />
          ))}
          <div style={{ display: "flex", gap: 10 }}>
            <button onClick={createTeam} style={btn()}>Create Team</button>
            <button onClick={() => setShowForm(false)} style={btn("#888")}>Cancel</button>
          </div>
        </div>
      )}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: 16 }}>
        {teams.map((t) => (
          <div
            key={t.TEAM_ID}
            onClick={() => loadTeam(t.TEAM_ID)}
            style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 12, padding: "20px 22px", cursor: "pointer", transition: "box-shadow 0.15s" }}
            onMouseEnter={e => e.currentTarget.style.boxShadow = "0 4px 16px rgba(0,0,0,0.08)"}
            onMouseLeave={e => e.currentTarget.style.boxShadow = "none"}
          >
            <div style={{ fontWeight: 800, fontSize: 18, color: "#1B5E20" }}>{t.TEAM_NAME}</div>
            <div style={{ fontSize: 13, color: "#666", marginTop: 4 }}>{t.COUNTRY}</div>
            <div style={{ marginTop: 12, display: "flex", justifyContent: "space-between", fontSize: 12, color: "#888" }}>
              <span>👤 {t.COACH || "No coach"}</span>
              <span style={{ fontWeight: 600, color: "#1B5E20" }}>{t.PLAYER_COUNT} players</span>
            </div>
            {t.FOUNDED_YR && <div style={{ fontSize: 11, color: "#AAA", marginTop: 4 }}>Est. {t.FOUNDED_YR}</div>}
          </div>
        ))}
      </div>
    </div>
  );
}