const { adminModel } = require("../../models/dashboard");

async function populateRole(admins) {
    return adminModel.populate(admins, {
        path: "role",
        select: "name description permissions",
        populate: {
            path: "permissions",
            select: "codeName name appLabel"
        }
    });
}

module.exports = {
    populateRole
}