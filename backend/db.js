const oracledb = require('oracledb');
require('dotenv').config();

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
oracledb.autoCommit = false;

let pool;

async function initPool() {
  try {
    pool = await oracledb.createPool({
      user:          process.env.DB_USER,
      password:      process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING,
      poolMin:       2,
      poolMax:       10,
      poolIncrement: 1,
    });
    console.log('✅ Oracle connection pool created');
  } catch (err) {
    console.error('❌ Oracle connection failed:', err.message);
    process.exit(1);
  }
}

async function query(sql, binds = []) {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(sql, binds, {
      outFormat: oracledb.OUT_FORMAT_OBJECT,
    });
    return result;
  } finally {
    if (conn) await conn.close();
  }
}

async function execute(sql, binds = []) {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(sql, binds, { autoCommit: true });
    return result;
  } catch (err) {
    throw err;
  } finally {
    if (conn) await conn.close();
  }
}

async function callProc(sql, binds = {}) {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(sql, binds);
    await conn.commit();
    return result;
  } catch (err) {
    if (conn) await conn.rollback();
    throw err;
  } finally {
    if (conn) await conn.close();
  }
}

module.exports = { initPool, query, execute, callProc };