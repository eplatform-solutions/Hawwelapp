const env = process.env.NODE_ENV;

let tatum_webhook_allowed_ips = [];

if (env === "development" || env === "test") {
    tatum_webhook_allowed_ips = [
        "127.0.0.1"
    ];
}

else {
    tatum_webhook_allowed_ips = [
        "34.159.145.109",
        "34.141.100.123",
        "34.159.213.87",
        "34.90.179.194",
        "35.204.31.189",
        "35.185.216.99",
        "34.145.44.151",
        "34.83.123.121",
        "34.82.77.148",
        "34.168.150.1"
    ];
}

module.exports = {
    tatum_webhook_allowed_ips
};