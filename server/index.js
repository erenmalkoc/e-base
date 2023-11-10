const express = require('express');
const mongoose = require("mongoose");
const http = require("http");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const cors =require('cors');

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);
const DB = "mongodb+srv://yuirt992:knjZZPuSztp9VI7D@cluster0.lhn1qmj.mongodb.net/?retryWrites=true&w=majority";



mongoose.connect(DB).then(
    () => {
        console.log("Connection Successful!");
    }
).catch((err) => {
    console.log(err);
});


io.on('connection',(socket)=> {
  socket.on('join',(documentId)=> {
      socket.join(documentId);
      console.log("joined!");
  });
    socket.on('typing',(data)=> {
socket.broadcast.to(data.room).emit("changes",data);
    });
});




server.listen(PORT, "0.0.0.0", () => {

    console.log(`connected at port ${PORT}`);
});