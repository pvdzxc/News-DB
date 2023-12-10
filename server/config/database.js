const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'Newspaper1234Server!@#$', // replace with your password
  database: 'newspaper_database',
  connectionLimit: 10, // adjust the limit as needed
});

module.exports = pool;