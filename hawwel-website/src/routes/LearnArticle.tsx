import { Navigate, Link, useParams } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import Seo from "../components/Seo";
import { useLanguage } from "../i18n/LanguageContext";
import { learnArticleMap } from "../data/learnArticles";
import { normalizeBrandText } from "../utils/brand";

const SITE_URL = "https://hawwelapp.com";

export default function LearnArticle() {
  const { slug } = useParams();
  const { lang, t } = useLanguage();

  if (!slug) return <Navigate to="/learn" replace />;

  const article = learnArticleMap.get(slug);
  if (!article) return <Navigate to="/learn" replace />;

  const title = normalizeBrandText(article.title[lang]);
  const description = normalizeBrandText(article.description[lang]);
  const keywords = article.keywords[lang].map((keyword) => normalizeBrandText(keyword)).join(", ");
  const articleUrl = `${SITE_URL}/learn/${article.slug}`;

  const articleSchema = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: title,
    description,
    inLanguage: lang,
    mainEntityOfPage: articleUrl,
    publisher: {
      "@type": "Organization",
      name: "E-Platform Solutions UAB",
      url: "https://eplatform-solutions.com",
    },
    image: `${SITE_URL}/logo.png`,
    keywords,
  };

  return (
    <>
      <Seo
        title={`${title} | Hawwel`}
        description={description}
        path={`/learn/${article.slug}`}
        pageType="article"
      />
      <Helmet>
        <meta name="keywords" content={keywords} />
        <script type="application/ld+json">
          {JSON.stringify(articleSchema)}
        </script>
      </Helmet>

      <div className="container-app py-12 sm:py-16">
        <div className="mx-auto max-w-prose">
          <Link
            to="/learn"
            className="inline-flex items-center gap-2 text-sm font-semibold text-brand-accent hover:underline"
          >
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
            {t("learn.backToLearn")}
          </Link>

          <h1 className="mt-4 text-3xl sm:text-4xl lg:text-5xl font-extrabold text-brand-primary leading-tight">
            {title}
          </h1>
          <p className="mt-5 text-base sm:text-lg text-brand-text/80 leading-relaxed">
            {description}
          </p>

          <div className="mt-5 flex flex-wrap gap-2">
            {article.keywords[lang].map((keyword) => (
              <span
                key={keyword}
                className="inline-flex rounded-full bg-brand-gold/20 px-3 py-1 text-xs font-semibold text-brand-primary"
              >
                {normalizeBrandText(keyword)}
              </span>
            ))}
          </div>

          <article className="legal-section mt-10">
            {article.sections.map((section, sectionIndex) => (
              <section key={`${section.heading[lang]}-${sectionIndex}`}>
                <h2>{normalizeBrandText(section.heading[lang])}</h2>
                {section.paragraphs[lang].map((paragraph, paragraphIndex) => (
                  <p key={`${sectionIndex}-${paragraphIndex}`}>{normalizeBrandText(paragraph)}</p>
                ))}
              </section>
            ))}
          </article>

          <div className="mt-10 rounded-2xl border border-brand-gold/40 bg-brand-gold/15 p-5 sm:p-6">
            <p className="text-sm sm:text-base text-brand-primary/90 leading-relaxed">
              {normalizeBrandText(article.legalNote[lang])}
            </p>
          </div>
        </div>
      </div>
    </>
  );
}
