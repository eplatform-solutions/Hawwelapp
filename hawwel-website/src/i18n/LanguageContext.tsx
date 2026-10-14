import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import { translations, type Lang, type TranslationKey } from "./translations";
import { normalizeBrandText } from "../utils/brand";

const STORAGE_KEY = "hawwel.lang";
const DEFAULT_LANG: Lang = "ar";

type LanguageContextValue = {
  lang: Lang;
  dir: "ltr" | "rtl";
  setLang: (lang: Lang) => void;
  toggleLang: () => void;
  t: (key: TranslationKey) => string;
  tArr: (key: TranslationKey) => string[];
};

const LanguageContext = createContext<LanguageContextValue | undefined>(
  undefined,
);

function readStoredLang(): Lang {
  if (typeof window === "undefined") return DEFAULT_LANG;
  try {
    const stored = window.localStorage.getItem(STORAGE_KEY);
    if (stored === "ar" || stored === "en") return stored;
  } catch {
    // ignore storage errors (private mode, etc.)
  }
  return DEFAULT_LANG;
}

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [lang, setLangState] = useState<Lang>(() => readStoredLang());

  useEffect(() => {
    const dir: "ltr" | "rtl" = lang === "ar" ? "rtl" : "ltr";
    document.documentElement.lang = lang;
    document.documentElement.dir = dir;
    try {
      window.localStorage.setItem(STORAGE_KEY, lang);
    } catch {
      // ignore
    }
  }, [lang]);

  const setLang = useCallback((next: Lang) => setLangState(next), []);
  const toggleLang = useCallback(
    () => setLangState((prev) => (prev === "ar" ? "en" : "ar")),
    [],
  );

  const t = useCallback(
    (key: TranslationKey): string => {
      const entry = translations[key];
      if (!entry) {
        if (import.meta.env?.DEV) {
          console.warn(`Missing translation key: ${key}`);
        }
        return key;
      }
      const value = entry[lang];
      if (Array.isArray(value)) return normalizeBrandText(value.join("\n"));
      return normalizeBrandText(value);
    },
    [lang],
  );

  const tArr = useCallback(
    (key: TranslationKey): string[] => {
      const entry = translations[key];
      if (!entry) return [];
      const value = entry[lang];
      const values = Array.isArray(value) ? value : [value];
      return values.map((item) => normalizeBrandText(item));
    },
    [lang],
  );

  const value = useMemo<LanguageContextValue>(
    () => ({
      lang,
      dir: lang === "ar" ? "rtl" : "ltr",
      setLang,
      toggleLang,
      t,
      tArr,
    }),
    [lang, setLang, toggleLang, t, tArr],
  );

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const ctx = useContext(LanguageContext);
  if (!ctx) {
    throw new Error("useLanguage must be used within LanguageProvider");
  }
  return ctx;
}
