import React, { useEffect, useState } from "react";
import axios from "axios";

const API = "http://localhost:5000/api";

const PITCH_TYPES = ["Flat", "Bouncy", "Spin-friendly", "Seam-friendly", "Green-top"];

const pitchColor = {
  "Flat":          { bg: "#E8F5E9", color: "#2E7D32" },
  "Bouncy":        { bg: "#FFF3E0", color: "#E65100" },
  "Spin-friendly": { bg: "#F3E5F5", color: "#6A1B9A" },
  "Seam-friendly": { bg: "#E3F2FD", color: "#1565C0" },
  "Green-top":     { bg: "#E8F5E9", color: "#1B5E20" },
};

export default function Venues() {
  const [venues, setVenues]     = useState([]);
  const [showForm, setShowForm] = useState(false);
  const [msg, setMsg]           = useState("");
  const [form, setForm]         = useState({
    venue_name: "", city: "", country: "", capacity: "", pitch_type: "Flat",
  });

  useEffect(() => { loadVenues(); }, []);

  const loadVenues = () => {
    axios.get(`${API}/venues`).then(r => setVenues(r.data));
  };

  const createVenue = async () => {
    if (!form.venue_name || !form.city) {
      setMsg("❌ Venue name and city are required.");
      return;
    }
    try {
      await axios.post(`${API}/venues`, form);
      setMsg("✅ Venue added successfully!");
      setShowForm(false);
      setForm({ venue_name: "", city: "", country: "", capacity: "", pitch_type: "Flat" });
      loadVenues();
    } catch (e) {
      setMsg("❌ " + (e.response?.data?.error || e.message));
    }
    setTimeout(() => setMsg(""), 4000);
  };

  const inp = {
    width: "100%", padding: "9px 12px", borderRadius: 8,
    border: "1px solid #DDD", fontSize: 13, boxSizing: "border-box",
    marginBottom: 12, background: "#FFF", color: "#1A1A1A",
  };

  return (
    <div>
      {/* Header */}
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
        <div>
          <h1 style={{ fontSize: 24, fontWeight: 800, margin: 0 }}>Venues</h1>
          <p style={{ color: "#888", fontSize: 13, marginTop: 4 }}>{venues.length} venues registered</p>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          style={{ background: "#1B5E20", color: "#FFF", border: "none", borderRadius: 8, padding: "10px 20px", cursor: "pointer", fontSize: 13, fontWeight: 600 }}
        >
          {showForm ? "✕ Cancel" : "+ Add Venue"}
        </button>
      </div>

      {/* Message */}
      {msg && (
        <div style={{
          marginBottom: 16, padding: "10px 16px", borderRadius: 8,
          fontWeight: 600, fontSize: 13,
          background: msg.startsWith("✅") ? "#E8F5E9" : "#FFEBEE",
          color: msg.startsWith("✅") ? "#2E7D32" : "#C62828",
          border: `1px solid ${msg.startsWith("✅") ? "#A5D6A7" : "#FFCDD2"}`,
        }}>{msg}</div>
      )}

      {/* Add venue form */}
      {showForm && (
        <div style={{ background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 12, padding: 24, marginBottom: 24 }}>
          <h2 style={{ fontSize: 16, fontWeight: 700, marginBottom: 16, margin: "0 0 16px" }}>New Venue</h2>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>VENUE NAME *</label>
              <input style={inp} placeholder="e.g. Wankhede Stadium" value={form.venue_name} onChange={e => setForm({ ...form, venue_name: e.target.value })} />
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>CITY *</label>
              <input style={inp} placeholder="e.g. Mumbai" value={form.city} onChange={e => setForm({ ...form, city: e.target.value })} />
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>COUNTRY</label>
              <input style={inp} placeholder="e.g. India" value={form.country} onChange={e => setForm({ ...form, country: e.target.value })} />
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>CAPACITY</label>
              <input style={inp} type="number" placeholder="e.g. 33000" value={form.capacity} onChange={e => setForm({ ...form, capacity: e.target.value })} />
            </div>
            <div>
              <label style={{ fontSize: 11, fontWeight: 700, color: "#888", display: "block", marginBottom: 4 }}>PITCH TYPE</label>
              <select style={inp} value={form.pitch_type} onChange={e => setForm({ ...form, pitch_type: e.target.value })}>
                {PITCH_TYPES.map(p => <option key={p}>{p}</option>)}
              </select>
            </div>
          </div>
          <div style={{ display: "flex", gap: 10, marginTop: 4 }}>
            <button
              onClick={createVenue}
              style={{ background: "#1B5E20", color: "#FFF", border: "none", borderRadius: 8, padding: "10px 22px", cursor: "pointer", fontSize: 13, fontWeight: 600 }}
            >
              Save Venue
            </button>
            <button
              onClick={() => setShowForm(false)}
              style={{ background: "#EEE", color: "#555", border: "none", borderRadius: 8, padding: "10px 22px", cursor: "pointer", fontSize: 13, fontWeight: 600 }}
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {/* Venues grid */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))", gap: 16 }}>
        {venues.map((v) => {
          const pc = pitchColor[v.PITCH_TYPE] || { bg: "#F5F5F5", color: "#555" };
          return (
            <div
              key={v.VENUE_ID}
              style={{
                background: "#FFF", border: "1px solid #E5E0D8", borderRadius: 12,
                padding: "20px 22px",
                borderTop: "4px solid #1B5E20",
              }}
            >
              <div style={{ fontWeight: 800, fontSize: 16, color: "#1A1A1A", marginBottom: 4 }}>
                {v.VENUE_NAME}
              </div>
              <div style={{ fontSize: 13, color: "#666", marginBottom: 14 }}>
                📍 {v.CITY}{v.COUNTRY ? `, ${v.COUNTRY}` : ""}
              </div>

              <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
                {v.PITCH_TYPE && (
                  <span style={{
                    background: pc.bg, color: pc.color,
                    fontSize: 11, fontWeight: 600, padding: "3px 10px", borderRadius: 20,
                  }}>
                    {v.PITCH_TYPE}
                  </span>
                )}
                {v.CAPACITY && (
                  <span style={{
                    background: "#F5F5F5", color: "#555",
                    fontSize: 11, fontWeight: 600, padding: "3px 10px", borderRadius: 20,
                  }}>
                    🏟️ {Number(v.CAPACITY).toLocaleString()} capacity
                  </span>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}