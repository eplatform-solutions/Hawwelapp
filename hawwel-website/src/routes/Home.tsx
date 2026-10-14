import { useLanguage } from "../i18n/LanguageContext";
import Seo from "../components/Seo";
import Section from "../components/Section";
import Card from "../components/Card";
import Button from "../components/Button";
import AppMockup from "../components/AppMockup";
import StoreBadges from "../components/StoreBadges";
import AndroidDirectDownload from "../components/AndroidDirectDownload";

function CheckIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-4 w-4" aria-hidden="true">
      <path
        fill="none"
        stroke="currentColor"
        strokeWidth="2.5"
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M5 12.5l4.5 4.5L19 7.5"
      />
    </svg>
  );
}

function StepNumber({ n }: { n: number }) {
  return (
    <span className="inline-flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-brand-primary text-brand-gold font-bold text-sm">
      {n}
    </span>
  );
}

export default function Home() {
  const { t, tArr } = useLanguage();

  const trustCards = [
    {
      title: t("home.trust.card1.title"),
      text: t("home.trust.card1.text"),
    },
    {
      title: t("home.trust.card2.title"),
      text: t("home.trust.card2.text"),
    },
    {
      title: t("home.trust.card3.title"),
      text: t("home.trust.card3.text"),
    },
    {
      title: t("home.trust.card4.title"),
      text: t("home.trust.card4.text"),
    },
  ];

  const steps = tArr("home.steps.list");
  const whyList = tArr("home.why.list");
  const learnCards = [
    { title: t("learn.card1"), slug: "what-is-digital-transfer-request" },
    { title: t("learn.card2"), slug: "how-to-track-transfer-request" },
    { title: t("learn.card3"), slug: "why-verification-may-be-required" },
    { title: t("learn.card4"), slug: "understanding-available-rates" },
    { title: t("learn.card5"), slug: "transfer-request-app-vs-digital-wallet" },
    { title: t("learn.card6"), slug: "how-supported-regions-work" },
  ];

  return (
    <>
      <Seo
        title={t("seo.home.title")}
        description={t("seo.home.description")}
        path="/"
      />

      {/* Hero */}
      <section className="relative overflow-hidden">
        <div
          aria-hidden="true"
          className="absolute inset-0 -z-10 bg-gradient-to-b from-brand-bg via-brand-bg to-white"
        />
        <div
          aria-hidden="true"
          className="absolute -top-32 start-1/2 -z-10 h-[480px] w-[680px] -translate-x-1/2 rounded-full bg-brand-gold/12 blur-3xl"
        />
        <div className="container-app pt-12 pb-16 sm:pt-16 sm:pb-20 lg:pt-24 lg:pb-28">
          <div className="grid gap-12 lg:grid-cols-12 lg:items-center">
            <div className="lg:col-span-7 animate-fadeUp">
              <p className="inline-flex items-center gap-2 rounded-full border border-brand-line bg-white px-3 py-1 text-xs sm:text-sm font-semibold text-brand-accent">
                <span className="h-1.5 w-1.5 rounded-full bg-brand-accent" />
                {t("home.hero.eyebrow")}
              </p>
              <h1 className="mt-5 text-3xl sm:text-4xl lg:text-5xl xl:text-[3.4rem] font-extrabold leading-[1.1] text-brand-primary">
                {t("home.hero.title")}
              </h1>
              <p className="mt-5 max-w-xl text-base sm:text-lg text-brand-text/80 leading-relaxed">
                {t("home.hero.subtitle")}
              </p>
              <div className="mt-8 flex flex-wrap items-center gap-3">
                <Button as="link" to="/how-it-works" size="lg">
                  {t("home.hero.cta.primary")}
                </Button>
                <Button
                  as="link"
                  to="/#home-how-it-works"
                  variant="outline"
                  size="lg"
                >
                  {t("home.hero.cta.secondary")}
                </Button>
              </div>
              <p className="mt-6 max-w-xl text-xs sm:text-sm text-brand-muted leading-relaxed">
                {t("common.legalNote")}
              </p>
              <div className="mt-8 space-y-4">
                <AndroidDirectDownload />
                <StoreBadges />
              </div>
            </div>

            <div className="lg:col-span-5 flex justify-center lg:justify-end">
              <AppMockup />
            </div>
          </div>
        </div>
      </section>

      {/* Human support */}
      <Section tone="muted" className="!py-12 sm:!py-14">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-6 rounded-3xl border border-brand-line bg-white p-8">
          <div className="max-w-xl">
            <p className="text-xs sm:text-sm font-semibold uppercase tracking-[0.18em] text-brand-accent">
              {t("home.supportStrip.eyebrow")}
            </p>
            <h2 className="mt-3 text-xl sm:text-2xl font-extrabold text-brand-primary">
              {t("home.supportStrip.title")}
            </h2>
            <p className="mt-3 text-sm sm:text-base text-brand-text/80 leading-relaxed">
              {t("home.supportStrip.body")}
            </p>
          </div>
          <Button as="link" to="/support" variant="secondary" size="lg">
            {t("nav.support")}
          </Button>
        </div>
      </Section>

      {/* Trust */}
      <Section
        eyebrow={t("home.trustEyebrow")}
        title={t("home.trust.title")}
        subtitle={t("home.trust.subtitle")}
        tone="default"
      >
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {trustCards.map((card, i) => (
            <Card key={card.title} interactive className="h-full">
              <div className="flex items-center gap-3 mb-3">
                <span className="inline-flex h-9 w-9 items-center justify-center rounded-xl bg-brand-gold/30 text-brand-primary font-bold">
                  {i + 1}
                </span>
              </div>
              <h3 className="text-lg font-bold text-brand-primary">
                {card.title}
              </h3>
              <p className="mt-2 text-sm text-brand-text/75 leading-relaxed">
                {card.text}
              </p>
            </Card>
          ))}
        </div>
      </Section>

      {/* Steps */}
      <Section
        id="home-how-it-works"
        title={t("home.steps.title")}
        subtitle={t("home.steps.subtitle")}
      >
        <ol className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {steps.map((step, i) => (
            <li key={step}>
              <Card className="h-full flex items-start gap-4">
                <StepNumber n={i + 1} />
                <p className="text-sm sm:text-base text-brand-text/85 leading-relaxed pt-1.5">
                  {step}
                </p>
              </Card>
            </li>
          ))}
        </ol>
        <div className="mt-8 flex flex-wrap gap-3">
          <Button as="link" to="/how-it-works" variant="outline" size="md">
            {t("nav.howItWorks")}
          </Button>
          <Button as="link" to="/available-regions" variant="ghost" size="md">
            {t("nav.regions")}
          </Button>
        </div>
      </Section>

      {/* Why */}
      <Section title={t("home.why.title")} tone="muted">
        <ul className="grid gap-3 sm:grid-cols-2">
          {whyList.map((item) => (
            <li
              key={item}
              className="flex items-start gap-3 rounded-2xl border border-brand-line bg-white p-4 sm:p-5"
            >
              <span className="inline-flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-brand-accent text-white">
                <CheckIcon />
              </span>
              <span className="text-sm sm:text-base text-brand-text/85">
                {item}
              </span>
            </li>
          ))}
        </ul>
      </Section>

      {/* Regions teaser */}
      <Section title={t("home.regionsTeaser.title")} subtitle={t("home.regionsTeaser.body")}>
        <Card className="max-w-3xl flex flex-col sm:flex-row sm:items-center gap-6">
          <p className="text-sm text-brand-text/80 leading-relaxed flex-1">
            {t("regions.intro")}
          </p>
          <Button as="link" to="/available-regions" size="lg">
            {t("regions.title")}
          </Button>
        </Card>
      </Section>

      {/* Learn */}
      <Section tone="muted" title={t("learn.title")} subtitle={t("learn.subtitle")}>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {learnCards.map((card) => (
            <Card key={card.slug} interactive className="h-full">
              <h3 className="text-lg font-bold text-brand-primary">{card.title}</h3>
              <div className="mt-4">
                <Button as="link" to={`/learn/${card.slug}`} variant="outline" size="md">
                  {t("learn.readMore")}
                </Button>
              </div>
            </Card>
          ))}
        </div>
      </Section>
    </>
  );
}
