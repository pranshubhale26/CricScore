import React, { useState } from "react";

export default function Scorecard({ innings }) {
  const [activeTab, setActiveTab] = useState(0);

  if (!innings || !innings.length) return (
    <div className="card" style={{ padding: 24, color: "var(--gray-400)", textAlign: "center", fontSize: 14 }}>
      No scorecard data available.
    </div>
  );

  const inn = innings[activeTab];

  const dismissalText = (b) => {
    if (b.OUT_STATUS === "Not Out") return <span style={{ color: "var(--green)", fontWeight: 600 }}>not out</span>;
    if (b.OUT_STATUS === "Retired Hurt") return <span style={{ color: "var(--amber)" }}>retired hurt</span>;
    const parts = [];
    if (b.DISMISSAL_TYPE === "Caught" && b.FIELDER) parts.push(`c ${b.FIELDER}`);
    else if (b.DISMISSAL_TYPE) parts.push(b.DISMISSAL_TYPE.toLowerCase());
    if (b.DISMISSAL_BOWLER) parts.push(`b ${b.DISMISSAL_BOWLER}`);
    return <span style={{ color: "var(--gray-400)" }}>{parts.join(" ") || b.DISMISSAL_TYPE || "-"}</span>;
  };

  return (
    <div className="fade-in">
      {/* Inning tabs */}
      <div style={{ display: "flex", gap: 0, marginBottom: 16, background: "var(--white)", borderRadius: "var(--radius-md)", border: "1px solid var(--gray-200)", overflow: "hidden", boxShadow: "var(--shadow-sm)" }}>
        {innings.map((inn, i) => (
          <button
            key={i}
            onClick={() => setActiveTab(i)}
            style={{
              flex: 1, padding: "12px 16px", border: "none",
              background: activeTab === i ? "var(--navy)" : "transparent",
              color: activeTab === i ? "#fff" : "var(--gray-600)",
              fontSize: 13, fontWeight: activeTab === i ? 700 : 400,
              cursor: "pointer", transition: "all 0.15s",
              borderRight: i < innings.length - 1 ? "1px solid var(--gray-200)" : "none",
            }}
          >
            <div style={{ fontSize: 10, opacity: 0.6, marginBottom: 2, textTransform: "uppercase", letterSpacing: "0.5px" }}>Inning {inn.INNING_NUMBER}</div>
            <div style={{ fontSize: 13, fontWeight: 700 }}>{inn.BATTING_TEAM}</div>
            <div style={{ fontSize: 18, fontWeight: 800, fontFamily: "'Teko', sans-serif", color: activeTab === i ? "#FFD54F" : "var(--gray-800)" }}>
              {inn.TOTAL_RUNS}/{inn.TOTAL_WICKETS}
              <span style={{ fontSize: 11, fontWeight: 400, marginLeft: 4, opacity: 0.7 }}>({inn.COMPLETED_OVERS} ov)</span>
            </div>
          </button>
        ))}
      </div>

      {/* Batting */}
      <div className="card" style={{ overflow: "hidden", marginBottom: 14 }}>
        <div style={{ padding: "12px 18px", borderBottom: "1px solid var(--gray-200)", background: "var(--gray-50)", display: "flex", justifyContent: "space-between" }}>
          <span style={{ fontWeight: 700, fontSize: 12, textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--gray-800)" }}>Batting</span>
          <span style={{ fontSize: 12, color: "var(--gray-400)" }}>vs {inn.BOWLING_TEAM}</span>
        </div>
        <table>
          <thead>
            <tr>
              <th style={{ width: "34%" }}>Batsman</th>
              <th style={{ textAlign: "right" }}>R</th>
              <th style={{ textAlign: "right" }}>B</th>
              <th style={{ textAlign: "right" }}>4s</th>
              <th style={{ textAlign: "right" }}>6s</th>
              <th style={{ textAlign: "right" }}>SR</th>
              <th>Dismissal</th>
            </tr>
          </thead>
          <tbody>
            {(inn.batting || []).map((b, i) => (
              <tr key={i}>
                <td style={{ fontWeight: 600 }}>{b.PLAYER_NAME}</td>
                <td style={{ textAlign: "right", fontWeight: 800, fontSize: 14, color: b.RUNS >= 50 ? "var(--primary)" : "var(--gray-800)" }}>{b.RUNS}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.BALLS}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.FOURS}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.SIXES}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)", fontSize: 12 }}>{b.STRIKE_RATE || "-"}</td>
                <td style={{ fontSize: 12 }}>{dismissalText(b)}</td>
              </tr>
            ))}
            {(!inn.batting || inn.batting.length === 0) && (
              <tr><td colSpan={7} style={{ textAlign: "center", color: "var(--gray-400)", padding: 20 }}>No batting data</td></tr>
            )}
          </tbody>
        </table>
        <div style={{ padding: "10px 18px", background: "var(--gray-50)", borderTop: "1px solid var(--gray-200)", display: "flex", justifyContent: "space-between", fontSize: 12, color: "var(--gray-600)" }}>
          <span>Extras: <b>{inn.EXTRAS_TOTAL || 0}</b></span>
          <span style={{ fontWeight: 700, fontSize: 13, fontFamily: "'Teko', sans-serif", color: "var(--navy)" }}>
            Total: {inn.TOTAL_RUNS}/{inn.TOTAL_WICKETS} ({inn.COMPLETED_OVERS} ov)
          </span>
        </div>
      </div>

      {/* Bowling */}
      <div className="card" style={{ overflow: "hidden" }}>
        <div style={{ padding: "12px 18px", borderBottom: "1px solid var(--gray-200)", background: "var(--gray-50)", display: "flex", justifyContent: "space-between" }}>
          <span style={{ fontWeight: 700, fontSize: 12, textTransform: "uppercase", letterSpacing: "0.5px", color: "var(--gray-800)" }}>Bowling</span>
          <span style={{ fontSize: 12, color: "var(--gray-400)" }}>{inn.BOWLING_TEAM}</span>
        </div>
        <table>
          <thead>
            <tr>
              <th style={{ width: "34%" }}>Bowler</th>
              <th style={{ textAlign: "right" }}>O</th>
              <th style={{ textAlign: "right" }}>R</th>
              <th style={{ textAlign: "right" }}>W</th>
              <th style={{ textAlign: "right" }}>Econ</th>
              <th style={{ textAlign: "right" }}>Maidens</th>
              <th style={{ textAlign: "right" }}>Wd</th>
              <th style={{ textAlign: "right" }}>NB</th>
            </tr>
          </thead>
          <tbody>
            {(inn.bowling || []).map((b, i) => (
              <tr key={i}>
                <td style={{ fontWeight: 600 }}>{b.PLAYER_NAME}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.OVERS}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.RUNS_CONCEDED}</td>
                <td style={{ textAlign: "right", fontWeight: 800, color: b.WICKETS > 0 ? "var(--primary)" : "var(--gray-800)" }}>{b.WICKETS}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.ECONOMY}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.MAIDENS}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.WIDES || 0}</td>
                <td style={{ textAlign: "right", color: "var(--gray-600)" }}>{b.NO_BALLS || 0}</td>
              </tr>
            ))}
            {(!inn.bowling || inn.bowling.length === 0) && (
              <tr><td colSpan={8} style={{ textAlign: "center", color: "var(--gray-400)", padding: 20 }}>No bowling data</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}