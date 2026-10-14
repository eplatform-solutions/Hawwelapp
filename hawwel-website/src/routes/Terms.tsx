import { useLanguage } from "../i18n/LanguageContext";
import LegalPage from "../components/LegalPage";
import type { TranslationKey } from "../i18n/translations";

const TERM_BLOCKS: readonly { titleKey: TranslationKey; bodyKey: TranslationKey }[] = [
  { titleKey: "terms.s1.title", bodyKey: "terms.s1.body" },
  { titleKey: "terms.s2.title", bodyKey: "terms.s2.body" },
  { titleKey: "terms.s3.title", bodyKey: "terms.s3.body" },
  { titleKey: "terms.s4.title", bodyKey: "terms.s4.body" },
  { titleKey: "terms.s5.title", bodyKey: "terms.s5.body" },
  { titleKey: "terms.s6.title", bodyKey: "terms.s6.body" },
  { titleKey: "terms.s7.title", bodyKey: "terms.s7.body" },
  { titleKey: "terms.s8.title", bodyKey: "terms.s8.body" },
  { titleKey: "terms.s9.title", bodyKey: "terms.s9.body" },
  { titleKey: "terms.s10.title", bodyKey: "terms.s10.body" },
  { titleKey: "terms.s11.title", bodyKey: "terms.s11.body" },
  { titleKey: "terms.s12.title", bodyKey: "terms.s12.body" },
  { titleKey: "terms.s13.title", bodyKey: "terms.s13.body" },
  { titleKey: "terms.s14.title", bodyKey: "terms.s14.body" },
  { titleKey: "terms.s15.title", bodyKey: "terms.s15.body" },
  { titleKey: "terms.s16.title", bodyKey: "terms.s16.body" },
  { titleKey: "terms.s17.title", bodyKey: "terms.s17.body" },
];

export default function Terms() {
  const { t } = useLanguage();

  return (
    <LegalPage
      seoTitle={t("seo.terms.title")}
      seoDescription={t("seo.terms.description")}
      path="/terms"
      title={t("terms.title")}
      intro={t("terms.intro")}
    >
      {TERM_BLOCKS.map((block) => (
        <div key={block.titleKey}>
          <h2>{t(block.titleKey)}</h2>
          <p>{t(block.bodyKey)}</p>
        </div>
      ))}
    </LegalPage>
  );
}
