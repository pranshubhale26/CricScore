import React, { useEffect, useState } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";

function StatusPill({ status }) {
  const map = {
    Live:      "tag tag-red",
    Completed: "tag tag-green",
    Scheduled: "tag tag-amber",
    Abandoned: "tag tag-gray",
  };
  return (
    <span className={map[status] || "tag tag-gray"}>
      {status === "Live" && <span className="live-dot" />}
      {status}
    </span>
  );
}

function FormatPill({ format }) {
  const map = { T20: "tag tag-red", ODI: "tag tag-blue", Test: "tag tag-navy" };
  return <span className={map[format] || "tag tag-gray"}>{format}</span>;
}

function MetricCard({ label, value, sub, accent = "var(--primary)" }) {
  return (
    <div className="card" style={{ padding: "20px 22px", borderTop: `3px solid ${accent}` }}>
      <div style={{ fontSize: 32, fontWeight: 800, color: accent, fontFamily: "'Teko', sans-serif", lineHeight: 1 }}>{value ?? "-"}</div>
      <div style={{ fontSize: 12, fontWeight: 600, color: "var(--gray-600)", marginTop: 6, textTransform: "uppercase", letterSpacing: "0.5px" }}>{label}</div>
      {sub && <div style={{ fontSize: 11, color: "var(--gray-400)", marginTop: 2 }}>{sub}</div>}
    </div>
  );
}

export default function Dashboard({ go }) {
  const [data, setData]   = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios.get(`${API}/stats/dashboard`)
      .then(r => setData(r.data))
      .catch(() => setError(true));
  }, []);

  if (error) return (
    <div style={{ padding: 32 }}>
      <div style={{ background: "#FFF0F0", border: "1px solid #FFCDD2", borderRadius: "var(--radius-md)", padding: "16px 20px", color: "var(--primary)", fontWeight: 500 }}>
        Cannot connect to backend. Ensure the Node.js server is running on port 5000.
      </div>
    </div>
  );

  if (!data) return (
    <div style={{ padding: 32, color: "var(--gray-400)", fontSize: 14 }}>Loading...</div>
  );

  return (
    <div style={{ padding: "28px 32px" }} className="fade-in">
      {/* Page header */}
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontSize: 26, fontWeight: 800, color: "var(--gray-800)", letterSpacing: "-0.5px" }}>
          Cricket Scoring System
        </h1>
        <p style={{ color: "var(--gray-400)", fontSize: 13, marginTop: 4 }}>
          Live and historical match management
        </p>
      </div>

      {/* Metrics */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(5, 1fr)", gap: 14, marginBottom: 28 }}>
        <MetricCard label="Teams"   value={data.counts.teams}   accent="var(--primary)" />
        <MetricCard label="Players" value={data.counts.players} accent="var(--blue)" />
        <MetricCard label="Matches" value={data.counts.matches} accent="var(--navy)" />
        <MetricCard label="Venues"  value={data.counts.venues}  accent="var(--amber)" />
        <MetricCard label="Live"    value={data.counts.live}    accent="var(--green)" sub={data.counts.live > 0 ? "In progress" : "No live matches"} />
      </div>

      {/* Recent matches */}
      <div className="card" style={{ overflow: "hidden" }}>
        <div style={{
          padding: "14px 20px", borderBottom: "1px solid var(--gray-200)",
          display: "flex", justifyContent: "space-between", alignItems: "center",
        }}>
          <span style={{ fontWeight: 700, fontSize: 14, color: "var(--gray-800)" }}>Recent Matches</span>
          <button className="btn-outline" onClick={() => go("matches")} style={{ fontSize: 12, padding: "6px 14px" }}>View All</button>
        </div>

        <table>
          <thead>
            <tr>
              <th>Match</th>
              <th>Format</th>
              <th>Venue</th>
              <th>Date</th>
              <th>Result</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {(data.recentMatches || []).map((m, i) => (
              <tr
                key={i}
                onClick={() => go("matches", m.MATCH_ID)}
                style={{ cursor: "pointer" }}
              >
                <td>
                  <span style={{ fontWeight: 600 }}>{m.TEAM1}</span>
                  <span style={{ color: "var(--gray-400)", margin: "0 6px", fontSize: 11 }}>vs</span>
                  <span style={{ fontWeight: 600 }}>{m.TEAM2}</span>
                </td>
                <td><FormatPill format={m.MATCH_FORMAT} /></td>
                <td style={{ color: "var(--gray-600)", fontSize: 12 }}>{m.CITY || "-"}</td>
                <td style={{ color: "var(--gray-600)", fontSize: 12 }}>
                  {m.MATCH_DATE ? new Date(m.MATCH_DATE).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" }) : "-"}
                </td>
                <td style={{ fontSize: 12, color: "var(--gray-600)", maxWidth: 280 }}>{m.RESULT_DESCRIPTION || "-"}</td>
                <td><StatusPill status={m.STATUS} /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}