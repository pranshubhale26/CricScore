const express = require('express');
const router  = express.Router();
const db      = require('../db');

router.get('/', async (req, res) => {
  try {
    const result = await db.query(`SELECT * FROM Venues ORDER BY venue_name`);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.post('/', async (req, res) => {
  const { venue_name, city, country, capacity, pitch_type } = req.body;
  try {
    await db.execute(
      `INSERT INTO Venues VALUES (SEQ_VENUE.NEXTVAL,:1,:2,:3,:4,:5)`,
      [venue_name, city, country||null, capacity||null, pitch_type||null]
    );
    res.status(201).json({ message: 'Venue created' });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;