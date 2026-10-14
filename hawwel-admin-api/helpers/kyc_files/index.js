const path = require("path");
const { existsSync } = require("fs");

const KYC_STORED_PATH_REGEX = /^assets\/images\/kyc\/[a-f0-9-]{36}__[a-zA-Z0-9._()-]+\.(jpg|jpeg|png|webp|pdf)$/;

function getClientApiAssetsRoot() {
    if (process.env.CLIENT_API_ASSETS_ROOT) {
        return path.resolve(process.env.CLIENT_API_ASSETS_ROOT);
    }
    return path.resolve(__dirname, "../../../hawwel-api");
}

function resolveKycImagePaths(kyc) {
    if (!kyc) {
        return [];
    }
    const documentImages = Array.isArray(kyc.documentImages)
        ? kyc.documentImages.filter(Boolean)
        : [];
    if (documentImages.length > 0) {
        return documentImages;
    }
    if (kyc.filePath) {
        return [kyc.filePath];
    }
    return [];
}

function resolveClientKycAbsolutePath(storedRelativePath) {
    if (!storedRelativePath || !KYC_STORED_PATH_REGEX.test(storedRelativePath)) {
        return null;
    }
    const assetsRoot = getClientApiAssetsRoot();
    const kycRoot = path.resolve(assetsRoot, "assets/images/kyc");
    const absolutePath = path.resolve(assetsRoot, storedRelativePath);
    if (!absolutePath.startsWith(`${kycRoot}${path.sep}`) && absolutePath !== kycRoot) {
        return null;
    }
    if (!existsSync(absolutePath)) {
        return null;
    }
    return absolutePath;
}

function getContentTypeFromStoredPath(storedRelativePath) {
    const extension = path.extname(storedRelativePath).toLowerCase();
    switch (extension) {
        case ".jpg":
        case ".jpeg":
            return "image/jpeg";
        case ".png":
            return "image/png";
        case ".webp":
            return "image/webp";
        case ".pdf":
            return "application/pdf";
        default:
            return "application/octet-stream";
    }
}

module.exports = {
    resolveKycImagePaths,
    resolveClientKycAbsolutePath,
    getContentTypeFromStoredPath,
};
