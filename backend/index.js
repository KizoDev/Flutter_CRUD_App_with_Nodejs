const express = require("express");
const app = express()
const mongoose = require('mongoose')
const dotenv = require("dotenv");
dotenv.config();
const url = process.env.MONGODB_URI

app.use(express.urlencoded({ extended: true }))


const routerget = require('./router/item')
const routerpost = require('./router/item')
const routerput = require('./router/item')
const routerdelete = require('./router/item')

app.use(express.json());
app.use('/api', routerget)
app.use('/api', routerpost)
app.use('/', routerput)
app.use('/', routerdelete)



const port = process.env.PORT || 8000;



const start = async () => {
  try {
    mongoose.connect(url, {   
      })
    app.listen(port, () =>
      console.log(`Server is listening on port ${port}...`)
    );
  } catch (error) {
    console.log(error);
  }
};

start();