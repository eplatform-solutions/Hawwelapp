import { useLanguage } from "../i18n/LanguageContext";
import { Link } from "react-router-dom";
import LegalPage from "../components/LegalPage";

export default function Privacy() {
  const { t, tArr } = useLanguage();

  return (
    <LegalPage
      seoTitle={t("seo.privacy.title")}
      seoDescription={t("seo.privacy.description")}
      path="/privacy"
      title={t("privacy.title")}
      intro={t("privacy.intro")}
      lastUpdated={{
        label: t("privacy.lastUpdatedLabel"),
        value: t("privacy.lastUpdatedValue"),
      }}
    >
      <h2>{t("privacy.s1.title")}</h2>
      <p>{t("privacy.s1.body")}</p>

      <h2>{t("privacy.s2.title")}</h2>
      <p>{t("privacy.s2.body")}</p>

      <h2>{t("privacy.s3.title")}</h2>
      <p>{t("privacy.s3.body")}</p>

      <h2>{t("privacy.s4.title")}</h2>
      <p>{t("privacy.s4.body")}</p>

      <h2>{t("privacy.s5.title")}</h2>
      <ul>
        {tArr("privacy.s5.list").map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>

      <h2>{t("privacy.s6.title")}</h2>
      <ul>
        {tArr("privacy.s6.list").map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>

      <h2>{t("privacy.s7.title")}</h2>
      <p>{t("privacy.s7.body")}</p>

      <h2>{t("privacy.s8.title")}</h2>
      <p>{t("privacy.s8.body")}</p>

      <h2>{t("privacy.s9.title")}</h2>
      <p>{t("privacy.s9.body")}</p>

      <h2>{t("privacy.s10.title")}</h2>
      <p>{t("privacy.s10.body")}</p>

      <h2>{t("privacy.s11.title")}</h2>
      <p>{t("privacy.s11.lead")}</p>
      <ul>
        {tArr("privacy.s11.list").map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>
      <p className="mt-4">{t("privacy.s11.noSell")}</p>
      <p>{t("privacy.s11.noAds")}</p>

      <h2>{t("privacy.s12.title")}</h2>
      <p>{t("privacy.s12.body")}</p>

      <h2>{t("privacy.s13.title")}</h2>
      <p>{t("privacy.s13.body")}</p>

      <h2>{t("privacy.s14.title")}</h2>
      <p>{t("privacy.s14.body")}</p>

      <h2>{t("privacy.s15.title")}</h2>
      <p>{t("privacy.s15.body")}</p>

      <h2>{t("privacy.s16.title")}</h2>
      <p>{t("privacy.s16.lead")}</p>
      <p className="mt-2">
        <Link to="/delete-account" className="text-brand-accent font-semibold hover:underline">
          {t("privacy.s16.link")}
        </Link>
      </p>

      <h2>{t("privacy.s17.title")}</h2>
      <p>{t("privacy.s17.body")}</p>

      <h2>{t("privacy.s18.title")}</h2>
      <p>{t("privacy.s18.body")}</p>

      <h2>{t("privacy.s19.title")}</h2>
      <p>
        <span>{t("privacy.s19.lead")} </span>
        <a
          href="mailto:privacy@hawwelapp.com"
          className="text-brand-accent hover:underline"
        >
          privacy@hawwelapp.com
        </a>
      </p>
    </LegalPage>
  );
}
