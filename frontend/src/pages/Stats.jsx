import React, { useEffect, useState } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";

export default function Stats() {
  const [tab, setTab]             = useState("batting");
  const [batting, setBatting]     = useState([]);
  const [bowling, setBowling]     = useState([]);
  const [standings, setStandings] = useState([]);
  const [audit, setAudit]         = useState([]);
  const [loading, setLoading]     = useState(true);

  useEffect(() => {
    Promise.all([
      axios.get(`${API}/stats/batting`),
      axios.get(`${API}/stats/bowling`),
      axios.get(`${API}/stats/standings`),
      axios.get(`${API}/stats/audit`),
    ]).then(([b, bwl, st, au]) => {
      setBatting(b.data); setBowling(bwl.data);
      setStandings(st.data); setAudit(au.data);
      setLoading(false);
    });
  }, []);

  const TABS = [
    { id: "batting",   label: "Batting Leaderboard" },
    { id: "bowling",   label: "Bowling Leaderboard" },
    { id: "standings", label: "Team Standings"      },
    { id: "audit",     label: "Audit Log"           },
  ];

  return (
    <div style={{ padding: "28px 32px" }} className="fade-in">
      <h1 style={{ fontSize: 22, fontWeight: 800, letterSpacing: "-0.4px", marginBottom: 22 }}>Statistics</h1>

      {/* Tab bar */}
      <div style={{ display: "flex", gap: 2, marginBottom: 20, borderBottom: "2px solid var(--gray-200)" }}>
        {TABS.map(t => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            style={{
              background: "none", border: "none", cursor: "pointer",
              padding: "10px 18px", fontSize: 13, fontWeight: tab === t.id ? 700 : 400,
              color: tab === t.id ? "var(--primary)" : "var(--gray-600)",
              borderBottom: tab === t.id ? "2px solid var(--primary)" : "2px solid transparent",
              marginBottom: -2, transition: "all 0.15s",
            }}
          >{t.label}</button>
        ))}
      </div>

      {loading ? <div style={{ color: "var(--gray-400)" }}>Loading...</div> : (
        <div className="card" style={{ overflow: "hidden" }}>
          {tab === "batting" && (
            <table>
              <thead>
                <tr>
                  <th style={{ width: 36 }}>#</th>
                  <th>Player</th>
                  <th>Team</th>
                  <th style={{ textAlign: "right" }}>Inn</th>
                  <th style={{ textAlign: "right" }}>Runs</th>
                  <th style={{ textAlign: "right" }}>HS</th>
                  <th style={{ textAlign: "right" }}>Avg</th>
                  <th style={{ textAlign: "right" }}>SR</th>
                  <th style={{ textAlign: "right" }}>4s</th>
                  <th style={{ textAlign: "right" }}>6s</th>
                </tr>
              </thead>
              <tbody>
                {batting.map((p, i) => (
                  <tr key={i}>
                    <td style={{ color: "var(--gray-400)", fontWeight: 600, fontSize: 12 }}>{i + 1}</td>
                    <td style={{ fontWeight: 700 }}>{p.PLAYER_NAME}</td>
                    <td style={{ color: "var(--gray-600)", fontSize: 12 }}>{p.TEAM_NAME}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.INNINGS_BATTED}</td>
                    <td style={{ textAlign: "right", fontWeight: 800, color: "var(--primary)", fontSize: 15, fontFamily: "'Teko',sans-serif" }}>{p.TOTAL_RUNS}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.HIGHEST_SCORE}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.BATTING_AVG}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.STRIKE_RATE}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.TOTAL_FOURS}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.TOTAL_SIXES}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {tab === "bowling" && (
            <table>
              <thead>
                <tr>
                  <th style={{ width: 36 }}>#</th>
                  <th>Player</th>
                  <th>Team</th>
                  <th style={{ textAlign: "right" }}>Overs</th>
                  <th style={{ textAlign: "right" }}>Runs</th>
                  <th style={{ textAlign: "right" }}>Wkts</th>
                  <th style={{ textAlign: "right" }}>Econ</th>
                  <th style={{ textAlign: "right" }}>Avg</th>
                  <th style={{ textAlign: "right" }}>Maidens</th>
                </tr>
              </thead>
              <tbody>
                {bowling.map((p, i) => (
                  <tr key={i}>
                    <td style={{ color: "var(--gray-400)", fontWeight: 600, fontSize: 12 }}>{i + 1}</td>
                    <td style={{ fontWeight: 700 }}>{p.PLAYER_NAME}</td>
                    <td style={{ color: "var(--gray-600)", fontSize: 12 }}>{p.TEAM_NAME}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.TOTAL_OVERS}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.TOTAL_RUNS}</td>
                    <td style={{ textAlign: "right", fontWeight: 800, color: "var(--primary)", fontSize: 15, fontFamily: "'Teko',sans-serif" }}>{p.TOTAL_WICKETS}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.ECONOMY}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.BOWLING_AVG ?? "-"}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{p.TOTAL_MAIDENS}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {tab === "standings" && (
            <table>
              <thead>
                <tr>
                  <th style={{ width: 36 }}>#</th>
                  <th>Team</th>
                  <th style={{ textAlign: "right" }}>Played</th>
                  <th style={{ textAlign: "right" }}>Won</th>
                  <th style={{ textAlign: "right" }}>Lost</th>
                  <th style={{ textAlign: "right" }}>Win %</th>
                </tr>
              </thead>
              <tbody>
                {standings.map((t, i) => (
                  <tr key={i} style={{ background: i === 0 ? "var(--green-lt)" : undefined }}>
                    <td style={{ fontWeight: 700, color: i === 0 ? "var(--green)" : "var(--gray-400)", fontSize: 12 }}>{i + 1}</td>
                    <td style={{ fontWeight: 700 }}>{t.TEAM_NAME}</td>
                    <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{t.PLAYED}</td>
                    <td style={{ textAlign: "right", fontWeight: 700, color: "var(--green)" }}>{t.WON}</td>
                    <td style={{ textAlign: "right", color: "var(--primary)" }}>{t.LOST}</td>
                    <td style={{ textAlign: "right", fontWeight: 700 }}>{t.WIN_PCT}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          {tab === "audit" && (
            <>
              <div style={{ padding: "10px 16px", background: "var(--gray-50)", borderBottom: "1px solid var(--gray-200)", fontSize: 12, color: "var(--gray-400)" }}>
                Auto-generated by Oracle triggers on every INSERT / UPDATE / DELETE
              </div>
              <table>
                <thead>
                  <tr>
                    <th>Table</th>
                    <th>Operation</th>
                    <th>Record ID</th>
                    <th>User</th>
                    <th>Time</th>
                    <th>Notes</th>
                  </tr>
                </thead>
                <tbody>
                  {audit.map((a, i) => {
                    const opStyle = {
                      INSERT: "tag tag-green",
                      UPDATE: "tag tag-blue",
                      DELETE: "tag tag-red",
                    };
                    return (
                      <tr key={i}>
                        <td style={{ fontWeight: 600, fontSize: 12 }}>{a.TABLE_NAME}</td>
                        <td><span className={opStyle[a.OPERATION] || "tag tag-gray"}>{a.OPERATION}</span></td>
                        <td style={{ color: "var(--gray-400)", fontSize: 12 }}>{a.RECORD_ID}</td>
                        <td style={{ color: "var(--gray-600)", fontSize: 12 }}>{a.CHANGED_BY}</td>
                        <td style={{ color: "var(--gray-400)", fontSize: 11 }}>{a.CHANGED_AT}</td>
                        <td style={{ color: "var(--gray-600)", fontSize: 12 }}>{a.DESCRIPTION}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </>
          )}
        </div>
      )}
    </div>
  );
}