const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;

// Accept connections from any IP address
const HOST = '0.0.0.0';

app.get('/', (req, res) => {
  res.send('Hello from Node.js running on PM2!');
});

app.listen(PORT, HOST, () => {
  console.log(`Server is running on http://${HOST}:${PORT}`);
});
