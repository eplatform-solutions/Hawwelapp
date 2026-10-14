const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create Area Schema

const areaSchema = new mongoose.Schema({
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

areaSchema.index({ "name.ar": 1 });

areaSchema.index({ "name.en": 1 });

areaSchema.index({ city: 1 });

// Create Area Model From Area Schema
//
// The "areas" collection was renamed to "regions" in hawwel-admin-api
// (this app's sibling admin API, which shares the same MongoDB). This app's
// own model was never updated for that rename, so it kept reading/writing
// the old, now-abandoned "areas" collection while every region created or
// edited through the admin dashboard went into "regions" instead - the
// model name here stays "area" (existing `ref: "area"` usages elsewhere
// still resolve correctly), only the underlying collection is corrected.
const areaModel = dashboardDB.model("area", areaSchema, "regions");

module.exports = areaModel;