const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create Contact Info Schema

const contactInfoSchema = new mongoose.Schema({
    mobilePhones: [
        {
            type: String,
            required: [true, "Mobile phone is required"],
            trim: true,
            validate: {
                validator: function (v) {
                    return /^[+0-9]{6,20}$/.test(v);
                },
                message: "Invalid mobile phone format"
            }
        }
    ],
    email: {
        type: String,
        required: [true, "Email is required"],
        lowercase: true,
        trim: true,
        validate: {
            validator: function (v) {
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
            },
            message: "Invalid email format"
        }
    }
}, { timestamps: true });

contactInfoSchema.index({ email: 1 });

contactInfoSchema.index({ "mobilePhones": 1 });

// Create Contact Info Model From Contact Info Schema

const contactInfoModel = dashboardDB.model("contact_info", contactInfoSchema);

module.exports = contactInfoModel;