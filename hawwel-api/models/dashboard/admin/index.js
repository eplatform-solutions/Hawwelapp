const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

// Read-only view of the "admin" collection (owned by hawwel-admin-api)
// for identity checks only - e.g. confirming a chat socket's JWT belongs to
// a real, non-blocked admin. Deliberately excludes fields this repo has no
// business writing (password, role, blocking history, ...); { strict: false }
// keeps this resilient to the full schema evolving over there without this
// copy needing to track every field.
const adminSchema = new mongoose.Schema({
    fullName: {
        type: String,
        trim: true,
    },
    status: {
        type: String,
        trim: true,
    },
}, {
    timestamps: true,
    strict: false,
});

const adminModel = dashboardDB.model("admin", adminSchema);

module.exports = adminModel;
