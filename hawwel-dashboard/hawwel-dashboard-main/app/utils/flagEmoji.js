// Converts a two-letter ISO country code into its flag emoji, e.g. "SY" -> 🇸🇾.
// Each letter maps to a Regional Indicator Symbol; no image assets needed.
export function isoToFlagEmoji(iso2) {
    if (!iso2 || iso2.length !== 2) return '🌍';
    return iso2
        .toUpperCase()
        .replace(/./g, (char) => String.fromCodePoint(127397 + char.charCodeAt(0)));
}
