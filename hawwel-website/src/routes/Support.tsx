import { useState } from "react";
import { Helmet } from "react-helmet-async";
import { useLanguage } from "../i18n/LanguageContext";
import Seo from "../components/Seo";
import Card from "../components/Card";

function ChevronIcon({ open }: { open: boolean }) {
  return (
    <svg
      viewBox="0 0 24 24"
      className={`h-5 w-5 transition-transform ${open ? "rotate-180" : ""}`}
      aria-hidden="true"
    >
      <path
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M6 9l6 6 6-6"
      />
    </svg>
  );
}

function FAQItem({
  question,
  answer,
  defaultOpen = false,
}: {
  question: string;
  answer: string;
  defaultOpen?: boolean;
}) {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <div className="rounded-2xl border border-brand-line bg-white">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        aria-expanded={open}
        className="flex w-full items-center justify-between gap-4 p-5 text-start"
      >
        <span className="text-base sm:text-lg font-semibold text-brand-primary">
          {question}
        </span>
        <span className="text-brand-primary/70">
          <ChevronIcon open={open} />
        </span>
      </button>
      {open && (
        <div className="px-5 pb-5 -mt-1 text-sm sm:text-base text-brand-text/80 leading-relaxed">
          {answer}
        </div>
      )}
    </div>
  );
}

export default function Support() {
  const { t } = useLanguage();

  const faqs = [
    { q: t("support.faq.q1"), a: t("support.faq.a1") },
    { q: t("support.faq.q2"), a: t("support.faq.a2") },
    { q: t("support.faq.q3"), a: t("support.faq.a3") },
    { q: t("support.faq.q4"), a: t("support.faq.a4") },
  ];

  return (
    <>
      <Seo
        title={t("seo.support.title")}
        description={t("seo.support.description")}
        path="/support"
      />
      <Helmet>
        <script type="application/ld+json">
          {JSON.stringify({
            "@context": "https://schema.org",
            "@type": "FAQPage",
            mainEntity: faqs.map((item) => ({
              "@type": "Question",
              name: item.q,
              acceptedAnswer: {
                "@type": "Answer",
                text: item.a,
              },
            })),
          })}
        </script>
      </Helmet>
      <div className="container-app py-12 sm:py-16">
        <div className="max-w-prose space-y-4">
          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-brand-primary leading-tight">
            {t("support.title")}
          </h1>
          <p className="text-base sm:text-lg text-brand-text/80 leading-relaxed">
            {t("support.intro")}
          </p>
          <p className="text-sm sm:text-base text-brand-text/85 leading-relaxed rounded-2xl border border-brand-accent/35 bg-brand-accent/10 px-4 py-3">
            {t("support.complianceNotice")}
          </p>
          <p className="text-sm sm:text-base text-brand-text/85 leading-relaxed rounded-2xl border border-brand-line bg-white px-4 py-3">
            {t("support.sensitiveDocsNotice")}
          </p>
        </div>

        <div className="mt-10 grid gap-5 lg:grid-cols-2">
          <Card>
            <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-4">
              {t("support.contactCard.title")}
            </h2>
            <dl className="space-y-4">
              <div>
                <dt className="text-xs uppercase tracking-wider text-brand-muted">
                  {t("support.contactCard.supportLabel")}
                </dt>
                <dd className="mt-1">
                  <a
                    href="mailto:support@hawwelapp.com"
                    className="text-brand-primary font-semibold hover:text-brand-accent transition-colors"
                  >
                    support@hawwelapp.com
                  </a>
                </dd>
              </div>
              <div>
                <dt className="text-xs uppercase tracking-wider text-brand-muted">
                  {t("support.contactCard.privacyLabel")}
                </dt>
                <dd className="mt-1">
                  <a
                    href="mailto:privacy@hawwelapp.com"
                    className="text-brand-primary font-semibold hover:text-brand-accent transition-colors"
                  >
                    privacy@hawwelapp.com
                  </a>
                </dd>
              </div>
              <div>
                <dt className="text-xs uppercase tracking-wider text-brand-muted">
                  {t("support.contactCard.legalLabel")}
                </dt>
                <dd className="mt-1">
                  <a
                    href="mailto:legal@hawwelapp.com"
                    className="text-brand-primary font-semibold hover:text-brand-accent transition-colors break-all"
                  >
                    legal@hawwelapp.com
                  </a>
                </dd>
              </div>
            </dl>
          </Card>

          <Card>
            <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-4">
              {t("support.operator.title")}
            </h2>
            <p className="text-base font-semibold text-brand-primary">
              E-Platform Solutions UAB
            </p>
            <p className="mt-2 text-sm text-brand-text/75">
              {t("common.companyWebsite")}:{" "}
              <a
                href="https://eplatform-solutions.com"
                target="_blank"
                rel="noopener noreferrer"
                className="text-brand-accent hover:underline break-all"
              >
                https://eplatform-solutions.com
              </a>
            </p>
            <p className="mt-4 text-sm text-brand-text/75 leading-relaxed">
              {t("common.operator.short")}
            </p>
          </Card>
        </div>

        <div className="mt-12 sm:mt-16">
          <h2 className="text-2xl sm:text-3xl font-extrabold text-brand-primary">
            {t("support.faq.title")}
          </h2>
          <div className="mt-6 space-y-3">
            {faqs.map((f, i) => (
              <FAQItem
                key={f.q}
                question={f.q}
                answer={f.a}
                defaultOpen={i === 0}
              />
            ))}
          </div>
        </div>
      </div>
    </>
  );
}
