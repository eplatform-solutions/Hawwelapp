const { config } = require("dotenv");

const { resolve } = require("path");

config({
    path: resolve(__dirname, `../../.env.${process.env.NODE_ENV || "development"}`),
})

const { createConnection } = require("../../helpers/databases");

const clientDB = createConnection("Client");

const dashboardDB = createConnection("Dashboard");

module.exports = {
    clientDB,
    dashboardDB
};