import React, { useEffect, useState } from "react";
import axios from "axios";
import Scorecard from "../components/Scorecard";

const API = "http://localhost:5000/api";

function StatusPill({ status }) {
  const map = { Live:"tag tag-red", Completed:"tag tag-green", Scheduled:"tag tag-amber", Abandoned:"tag tag-gray" };
  return <span className={map[status]||"tag tag-gray"}>{status==="Live"&&<span className="live-dot"/>}{status}</span>;
}
function FormatPill({ format }) {
  const map = { T20:"tag tag-red", ODI:"tag tag-blue", Test:"tag tag-navy" };
  return <span className={map[format]||"tag tag-gray"}>{format}</span>;
}

export default function Matches({ go, selectedMatch, setSelectedMatch }) {
  const [matches, setMatches] = useState([]);
  const [detail, setDetail]   = useState(null);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter]   = useState("");

  useEffect(() => {
    axios.get(`${API}/matches`).then(r => { setMatches(r.data); setLoading(false); });
  }, []);

  useEffect(() => {
    if (selectedMatch) loadDetail(selectedMatch);
  }, [selectedMatch]);

  const loadDetail = (id) => {
    axios.get(`${API}/matches/${id}`).then(r => setDetail(r.data));
  };

  const filtered = matches.filter(m =>
    !filter ||
    m.TEAM1?.toLowerCase().includes(filter.toLowerCase()) ||
    m.TEAM2?.toLowerCase().includes(filter.toLowerCase()) ||
    m.MATCH_FORMAT?.toLowerCase().includes(filter.toLowerCase()) ||
    m.SERIES_NAME?.toLowerCase().includes(filter.toLowerCase())
  );

  if (detail) return (
    <div style={{ padding: "28px 32px" }} className="fade-in">
      <button
        onClick={() => { setDetail(null); setSelectedMatch(null); }}
        className="btn-outline"
        style={{ marginBottom: 20, display: "flex", alignItems: "center", gap: 6 }}
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 12H5m7-7l-7 7 7 7"/></svg>
        Back to Matches
      </button>

      {/* Match hero */}
      <div style={{
        background: "var(--navy)", borderRadius: "var(--radius-lg)",
        padding: "28px 32px", marginBottom: 24, color: "#fff",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", flexWrap: "wrap", gap: 12 }}>
          <div>
            <div style={{ fontSize: 28, fontWeight: 800, letterSpacing: "-0.5px", fontFamily: "'Teko', sans-serif" }}>
              {detail.TEAM1} <span style={{ color: "rgba(255,255,255,0.4)", fontWeight: 400 }}>vs</span> {detail.TEAM2}
            </div>
            <div style={{ display: "flex", gap: 16, marginTop: 8, fontSize: 12, color: "rgba(255,255,255,0.6)", flexWrap: "wrap" }}>
              {detail.MATCH_DATE && <span>{new Date(detail.MATCH_DATE).toLocaleDateString("en-IN", { weekday:"short", day:"numeric", month:"long", year:"numeric" })}</span>}
              {detail.VENUE_NAME && <span>{detail.VENUE_NAME}, {detail.CITY}</span>}
              {detail.SERIES_NAME && <span>{detail.SERIES_NAME}</span>}
            </div>
          </div>
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap", alignItems: "center" }}>
            <FormatPill format={detail.MATCH_FORMAT} />
            <StatusPill status={detail.STATUS} />
          </div>
        </div>

        {detail.RESULT_DESCRIPTION && (
          <div style={{
            marginTop: 18, background: "rgba(255,255,255,0.08)",
            borderRadius: "var(--radius-sm)", padding: "12px 16px",
            fontSize: 14, fontWeight: 600, borderLeft: "3px solid var(--primary)",
          }}>
            {detail.RESULT_DESCRIPTION}
          </div>
        )}

        <div style={{ display: "flex", gap: 20, marginTop: 14, fontSize: 12, color: "rgba(255,255,255,0.5)", flexWrap: "wrap" }}>
          {detail.TOSS_WINNER && <span>Toss: <b style={{ color: "#fff" }}>{detail.TOSS_WINNER}</b> chose to <b style={{ color: "#fff" }}>{detail.TOSS_DECISION}</b></span>}
          {detail.MAN_OF_MATCH && <span>Player of the Match: <b style={{ color: "#FFD54F" }}>{detail.MAN_OF_MATCH}</b></span>}
        </div>
      </div>

      <Scorecard innings={detail.innings} />
    </div>
  );

  return (
    <div style={{ padding: "28px 32px" }} className="fade-in">
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 22 }}>
        <h1 style={{ fontSize: 22, fontWeight: 800, letterSpacing: "-0.4px" }}>Matches</h1>
        <input
          className="inp"
          style={{ maxWidth: 260 }}
          placeholder="Search teams, format, series..."
          value={filter}
          onChange={e => setFilter(e.target.value)}
        />
      </div>

      {loading ? <div style={{ color: "var(--gray-400)" }}>Loading...</div> : (
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {filtered.map((m) => (
            <div
              key={m.MATCH_ID}
              className="card"
              onClick={() => loadDetail(m.MATCH_ID)}
              style={{ padding: "16px 20px", cursor: "pointer", display: "flex", justifyContent: "space-between", alignItems: "center", transition: "box-shadow 0.15s" }}
              onMouseEnter={e => e.currentTarget.style.boxShadow = "var(--shadow-md)"}
              onMouseLeave={e => e.currentTarget.style.boxShadow = "var(--shadow-sm)"}
            >
              <div>
                <div style={{ fontWeight: 700, fontSize: 15 }}>
                  {m.TEAM1} <span style={{ color: "var(--gray-400)", fontSize: 12, fontWeight: 400 }}>vs</span> {m.TEAM2}
                </div>
                <div style={{ fontSize: 12, color: "var(--gray-400)", marginTop: 4 }}>
                  {m.VENUE_NAME && `${m.VENUE_NAME} · `}
                  {m.MATCH_DATE && new Date(m.MATCH_DATE).toLocaleDateString("en-IN", { day: "numeric", month: "short", year: "numeric" })}
                  {m.SERIES_NAME && ` · ${m.SERIES_NAME}`}
                </div>
                {m.RESULT_DESCRIPTION && (
                  <div style={{ fontSize: 12, color: "var(--green)", fontWeight: 600, marginTop: 4 }}>
                    {m.RESULT_DESCRIPTION}
                  </div>
                )}
              </div>
              <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 6 }}>
                <StatusPill status={m.STATUS} />
                <FormatPill format={m.MATCH_FORMAT} />
              </div>
            </div>
          ))}
          {filtered.length === 0 && (
            <div style={{ color: "var(--gray-400)", padding: 20, textAlign: "center" }}>No matches found</div>
          )}
        </div>
      )}
    </div>
  );
}