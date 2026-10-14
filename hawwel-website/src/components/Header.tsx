import { useEffect, useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import { useLanguage } from "../i18n/LanguageContext";
import Logo from "./Logo";
import LanguageToggle from "./LanguageToggle";
import StoreBadges from "./StoreBadges";

const navItems = [
  { to: "/", key: "nav.home" as const, end: true },
  { to: "/how-it-works", key: "nav.howItWorks" as const },
  { to: "/available-regions", key: "nav.regions" as const },
  { to: "/support", key: "nav.support" as const },
  { to: "/contact", key: "nav.contact" as const },
];

export default function Header() {
  const { t } = useLanguage();
  const [open, setOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const location = useLocation();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    setOpen(false);
  }, [location.pathname]);

  useEffect(() => {
    document.body.style.overflow = open ? "hidden" : "";
    return () => {
      document.body.style.overflow = "";
    };
  }, [open]);

  return (
    <header
      className={`sticky top-0 z-40 w-full backdrop-blur transition-colors ${
        scrolled
          ? "bg-brand-bg/85 border-b border-brand-line/70"
          : "bg-brand-bg/70"
      }`}
    >
      <div className="container-app flex items-center justify-between gap-4 py-3 sm:py-4">
        <Logo variant="header" />

        <nav
          aria-label="primary"
          className="hidden lg:flex items-center gap-1"
        >
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) =>
                `px-3 py-2 rounded-full text-sm font-medium transition-colors ${
                  isActive
                    ? "text-brand-primary bg-brand-primary/5"
                    : "text-brand-text/75 hover:text-brand-primary hover:bg-brand-primary/5"
                }`
              }
            >
              {t(item.key)}
            </NavLink>
          ))}
        </nav>

        <div className="flex items-center gap-2 sm:gap-3">
          <LanguageToggle />
          <button
            type="button"
            onClick={() => setOpen((v) => !v)}
            aria-expanded={open}
            aria-controls="mobile-nav"
            aria-label={open ? t("common.closeMenu") : t("common.openMenu")}
            className="lg:hidden inline-flex h-10 w-10 items-center justify-center rounded-full border border-brand-line bg-white text-brand-primary"
          >
            {open ? (
              <svg viewBox="0 0 24 24" className="h-5 w-5" aria-hidden="true">
                <path
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  d="M6 6l12 12M6 18L18 6"
                />
              </svg>
            ) : (
              <svg viewBox="0 0 24 24" className="h-5 w-5" aria-hidden="true">
                <path
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  d="M4 7h16M4 12h16M4 17h16"
                />
              </svg>
            )}
          </button>
        </div>
      </div>

      {open && (
        <div
          id="mobile-nav"
          className="lg:hidden border-t border-brand-line/70 bg-brand-bg/98 backdrop-blur"
        >
          <div className="container-app py-4">
            <nav aria-label="mobile" className="flex flex-col gap-1">
              {navItems.map((item) => (
                <NavLink
                  key={item.to}
                  to={item.to}
                  end={item.end}
                  className={({ isActive }) =>
                    `px-4 py-3 rounded-xl text-base font-medium transition-colors ${
                      isActive
                        ? "text-brand-primary bg-brand-primary/5"
                        : "text-brand-text/85 hover:text-brand-primary hover:bg-brand-primary/5"
                    }`
                  }
                >
                  {t(item.key)}
                </NavLink>
              ))}
            </nav>
            <div className="mt-5 pt-5 border-t border-brand-line/70">
              <StoreBadges variant="compact" />
            </div>
          </div>
        </div>
      )}
    </header>
  );
}
