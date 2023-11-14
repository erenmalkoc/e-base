const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const http = require("http");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const Document = require("./models/document");

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
const io = require("socket.io")(server);


app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

const DB = "mongodb+srv://yuirt992:knjZZPuSztp9VI7D@cluster0.lhn1qmj.mongodb.net/?retryWrites=true&w=majority";

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connection successful!");
    })
    .catch((err) => {
        console.error("Error connecting to MongoDB:", err);
    });


io.on("connection", (socket) => {
    socket.on("join", (documentId) => {
        socket.join(documentId);
    });

    socket.on("typing", (data) => {
        console.log(`calısiyorrr`);

        socket.broadcast.to(data.documentId).emit("changes", data);
    });


    socket.on("save", (data) => {
        saveData(data);
    });
});

const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
};

server.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});