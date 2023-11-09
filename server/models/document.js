const mongoose = require('mongoose');
const documentSchema = mongoose.Schema({
    uid: {
        require: true,
        type: String,

    },
    createdAt: {
        require: true,
        type: Number
    },
    title: {
        require: true,
        type: String,
        trim: true
    },
    content: {
        type: Array,
        default: [],
    }


});
const Document = mongoose.model("Document",documentSchema)
module.exports = Document;