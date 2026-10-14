import { useLanguage } from "../i18n/LanguageContext";
import Seo from "../components/Seo";
import Card from "../components/Card";

type Region = {
  name: string;
  status: string;
  statusTone: "available" | "planned";
  icon: string;
};

export default function AvailableRegions() {
  const { t } = useLanguage();

  const regions: Region[] = [
    {
      name: t("regions.card1"),
      status: t("regions.cardStatus.available"),
      statusTone: "available",
      icon: "R1",
    },
    {
      name: t("regions.card2"),
      status: t("regions.cardStatus.available"),
      statusTone: "available",
      icon: "R2",
    },
    {
      name: t("regions.card3"),
      status: t("regions.cardStatus.planned"),
      statusTone: "planned",
      icon: "+",
    },
  ];

  return (
    <>
      <Seo
        title={t("seo.regions.title")}
        description={t("seo.regions.description")}
        path="/available-regions"
      />
      <div className="container-app py-12 sm:py-16">
        <div className="max-w-prose">
          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-brand-primary leading-tight">
            {t("regions.title")}
          </h1>
          <p className="mt-5 text-base sm:text-lg text-brand-text/80 leading-relaxed">
            {t("regions.intro")}
          </p>
        </div>

        <div className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {regions.map((r) => (
            <Card key={r.name} interactive>
              <div className="flex items-start justify-between gap-3">
                <div className="flex items-center gap-3">
                  <span className="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-brand-primary text-brand-gold font-bold text-lg">
                    {r.icon}
                  </span>
                  <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-0">
                    {r.name}
                  </h2>
                </div>
                <span
                  className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-[11px] font-semibold ${
                    r.statusTone === "available"
                      ? "bg-brand-accent/15 text-brand-accent"
                      : "bg-brand-gold/30 text-brand-primary"
                  }`}
                >
                  <span
                    className={`h-1.5 w-1.5 rounded-full ${
                      r.statusTone === "available"
                        ? "bg-brand-accent"
                        : "bg-brand-primary"
                    }`}
                  />
                  {r.status}
                </span>
              </div>
            </Card>
          ))}
        </div>

        <div className="mt-10 rounded-2xl border border-brand-gold/40 bg-brand-gold/15 p-5 sm:p-6">
          <p className="text-sm sm:text-base text-brand-primary/90 leading-relaxed">
            <strong className="font-bold">⚠ </strong>
            {t("regions.note")}
          </p>
        </div>
      </div>
    </>
  );
}
