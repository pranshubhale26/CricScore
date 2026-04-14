import React, { useState } from "react";
import Nav from "./components/Nav";
import Dashboard from "./pages/Dashboard";
import Matches from "./pages/Matches";
import LiveScoring from "./pages/LiveScoring";
import PastMatch from "./pages/PastMatch";
import Teams from "./pages/Teams";
import Players from "./pages/Players";
import Venues from "./pages/Venues";
import Stats from "./pages/Stats";

export default function App() {
  const [page, setPage] = useState("dashboard");
  const [selectedMatch, setSelectedMatch] = useState(null);

  const go = (p, matchId = null) => {
    setPage(p);
    if (matchId) setSelectedMatch(matchId);
  };

  const renderPage = () => {
    switch (page) {
      case "dashboard": return <Dashboard go={go} />;
      case "matches":   return <Matches go={go} selectedMatch={selectedMatch} setSelectedMatch={setSelectedMatch} />;
      case "live":      return <LiveScoring />;
      case "past":      return <PastMatch />;
      case "teams":     return <Teams />;
      case "players":   return <Players />;
      case "venues":    return <Venues />;
      case "stats":     return <Stats />;
      default:          return <Dashboard go={go} />;
    }
  };

  return (
    <div style={{ display: "flex", minHeight: "100vh" }}>
      <Nav page={page} setPage={setPage} />
      <main style={{ marginLeft: 240, flex: 1, minHeight: "100vh", background: "var(--gray-100)" }}>
        {renderPage()}
      </main>
    </div>
  );
}