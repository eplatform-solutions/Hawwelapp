/** صفحة المتصفح لـ GET / واستجابة /health */
const { clientDB, dashboardDB } = require("../database/connections");

const redis = require("../config/redis");

function sendLanding(res) {
    res.status(200).type("html").send(`<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>تطبيق العميل — API</title>
<style>
body{font-family:system-ui,sans-serif;max-width:42rem;margin:2rem auto;padding:0 1rem;line-height:1.6;color:#1a1a1a}
code{background:#f0f0f0;padding:.15rem .4rem;border-radius:4px}
h1{font-size:1.25rem}
.note{background:#eef6ff;border:1px solid #b8d4f0;padding:1rem;border-radius:8px;margin:1rem 0}
ul{padding-right:1.2rem}
</style>
</head>
<body>
<h1>خادم API التطبيق (العميل)</h1>
<p><strong>المنفذ الافتراضي في التطوير غالباً:</strong> <code>3030</code> — لوحة الإدارة منفصل وتعمل عادة على <code>3033</code>.</p>
<p>هذا <strong>REST API</strong> لتطبيق الجوال وليس موقعاً للمتصفح.</p>
<div class="note">
<ul>
<li><code>POST /auth/login</code> — تسجيل الدخول</li>
<li><code>GET /health</code> — فحص الحالة</li>
</ul>
</div>
</body>
</html>`);
}

function sendHealth(res) {
    const clientReady = clientDB.readyState === 1;
    const dashboardReady = dashboardDB.readyState === 1;
    const redisReady = redis.status === "ready";
    // Redis being down doesn't take the API down (rate limiters fail open -
    // see helpers/rate_limit), so it's surfaced as "degraded" rather than
    // flipping the overall health check to unhealthy.
    const ok = clientReady && dashboardReady;
    const httpStatus = ok ? 200 : 503;
    res.status(httpStatus).json({
        ok,
        degraded: ok && !redisReady,
        service: "hawwel-client-api",
        databases: {
            client: clientReady ? "connected" : "disconnected",
            dashboard: dashboardReady ? "connected" : "disconnected"
        },
        redis: redisReady ? "connected" : "disconnected"
    });
}

module.exports = { sendLanding, sendHealth };
