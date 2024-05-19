const express = require("express");
const router =express.Router()

const {getitems, postitems, putitems, deleteitem} = require('../controller/item')

router.get('/items', getitems)

router.post('/addItem', postitems)

router.put('/updateitem/:itemId', putitems)

router.delete('deleteitem/:itemId', deleteitem)

module.exports = router