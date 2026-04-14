const express = require('express');
const cors    = require('cors');
require('dotenv').config();

const { initPool } = require('./db');

const app  = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use('/api/teams',   require('./routes/teams'));
app.use('/api/venues',  require('./routes/venues'));
app.use('/api/players', require('./routes/players'));
app.use('/api/matches', require('./routes/matches'));
app.use('/api/innings', require('./routes/innings'));
app.use('/api/scoring', require('./routes/scoring'));
app.use('/api/stats',   require('./routes/stats'));
app.use('/api/series',  require('./routes/series'));

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', time: new Date() });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: err.message || 'Server error' });
});

async function start() {
  await initPool();
  app.listen(PORT, () => {
    console.log(`Cricket API running on http://localhost:${PORT}`);
  });
}

start();