import { useLanguage } from "../i18n/LanguageContext";

type Props = {
  variant?: "header" | "footer";
  className?: string;
};

export default function LanguageToggle({
  variant = "header",
  className = "",
}: Props) {
  const { lang, setLang, t } = useLanguage();

  const baseTone =
    variant === "footer"
      ? "border-white/15 bg-transparent"
      : "border-brand-line bg-white";

  const activeTone =
    variant === "footer"
      ? "bg-brand-gold text-brand-primary"
      : "bg-brand-primary text-white";

  const inactiveTone =
    variant === "footer"
      ? "text-white/70 hover:text-white"
      : "text-brand-text/70 hover:text-brand-primary";

  return (
    <div
      role="group"
      aria-label={t("common.languageSwitcherLabel")}
      className={`inline-flex items-center rounded-full border p-1 ${baseTone} ${className}`}
    >
      <button
        type="button"
        onClick={() => setLang("en")}
        aria-pressed={lang === "en"}
        className={`px-3 py-1 text-xs font-bold rounded-full transition-colors ${
          lang === "en" ? activeTone : inactiveTone
        }`}
      >
        EN
      </button>
      <button
        type="button"
        onClick={() => setLang("ar")}
        aria-pressed={lang === "ar"}
        className={`px-3 py-1 text-xs font-bold rounded-full transition-colors font-arabic ${
          lang === "ar" ? activeTone : inactiveTone
        }`}
      >
        AR
      </button>
    </div>
  );
}
