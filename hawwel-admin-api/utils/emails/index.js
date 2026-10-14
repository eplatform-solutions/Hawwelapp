const { createTransport } = require("nodemailer");

// Function to configure SMTP server email transport settings
function getTransporter(bussinessEmailPassword) {
    // Port 465 (e.g. Cloudflare Email Service) uses implicit TLS; other ports (e.g. 587 on
    // Hostinger) start in plain text and upgrade with STARTTLS.
    const implicitTls = Number(process.env.SMTP_PORT) === 465;
    const transporter = createTransport({
        host: process.env.SMTP_HOST,
        port: process.env.SMTP_PORT,
        secure: implicitTls,
        requireTLS: !implicitTls,
        auth: {
            // Providers such as Cloudflare Email Service use a login that differs from the sender address.
            user: process.env.SMTP_USER || process.env.BUSSINESS_EMAIL,
            pass: bussinessEmailPassword,
        },
        // The legacy cipher setting is kept only for the STARTTLS hosts it was added for.
        ...(implicitTls ? {} : { tls: { ciphers: "SSLv3" } }),
    });
    return transporter;
}

module.exports = {
    getTransporter
}
