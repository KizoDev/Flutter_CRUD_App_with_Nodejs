const express = require("express");
const Item = require('../models/item')

const getitems = async (req, res) => {
    const items = await Item.find()
    res.json({
        status: 200,
        message: 'item gotten  successful',
        successfull:true,
        data:items
    })
}

 const postitems = async (req, res) => {
  //  const title = req.body.title
  //  const description = req.body.description
    const {title, description} = req.body
    try {
        const item = new Item({
           title,
           description
        })
    
        const saveditem = await item.save()
        res.json({
            status: 200,
            message: 'item posted  successful',
            successfull:true,
            data:saveditem
        })
    } catch (error) {
        console.log(error);
    }
   
}

const putitems = async (req, res) => {
    const itemid = req.params.itemid

    const newtitle = req.body.title
    const newdescription = req.body.description
    try {
        const item = await Item.findById({id:itemid}).exec()

        if (!item) {
            console.log('item does not exist');
        }
    
        item.title = newtitle
        item.description = newdescription
    
        const updateditem = item.save()
        res.json({
            status: 200,
            message: 'item posted  successful',
            successfull:true,
            data:updateditem
        })
    } catch (error) {
        console.log(error);
    }

   

}

const deleteitem = (res,req) => {}

module.exports = {getitems, postitems, putitems}