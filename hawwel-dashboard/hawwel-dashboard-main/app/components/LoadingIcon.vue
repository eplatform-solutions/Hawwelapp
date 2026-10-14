<template>
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 100 100"
        preserveAspectRatio="xMidYMid" width="200" height="200"
        style="shape-rendering: auto; display: block; background: rgba(255, 255, 255, 0);">
        <g>
            <circle fill="#e15b64" r="10" cy="50" cx="84">
                <animate begin="0s" keySplines="0 0.5 0.5 1" values="10;0" keyTimes="0;1" calcMode="spline" dur="0.25s"
                    repeatCount="indefinite" attributeName="r" />
                <animate begin="0s" values="#e15b64;#abbd81;#f8b26a;#f47e60;#e15b64" keyTimes="0;0.25;0.5;0.75;1"
                    calcMode="discrete" dur="1s" repeatCount="indefinite" attributeName="fill" />
            </circle>
            <circle fill="#e15b64" r="10" cy="50" cx="16">
                <animate begin="0s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1" values="0;0;10;10;10"
                    keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s" repeatCount="indefinite"
                    attributeName="r" />
                <animate begin="0s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1" values="16;16;16;50;84"
                    keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s" repeatCount="indefinite"
                    attributeName="cx" />
            </circle>
            <circle fill="#f47e60" r="10" cy="50" cx="50">
                <animate begin="-0.25s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1"
                    values="0;0;10;10;10" keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s"
                    repeatCount="indefinite" attributeName="r" />
                <animate begin="-0.25s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1"
                    values="16;16;16;50;84" keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s"
                    repeatCount="indefinite" attributeName="cx" />
            </circle>
            <circle fill="#f8b26a" r="10" cy="50" cx="84">
                <animate begin="-0.5s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1"
                    values="0;0;10;10;10" keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s"
                    repeatCount="indefinite" attributeName="r" />
                <animate begin="-0.5s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1"
                    values="16;16;16;50;84" keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s"
                    repeatCount="indefinite" attributeName="cx" />
            </circle>
            <circle fill="#abbd81" r="10" cy="50" cx="16">
                <animate begin="-0.75s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1"
                    values="0;0;10;10;10" keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s"
                    repeatCount="indefinite" attributeName="r" />
                <animate begin="-0.75s" keySplines="0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1;0 0.5 0.5 1"
                    values="16;16;16;50;84" keyTimes="0;0.25;0.5;0.75;1" calcMode="spline" dur="1s"
                    repeatCount="indefinite" attributeName="cx" />
            </circle>
            <g />
        </g>
    </svg>
</template>