import type { ReactNode } from "react";

type Props = {
  id?: string;
  title?: ReactNode;
  eyebrow?: ReactNode;
  subtitle?: ReactNode;
  children: ReactNode;
  align?: "start" | "center";
  tone?: "default" | "muted" | "dark";
  className?: string;
  containerClassName?: string;
};

const toneClasses: Record<NonNullable<Props["tone"]>, string> = {
  default: "bg-transparent",
  muted: "bg-white",
  dark: "bg-brand-primary text-brand-bg",
};

export default function Section({
  id,
  title,
  eyebrow,
  subtitle,
  children,
  align = "start",
  tone = "default",
  className = "",
  containerClassName = "",
}: Props) {
  const isDark = tone === "dark";
  return (
    <section
      id={id}
      className={`py-16 sm:py-20 ${toneClasses[tone]} ${className}`}
    >
      <div className={`container-app ${containerClassName}`}>
        {(eyebrow || title || subtitle) && (
          <header
            className={`mb-10 sm:mb-12 max-w-prose ${align === "center" ? "mx-auto text-center" : ""}`}
          >
            {eyebrow && (
              <p
                className={`text-xs sm:text-sm font-semibold uppercase tracking-[0.18em] mb-3 ${isDark ? "text-brand-gold" : "text-brand-accent"}`}
              >
                {eyebrow}
              </p>
            )}
            {title && (
              <h2
                className={`text-2xl sm:text-3xl lg:text-4xl font-extrabold leading-tight ${isDark ? "text-white" : ""}`}
              >
                {title}
              </h2>
            )}
            {subtitle && (
              <p
                className={`mt-4 text-base sm:text-lg leading-relaxed ${isDark ? "text-white/80" : "text-brand-text/75"}`}
              >
                {subtitle}
              </p>
            )}
          </header>
        )}
        {children}
      </div>
    </section>
  );
}
