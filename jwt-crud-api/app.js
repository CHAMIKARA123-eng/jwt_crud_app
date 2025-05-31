const express = require('express');
const userRoutes = require('./routes/user.routes');
const sequelize = require('./config/db');
const app = express();

app.use(express.json());
app.use('/api/users', userRoutes);

sequelize.sync().then(() => {
  console.log('DB connected and synced');
});

module.exports = app;
