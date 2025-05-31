const express = require('express');
const router = express.Router();
const controller = require('../controllers/user.controller');
const auth = require('../middlewares/auth.middleware');

router.post('/register', controller.register);
router.post('/login', controller.login);
router.get('/', auth, controller.getAllUsers);
router.get('/:id', auth, controller.getUserById);
router.put('/:id', auth, controller.updateUser);
router.delete('/:id', auth, controller.deleteUser);

module.exports = router;
