🏏 CricScore – Cricket Management System

CricScore is a full-stack Cricket Management System designed to manage matches, teams, players, and live scoring with a modern and intuitive interface.

🚀 Features
🏠 Dashboard
Overview of matches and system stats
🏏 Match Management
Create, view, and manage matches
Support for T20 & Test formats
Match results and summaries
🔴 Live Scoring
Real-time score updates
Extendable for ball-by-ball tracking
📂 Past Matches
Access historical match data
👥 Teams & Players
Manage teams and player details
📍 Venues
Store and manage stadium information
📊 Statistics
Performance insights and analytics
🛠️ Tech Stack
Frontend
React.js
CSS / Modern UI
Backend
Node.js
Express.js
Database
Oracle SQL
📁 Project Structure
cricscore/
│
├── backend/
│   ├── routes/
│   ├── server.js
│   ├── db.js
│   └── package.json
│
├── frontend/
│   ├── src/
│   ├── public/
│   └── package.json
│
├── database/
│   ├── schema.sql
│   ├── sample_data.sql
│   └── queries.sql
│
└── README.md

⚙️ Installation & Setup
1️⃣ Clone the Repository
git clone https://github.com/your-username/cricscore.git
cd cricscore
2️⃣ Setup Backend
cd backend
npm install
npm start
3️⃣ Setup Frontend
cd frontend
npm install
npm start
4️⃣ Setup Database
Import SQL files from /database into Oracle DB
Update DB config in db.js