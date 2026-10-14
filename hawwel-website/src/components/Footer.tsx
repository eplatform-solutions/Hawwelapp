import { Link } from "react-router-dom";
import { useLanguage } from "../i18n/LanguageContext";
import { siteContent } from "../content/siteContent";
import Logo from "./Logo";
import LanguageToggle from "./LanguageToggle";

const primaryLegalLinks = [
  { to: "/terms", key: "footer.termsOfService" as const },
  { to: "/privacy", key: "footer.privacy" as const },
  { to: "/contact", key: "footer.supportContact" as const },
];

const complianceLinks = [
  { to: "/legal", key: "footer.legalNotice" as const },
  { to: "/aml-kyc", key: "footer.amlKyc" as const },
  { to: "/delete-account", key: "footer.deleteAccount" as const },
];

export default function Footer() {
  const { t } = useLanguage();
  const year = new Date().getFullYear();
  const registrationClause = siteContent.operatorRegistrationCode
    ? ` (Registration Code: ${siteContent.operatorRegistrationCode}, Lithuania)`
    : " (Lithuania)";
  const corporateDisclosure = t("footer.corporateDisclosure")
    .replace("{year}", String(year))
    .replace("{registrationClause}", registrationClause);

  return (
    <footer className="mt-16 sm:mt-24 bg-brand-primary text-white">
      <div className="container-app py-12 sm:py-16">
        <div className="grid gap-10 md:grid-cols-12 md:gap-12">
          <div className="md:col-span-5">
            <Logo variant="footer" />
            <p className="mt-5 max-w-lg text-sm leading-relaxed text-white/75">
              {t("footer.disclaimer")}
            </p>
            <div className="mt-6">
              <LanguageToggle variant="footer" />
            </div>
            <div className="mt-8 space-y-3 text-sm">
              <p className="text-xs uppercase tracking-wider text-white/55">
                {t("footer.supportContact")}
              </p>
              <a
                href={`mailto:${siteContent.supportEmail}`}
                className="inline-flex min-h-11 items-center text-white font-semibold hover:text-brand-gold transition-colors break-all"
              >
                {siteContent.supportEmail}
              </a>
              <div>
                <Link
                  to="/support"
                  className="text-white/75 hover:text-brand-gold transition-colors underline-offset-4 hover:underline"
                >
                  {t("footer.support")}
                </Link>
              </div>
              <a
                href={siteContent.operatorWebsite}
                target="_blank"
                rel="noopener noreferrer"
                className="text-white/75 hover:text-brand-gold transition-colors inline-flex items-center gap-1.5"
              >
                {t("footer.companyWebsite")}
                <svg viewBox="0 0 24 24" className="h-3.5 w-3.5" aria-hidden="true">
                  <path
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    d="M14 4h6v6M20 4l-9 9M5 7v12h12"
                  />
                </svg>
              </a>
            </div>
          </div>

          <div className="md:col-span-7 grid grid-cols-1 sm:grid-cols-2 gap-10">
            <FooterColumn
              title={t("footer.legal")}
              links={primaryLegalLinks.map((l) => ({ to: l.to, label: t(l.key) }))}
            />
            <FooterColumn
              title={t("footer.help")}
              links={[
                { to: "/support", label: t("footer.support") },
                { to: "/contact", label: t("footer.contact") },
                ...complianceLinks.map((l) => ({ to: l.to, label: t(l.key) })),
              ]}
            />
          </div>
        </div>

        <div className="mt-12 pt-8 border-t border-white/10">
          <p className="text-[11px] sm:text-xs leading-relaxed text-white/55 max-w-5xl">
            {corporateDisclosure}
          </p>
        </div>
      </div>
    </footer>
  );
}

function FooterColumn({
  title,
  links,
}: {
  title: string;
  links: { to: string; label: string }[];
}) {
  return (
    <div>
      <h3 className="text-sm font-semibold text-white mb-3 uppercase tracking-wider">
        {title}
      </h3>
      <ul className="space-y-2.5 text-sm">
        {links.map((l) => (
          <li key={l.to + l.label}>
            <Link
              to={l.to}
              className="inline-flex min-h-11 sm:min-h-0 items-center text-white/75 hover:text-brand-gold transition-colors"
            >
              {l.label}
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}
