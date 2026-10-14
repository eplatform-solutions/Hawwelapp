<template>
    <svg width="300" height="300" viewBox="0 0 300 300">
        <!-- group لتدوير البداية للأعلى -->
        <g transform="rotate(-90 150 150)">

            <!-- القوس الأول (30%) -->
            <circle cx="150" cy="150" r="110" fill="none" stroke="#0F766E" stroke-width="30" stroke-dasharray="207 483"
                stroke-dashoffset="0" stroke-linecap="butt" />

            <!-- القوس الثاني (70%) -->
            <circle cx="150" cy="150" r="110" fill="none" stroke="#2563EB" stroke-width="30" stroke-dasharray="483 207"
                stroke-dashoffset="-207" stroke-linecap="butt" />
        </g>

        <!-- النص الأول -->
        <text x="230" y="150" font-size="14" font-weight="700" fill="#000" text-anchor="middle"
            dominant-baseline="middle" transform="rotate(90 230 150)">
            صنف أول - 30%
        </text>

        <!-- النص الثاني -->
        <text x="70" y="150" font-size="14" font-weight="700" fill="#000" text-anchor="middle"
            dominant-baseline="middle" transform="rotate(-90 70 150)">
            صنف ثاني - 70%
        </text>
    </svg>
</template>