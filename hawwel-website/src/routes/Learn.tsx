import { Link } from "react-router-dom";
import Seo from "../components/Seo";
import Card from "../components/Card";
import { useLanguage } from "../i18n/LanguageContext";
import { learnArticles } from "../data/learnArticles";
import { normalizeBrandText } from "../utils/brand";

export default function Learn() {
  const { lang, t } = useLanguage();

  return (
    <>
      <Seo
        title={t("seo.learn.title")}
        description={t("seo.learn.description")}
        path="/learn"
      />

      <div className="container-app py-12 sm:py-16">
        <div className="max-w-prose">
          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-brand-primary leading-tight">
            {t("learn.title")}
          </h1>
          <p className="mt-5 text-base sm:text-lg text-brand-text/80 leading-relaxed">
            {t("learn.subtitle")}
          </p>
        </div>

        <div className="mt-10 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {learnArticles.map((article) => (
            <Link key={article.slug} to={`/learn/${article.slug}`} className="group">
              <Card interactive className="h-full">
                <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-0 group-hover:text-brand-accent transition-colors">
                  {normalizeBrandText(article.title[lang])}
                </h2>
                <p className="mt-3 text-sm sm:text-base text-brand-text/80 leading-relaxed">
                  {normalizeBrandText(article.description[lang])}
                </p>
                <p className="mt-5 inline-flex items-center gap-2 text-sm font-semibold text-brand-accent">
                  {t("learn.readMore")}
                  <svg viewBox="0 0 24 24" className="h-4 w-4" aria-hidden="true">
                    <path
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d={lang === "ar" ? "M14 6l-6 6 6 6" : "M10 6l6 6-6 6"}
                    />
                  </svg>
                </p>
              </Card>
            </Link>
          ))}
        </div>
      </div>
    </>
  );
}
