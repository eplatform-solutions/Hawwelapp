import { useLanguage } from "../i18n/LanguageContext";
import Seo from "../components/Seo";
import Card from "../components/Card";
import Button from "../components/Button";

export default function HowItWorks() {
  const { t } = useLanguage();

  const steps = [
    { title: t("hiw.step1.title"), text: t("hiw.step1.text") },
    { title: t("hiw.step2.title"), text: t("hiw.step2.text") },
    { title: t("hiw.step3.title"), text: t("hiw.step3.text") },
    { title: t("hiw.step4.title"), text: t("hiw.step4.text") },
    { title: t("hiw.step5.title"), text: t("hiw.step5.text") },
    { title: t("hiw.step6.title"), text: t("hiw.step6.text") },
  ];

  return (
    <>
      <Seo
        title={t("seo.hiw.title")}
        description={t("seo.hiw.description")}
        path="/how-it-works"
      />
      <div className="container-app py-12 sm:py-16">
        <div className="max-w-prose">
          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-brand-primary leading-tight">
            {t("hiw.title")}
          </h1>
          <p className="mt-5 text-base sm:text-lg text-brand-text/80 leading-relaxed">
            {t("hiw.intro")}
          </p>
        </div>

        <ol className="mt-10 sm:mt-12 grid gap-5 sm:grid-cols-2">
          {steps.map((step, i) => (
            <li key={step.title}>
              <Card interactive className="h-full">
                <div className="flex items-center gap-3">
                  <span className="inline-flex h-10 w-10 items-center justify-center rounded-xl bg-brand-primary text-brand-gold font-extrabold">
                    {String(i + 1).padStart(2, "0")}
                  </span>
                  <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-0">
                    {step.title}
                  </h2>
                </div>
                <p className="mt-4 text-sm sm:text-base text-brand-text/80 leading-relaxed">
                  {step.text}
                </p>
              </Card>
            </li>
          ))}
        </ol>

        <div className="mt-12 sm:mt-16 rounded-3xl border border-brand-line bg-brand-bg p-7 sm:p-10">
          <p className="text-sm font-semibold text-brand-primary">
            {t("common.operator.short")}
          </p>
          <p className="mt-4 max-w-3xl text-sm sm:text-base text-brand-text/80 leading-relaxed">
            {t("hiw.footerHint")}
          </p>
          <div className="mt-6 flex flex-wrap gap-3">
            <Button as="link" to="/support" variant="secondary">
              {t("nav.support")}
            </Button>
            <Button as="link" to="/legal" variant="outline">
              {t("nav.legal")}
            </Button>
          </div>
        </div>
      </div>
    </>
  );
}
