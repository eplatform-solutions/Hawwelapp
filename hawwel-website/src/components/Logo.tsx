import { useState } from "react";
import { Link } from "react-router-dom";
import { useLanguage } from "../i18n/LanguageContext";

type LogoVariant = "header" | "footer" | "hero";

const sizeMap: Record<LogoVariant, { box: string; img: string; text: string }> = {
  header: {
    box: "h-10 sm:h-11 w-10 sm:w-11",
    img: "h-10 sm:h-11 w-10 sm:w-11",
    text: "text-base sm:text-lg",
  },
  footer: {
    box: "h-10 w-10",
    img: "h-10 w-10",
    text: "text-base",
  },
  hero: {
    box: "h-16 w-16 sm:h-20 sm:w-20",
    img: "h-16 w-16 sm:h-20 sm:w-20",
    text: "text-xl sm:text-2xl",
  },
};

type LogoProps = {
  variant?: LogoVariant;
  withWordmark?: boolean;
  asLink?: boolean;
  className?: string;
};

export default function Logo({
  variant = "header",
  withWordmark = true,
  asLink = true,
  className = "",
}: LogoProps) {
  const { lang } = useLanguage();
  const [imgFailed, setImgFailed] = useState(false);
  const sizes = sizeMap[variant];
  const altText =
    lang === "ar"
      ? "شعار Hawwel App — حوِّل"
      : "Hawwel App logo — حوِّل";

  const mark = !imgFailed ? (
    <span
      className={`inline-flex shrink-0 items-center justify-center overflow-hidden rounded-xl bg-brand-primary ${sizes.box}`}
    >
      <img
        src="/logo.png"
        alt={altText}
        className={`${sizes.img} object-contain`}
        onError={() => setImgFailed(true)}
        loading="eager"
        decoding="async"
      />
    </span>
  ) : (
    <span
      className={`inline-flex shrink-0 items-center justify-center rounded-xl bg-brand-primary ${sizes.box}`}
      aria-label={altText}
    >
      <span className="font-extrabold text-brand-gold tracking-wider">H</span>
    </span>
  );

  const wordmark = withWordmark ? (
    <span className={`flex flex-col leading-tight ${sizes.text}`}>
      <span className="font-bold text-brand-primary">Hawwel App</span>
      <span className="font-arabic font-bold text-brand-accent text-[0.85em] -mt-0.5">
        حوِّل
      </span>
    </span>
  ) : null;

  const inner = (
    <span className={`inline-flex items-center gap-3 ${className}`}>
      {mark}
      {wordmark}
    </span>
  );

  if (!asLink) return inner;

  return (
    <Link
      to="/"
      aria-label={altText}
      className="inline-flex items-center rounded-xl focus-visible:outline-none"
    >
      {inner}
    </Link>
  );
}
