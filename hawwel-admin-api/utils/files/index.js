const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const UPLOAD_DIRS = [
    "assets/images/payment_methods",
    "assets/images/app_identity",
    "assets/images/transfers",
];

function ensureUploadDir(relativeDir) {
    fs.mkdirSync(path.resolve(process.cwd(), relativeDir), { recursive: true });
}

function ensureUploadDirs(dirs = UPLOAD_DIRS) {
    for (const dir of dirs) {
        ensureUploadDir(dir);
    }
}

function generateSafeFileName(originalName) {
    const ext = originalName.split(".").pop().toLowerCase();
    let baseName = originalName
        .replace(/\.[^/.]+$/, "")
        .replace(/\s+/g, "_")
        .replace(/[^a-zA-Z0-9._()-]/g, "")
        .replace(/_+/g, "_")
        .replace(/^_+|_+$/g, "");
    if (!baseName) baseName = "file";
    const uniqueName = `${crypto.randomUUID()}__${baseName}.${ext}`;
    return uniqueName;
}

module.exports = {
    generateSafeFileName,
    ensureUploadDir,
    ensureUploadDirs,
    UPLOAD_DIRS,
};