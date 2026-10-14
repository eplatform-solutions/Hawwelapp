const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { COUNTRIES } = require("../../../constants/countries");

// Create Country Schema

const countrySchema = new mongoose.Schema({
    code: {
        type: String,
        required: [true, "Country code is required"],
        enum: {
            values: COUNTRIES,
            message: "Invalid country code"
        },
        uppercase: true,
        trim: true
    }
}, { timestamps: true });

countrySchema.index({ code: 1 }, { unique: true });

// Create Country Model From Country Schema

const countryModel = dashboardDB.model("countrie", countrySchema);

module.exports = countryModel;