const express = require('express');
const router  = express.Router();
const db      = require('../db');

router.post('/', async (req, res) => {
  const { series_name, series_type, format, start_date, end_date, host_country } = req.body;
  try {
    await db.execute(
      `INSERT INTO Series (series_id, series_name, series_type, format, start_date, end_date, host_country)
       VALUES (SEQ_SERIES.NEXTVAL, :1, :2, :3, :4, :5, :6)`,
      [series_name, series_type||null, format||null, start_date||null, end_date||null, host_country||null]
    );
    const r = await db.query(`SELECT SEQ_SERIES.CURRVAL AS series_id FROM DUAL`);
    res.status(201).json({ series_id: r.rows[0].SERIES_ID });
  } catch (err) { res.status(500).json({ error: err.message }); }
});

router.get('/', async (req, res) => {
  try {
    const r = await db.query(`SELECT * FROM Series ORDER BY start_date DESC`);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
});

module.exports = router;