const express = require("express");
const router =express.Router()

const {getitems, postitems, putitems} = require('../controller/item')

router.get('/getitems', getitems)

router.post('/items', postitems)

router.put('/updateitem/:itemid', putitems)

router.delete('/api/items',)

module.exports = router