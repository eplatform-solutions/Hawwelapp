const mongoose = require("mongoose");

const { dashboardDB } = require("../../../database/connections");

const roleSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Role name is required"],
        trim: true,
        minlength: [2, "Role name must be at least 2 characters"],
        maxlength: [100, "Role name cannot exceed 100 characters"]
    },
    description: {
        type: String,
        required: [true, "Role description is required"],
        trim: true,
        minlength: [5, "Role description must be at least 5 characters"],
        maxlength: [500, "Role description cannot exceed 500 characters"]
    },
    permissions: {
        type: [
            {
                type: mongoose.Types.ObjectId,
                ref: "permission"
            }
        ],
        validate: {
            validator: function (v) {
                if (!v || v.length === 0) return true; // يسمح بالمصفوفة الفارغة
                return v.every(id => mongoose.Types.ObjectId.isValid(id));
            },
            message: props => `Invalid permission Ids in array: ${props.value}`
        },
        default: []
    }
}, { timestamps: true });

roleSchema.index({ name: 1 }, { unique: true });

const roleModel = dashboardDB.model("role", roleSchema);

module.exports = roleModel;