export const SITE_URL = "https://hawwelapp.com";

export function canonicalUrl(path = "/"): string {
  if (!path.startsWith("/")) return `${SITE_URL}/${path}`;
  return `${SITE_URL}${path}`;
}
