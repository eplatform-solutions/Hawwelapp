const { STATUS_MAP } = require("../../constants/responses");

// Function to return the response object with status and data
function getResponseObject(msg, isError, data, isReturnStatusCode = false, statusCode = 200) {
    return {
        msg,
        error: isError,
        data,
        ...isReturnStatusCode && { statusCode }
    }
}

function handleResponse(result, res) {
    const code = result?.code;
    if (!code) return res.json(result);
    delete result.code;
    const status = STATUS_MAP[code];
    if (!status) return res.json(result);
    return res.status(status).json(result);
}

module.exports = {
    getResponseObject,
    handleResponse
}