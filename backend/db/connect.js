const mongoose = require('mongoose')
const url = process.env.MONGODB_URI

const connectDB = (url) => {
  return mongoose.connect(url, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,    
  })
}

module.exports = connectDB