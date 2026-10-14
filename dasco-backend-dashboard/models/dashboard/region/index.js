const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create Region Schema
// (renamed from "Area" - see scripts/migrate-areas-to-regions.js for the
// one-time collection rename this depended on)

const regionSchema = new mongoose.Schema({
    name: {
        ar: {
            type: String,
            required: [true, "Arabic name is required"],
            trim: true,
            minlength: [1, "Arabic name cannot be empty"],
            maxlength: [100, "Arabic name cannot exceed 100 characters"]
        },
        en: {
            type: String,
            required: [true, "English name is required"],
            trim: true,
            minlength: [1, "English name cannot be empty"],
            maxlength: [100, "English name cannot exceed 100 characters"]
        }
    },
    city: {
        type: mongoose.Types.ObjectId,
        ref: "citie",
        required: [true, "City is required"],
        validate: {
            validator: function (v) {
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid city Id"
        }
    }
}, { timestamps: true });

regionSchema.index({ "name.ar": 1 });

regionSchema.index({ "name.en": 1 });

regionSchema.index({ city: 1 });

// Create Region Model From Region Schema

const regionModel = dashboardDB.model("region", regionSchema);

module.exports = regionModel;
