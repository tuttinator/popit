"use strict"; 

var mongoose         = require('mongoose'),
    Schema            = mongoose.Schema;


var OtherNamesSchema = module.exports = new Schema({
  name: { type: Schema.Types.Mixed, required: true, trim: true },
  note: String,
  start_date: String,
  end_date: String,
}, { strict: false } );

