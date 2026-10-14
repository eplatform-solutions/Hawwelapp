const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Create FAQ Schema

const faqSchema = new mongoose.Schema({
    question: {
        ar: {
            type: String,
            required: [true, "Question (AR) is required"],
            trim: true,
        },
        en: {
            type: String,
            required: [true, "Question (EN) is required"],
            trim: true,
        }
    },
    answer: {
        ar: {
            type: String,
            required: [true, "Answer (AR) is required"],
            trim: true,
        },
        en: {
            type: String,
            required: [true, "Answer (EN) is required"],
            trim: true,
        }
    },
}, {
    timestamps: true,
});

faqSchema.index({ "question.ar": 1 });

faqSchema.index({ "question.en": 1 });

// Create FAQ Model From FAQ Schema

const faqModel = dashboardDB.model("faq", faqSchema);

module.exports = faqModel;