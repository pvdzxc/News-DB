const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'Kh@nh01698680678', // replace with your password
  database: 'newspaper_database',
  connectionLimit: 10, // adjust the limit as needed
});

module.exports = pool;