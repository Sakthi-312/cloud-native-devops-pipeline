const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function initDb() {
  for (let i = 0; i < 30; i++) {
    try {
      await pool.query(`CREATE TABLE IF NOT EXISTS people (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        role ENUM('student','teacher') NOT NULL
      )`);
      console.log('Database ready');
      return;
    } catch (e) {
      console.log('Waiting for database...', e.code);
      await sleep(2000);
    }
  }
  throw new Error('Database never became ready');
}

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.get('/api/people', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM people ORDER BY id DESC');
  res.json(rows);
});

app.post('/api/people', async (req, res) => {
  const { name, role } = req.body;
  if (!name || !['student', 'teacher'].includes(role)) {
    return res.status(400).json({ error: 'name and valid role required' });
  }
  await pool.query('INSERT INTO people (name, role) VALUES (?, ?)', [name, role]);
  res.status(201).json({ ok: true });
});

initDb().then(() => app.listen(3000, () => console.log('Backend on 3000')));
