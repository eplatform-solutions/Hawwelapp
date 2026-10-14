import { useLanguage } from "../i18n/LanguageContext";
import LegalPage from "../components/LegalPage";
import type { TranslationKey } from "../i18n/translations";

const AML_BLOCKS: readonly { titleKey: TranslationKey; bodyKey: TranslationKey }[] = [
  { titleKey: "aml.s1.title", bodyKey: "aml.s1.body" },
  { titleKey: "aml.s2.title", bodyKey: "aml.s2.body" },
  { titleKey: "aml.s3.title", bodyKey: "aml.s3.body" },
  { titleKey: "aml.s4.title", bodyKey: "aml.s4.body" },
  { titleKey: "aml.s5.title", bodyKey: "aml.s5.body" },
  { titleKey: "aml.s6.title", bodyKey: "aml.s6.body" },
  { titleKey: "aml.s7.title", bodyKey: "aml.s7.body" },
  { titleKey: "aml.s8.title", bodyKey: "aml.s8.body" },
  { titleKey: "aml.s9.title", bodyKey: "aml.s9.body" },
  { titleKey: "aml.s10.title", bodyKey: "aml.s10.body" },
  { titleKey: "aml.s11.title", bodyKey: "aml.s11.body" },
];

export default function AmlKyc() {
  const { t } = useLanguage();

  return (
    <LegalPage
      seoTitle={t("seo.aml.title")}
      seoDescription={t("seo.aml.description")}
      path="/aml-kyc"
      title={t("aml.title")}
      intro={t("aml.intro")}
    >
      <p className="rounded-2xl border border-brand-line bg-brand-bg px-4 py-3 text-sm sm:text-base text-brand-text/85 leading-relaxed">
        {t("aml.disclaimer")}
      </p>

      {AML_BLOCKS.map((block, i) => (
        <div key={block.titleKey}>
          <h2>
            {i + 1}. {t(block.titleKey)}
          </h2>
          <p>{t(block.bodyKey)}</p>
        </div>
      ))}
    </LegalPage>
  );
}
