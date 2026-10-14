const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create City Schema

const citySchema = new mongoose.Schema({
    name: {
        ar: {
            type: String,
            required: [true, "City name in Arabic is required"],
            trim: true
        },
        en: {
            type: String,
            required: [true, "City name in English is required"],
            trim: true
        }
    },
    country: {
        type: mongoose.Types.ObjectId,
        ref: "countrie",
        required: [true, "Country is required"],
        validate: {
            validator: mongoose.Types.ObjectId.isValid,
            message: "Invalid Country Id"
        }
    }
}, { timestamps: true });

citySchema.index({ country: 1 });

// Create City Model From City Schema

const cityModel = dashboardDB.model("citie", citySchema);

module.exports = cityModel;