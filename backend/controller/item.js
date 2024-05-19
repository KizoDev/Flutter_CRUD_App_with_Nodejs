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
    const itemId = req.params.itemId

    const newTitle = req.body.title
    const newDescription = req.body.description
    try {
        const updatedItem = await Item.findByIdAndUpdate(itemId, 
            { title: newTitle, description: newDescription }, { new: true });

        if (!updatedItem) {
            console.log('item does not exist');
        }
    
        const updateitem = await updatedItem.save()
        res.json({
            status: 200,
            message: 'item updated successful',
            successfull:true,
            data:updateitem
        })
    } catch (error) {
        console.log(error);
    }

   

}

const deleteitem = async(req, res) => {
    const itemId = req.params.itemId
    try {
        const itemdelete = await Item.findByIdAndDelete(itemId)

    if (!itemdelete) {
        console.log('item does not exist');
        console.log(itemdelete);
    }
    res.json({
        status: 200,
        message: 'item deleted  successful',
        successfull:true,
    })
    } catch (error) {
        console.log(error);
    }
    

}

module.exports = {getitems, postitems, putitems, deleteitem}