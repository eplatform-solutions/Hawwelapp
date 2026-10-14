const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { isValidIpAddress } = require("../../../validators/network/ip");

// Create Login Log Schema

const loginLogSchema = new mongoose.Schema({
    user: {
        type: mongoose.Types.ObjectId,
        ref: "user",
        required: [true, "User is required"],
        validate: {
            validator: function (v) {
                return mongoose.Types.ObjectId.isValid(v);
            },
            message: "Invalid User Id"
        }
    },
    ipAddress: {
        type: String,
        required: [true, "IP Address is required"],
        trim: true,
        validate: {
            validator: function (v) {
                if (!v) return false;
                return isValidIpAddress(v);
            },
            message: (props) => `Sorry, ${props.value} is not a valid IP address`
        }
    }
}, {
    timestamps: true
});

loginLogSchema.index({ createdAt: -1 });

loginLogSchema.index({ user: 1 });

loginLogSchema.index({ ipAddress: 1 });

// Create Login Log Model From Login Log Schema

const loginLogModel = dashboardDB.model("login_log", loginLogSchema);

module.exports = loginLogModel;