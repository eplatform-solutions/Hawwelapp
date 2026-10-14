import { useLanguage } from "../i18n/LanguageContext";
import LegalPage from "../components/LegalPage";
import type { TranslationKey } from "../i18n/translations";

const LEGAL_BLOCKS: readonly { titleKey: TranslationKey; bodyKey: TranslationKey }[] = [
  { titleKey: "legal.s1.title", bodyKey: "legal.s1.body" },
  { titleKey: "legal.s2.title", bodyKey: "legal.s2.body" },
  { titleKey: "legal.s3.title", bodyKey: "legal.s3.body" },
  { titleKey: "legal.s4.title", bodyKey: "legal.s4.body" },
  { titleKey: "legal.s5.title", bodyKey: "legal.s5.body" },
  { titleKey: "legal.s6.title", bodyKey: "legal.s6.body" },
  { titleKey: "legal.s7.title", bodyKey: "legal.s7.body" },
  { titleKey: "legal.s8.title", bodyKey: "legal.s8.body" },
];

export default function Legal() {
  const { t } = useLanguage();

  return (
    <LegalPage
      seoTitle={t("seo.legal.title")}
      seoDescription={t("seo.legal.description")}
      path="/legal"
      title={t("legal.title")}
    >
      {LEGAL_BLOCKS.map((block) => (
        <div key={block.titleKey}>
          <h2>{t(block.titleKey)}</h2>
          <p>{t(block.bodyKey)}</p>
        </div>
      ))}
    </LegalPage>
  );
}
