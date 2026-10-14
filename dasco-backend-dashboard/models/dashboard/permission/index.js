const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const { INITIAL_PERMISSION_CODE_NAMES, INITIAL_PERMISSION_NAMES, INITIAL_PERMISSION_APP_LABELS } = require("../../../constants/permissions")

const permissionSchema = new mongoose.Schema({
    codeName: {
        type: String,
        required: [true, "Permission codeName is required"],
        enum: {
            values: INITIAL_PERMISSION_CODE_NAMES,
            message: "Invalid permission codeName"
        },
        trim: true
    },
    name: {
        type: String,
        required: [true, "Permission name is required"],
        enum: {
            values: INITIAL_PERMISSION_NAMES,
            message: "Invalid permission name"
        },
        trim: true
    },
    appLabel: {
        type: String,
        required: [true, "App label is required"],
        enum: {
            values: INITIAL_PERMISSION_APP_LABELS,
            message: "Invalid app label"
        },
        trim: true
    }
}, { timestamps: true });

permissionSchema.index({ codeName: 1 }, { unique: true });

permissionSchema.index({ name: 1 }, { unique: true });

const permissionModel = dashboardDB.model("permission", permissionSchema);

module.exports = permissionModel;