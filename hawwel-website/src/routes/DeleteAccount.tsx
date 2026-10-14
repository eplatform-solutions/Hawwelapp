import { useLanguage } from "../i18n/LanguageContext";
import LegalPage from "../components/LegalPage";

export default function DeleteAccount() {
  const { t, tArr } = useLanguage();

  return (
    <LegalPage
      seoTitle={t("seo.deleteAccount.title")}
      seoDescription={t("seo.deleteAccount.description")}
      path="/delete-account"
      title={t("deleteAccount.title")}
      intro={t("deleteAccount.intro")}
    >
      <h2>{t("deleteAccount.s1.title")}</h2>
      <p>{t("deleteAccount.s1.body")}</p>

      <h2>{t("deleteAccount.s2.title")}</h2>
      <p>
        {t("deleteAccount.s2.lead")}{" "}
        <a
          href="mailto:privacy@hawwelapp.com"
          className="text-brand-accent hover:underline"
        >
          privacy@hawwelapp.com
        </a>
        .
      </p>

      <h2>{t("deleteAccount.s3.title")}</h2>
      <ul>
        {tArr("deleteAccount.s3.list").map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>

      <h2>{t("deleteAccount.s4.title")}</h2>
      <ul>
        {tArr("deleteAccount.s4.list").map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>

      <h2>{t("deleteAccount.s5.title")}</h2>
      <ul>
        {tArr("deleteAccount.s5.list").map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>

      <h2>{t("deleteAccount.s6.title")}</h2>
      <p>{t("deleteAccount.s6.body")}</p>

      <h2>{t("deleteAccount.s7.title")}</h2>
      <p>{t("deleteAccount.s7.body")}</p>

      <h2>{t("deleteAccount.s8.title")}</h2>
      <p>
        {t("deleteAccount.s8.lead")}{" "}
        <a
          href="mailto:privacy@hawwelapp.com"
          className="text-brand-accent hover:underline"
        >
          privacy@hawwelapp.com
        </a>
        .
      </p>
    </LegalPage>
  );
}
