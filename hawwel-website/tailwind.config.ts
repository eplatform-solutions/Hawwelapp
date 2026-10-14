import type { Config } from "tailwindcss";

export default {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        brand: {
          primary: "#0E2B2B",
          gold: "#D6C49A",
          goldSoft: "#E8DDC2",
          bg: "#F7F6F1",
          surface: "#FFFFFF",
          text: "#13201F",
          muted: "#66706D",
          accent: "#1F6F5B",
          line: "#E5E2D6",
        },
      },
      fontFamily: {
        sans: [
          "Inter",
          "Tajawal",
          "system-ui",
          "-apple-system",
          "Segoe UI",
          "sans-serif",
        ],
        arabic: [
          "Tajawal",
          "Inter",
          "system-ui",
          "-apple-system",
          "sans-serif",
        ],
        display: [
          "Inter",
          "Tajawal",
          "system-ui",
          "sans-serif",
        ],
      },
      boxShadow: {
        card: "0 1px 2px rgba(19,32,31,0.04), 0 8px 24px rgba(19,32,31,0.06)",
        cardHover:
          "0 2px 4px rgba(19,32,31,0.06), 0 16px 40px rgba(19,32,31,0.10)",
        ring: "0 0 0 4px rgba(214,196,154,0.35)",
      },
      borderRadius: {
        xl: "0.875rem",
        "2xl": "1.25rem",
        "3xl": "1.75rem",
      },
      maxWidth: {
        content: "72rem",
        prose: "44rem",
      },
      keyframes: {
        fadeUp: {
          "0%": { opacity: "0", transform: "translateY(8px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        fadeIn: {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        slideUp: {
          "0%": { opacity: "0", transform: "translateY(16px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
      },
      animation: {
        fadeUp: "fadeUp 0.4s ease-out both",
        fadeIn: "fadeIn 0.2s ease-out both",
        slideUp: "slideUp 0.3s ease-out both",
      },
    },
  },
  plugins: [],
} satisfies Config;
