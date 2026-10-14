// Define the function to verify that the IP is valid
function isValidIpAddress(ip) {
    return /^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}$/.test(ip);
}

module.exports = {
    isValidIpAddress
}