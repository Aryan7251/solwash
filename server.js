// SolWash Root Entrypoint for Cloud Hosting (Render, Railway, Heroku, etc.)
const { startServer } = require('./backend/src/server.js');

startServer().catch((err) => {
  console.error('Fatal Server Startup Error:', err);
  process.exit(1);
});
