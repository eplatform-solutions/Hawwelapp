import { useLanguage } from "../i18n/LanguageContext";
import Seo from "../components/Seo";
import Button from "../components/Button";

export default function NotFound() {
  const { t } = useLanguage();
  return (
    <>
      <Seo
        title={t("seo.notFound.title")}
        description={t("seo.notFound.description")}
      />
      <div className="container-app py-24 sm:py-32 text-center">
        <p className="text-8xl sm:text-9xl font-extrabold text-brand-primary/15 leading-none">
          404
        </p>
        <h1 className="mt-2 text-3xl sm:text-4xl font-extrabold text-brand-primary">
          {t("notFound.title")}
        </h1>
        <p className="mt-3 text-base sm:text-lg text-brand-text/75 max-w-md mx-auto">
          {t("notFound.body")}
        </p>
        <div className="mt-8 flex justify-center">
          <Button as="link" to="/" size="lg">
            {t("notFound.cta")}
          </Button>
        </div>
      </div>
    </>
  );
}
