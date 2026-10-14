// pm2 definition of the two APIs on the VPS.
// Start or reload with:  pm2 start /opt/hawwel/ops/ecosystem.config.js && pm2 save
// Secrets are not set here; each API loads them from its own .env.production.
module.exports = {
    apps: [
        {
            name: "hawwel-api",
            cwd: "/opt/hawwel/hawwel-api",
            script: "index.js",
            exec_mode: "fork",
            instances: 1,
            autorestart: true,
            env: { NODE_ENV: "production" },
        },
        {
            name: "hawwel-admin-api",
            cwd: "/opt/hawwel/hawwel-admin-api",
            script: "index.js",
            exec_mode: "fork",
            instances: 1,
            autorestart: true,
            env: { NODE_ENV: "production" },
        },
    ],
};
