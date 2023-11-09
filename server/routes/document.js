const express = require('express');
const Document = require('../models/document');
const documentRouter = express.Router();
const auth = require('../middlewares/auth');
documentRouter.post('/doc/create', auth, async (req, res) => {
    try {

    } catch (e) {
        res.status(500).json({error: e.message});
    }

});