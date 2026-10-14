import { Helmet } from "react-helmet-async";
import { useLanguage } from "../i18n/LanguageContext";

type Props = {
  title: string;
  description: string;
  path?: string;
  pageType?: "website" | "article";
};

const SITE_URL = "https://hawwelapp.com";
const OPERATOR_URL = "https://eplatform-solutions.com";

export default function Seo({
  title,
  description,
  path,
  pageType = "website",
}: Props) {
  const { lang } = useLanguage();
  const normalizedPath = path ?? "/";
  const url = `${SITE_URL}${normalizedPath}`;

  const breadcrumbSchema = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      {
        "@type": "ListItem",
        position: 1,
        name: lang === "ar" ? "الرئيسية" : "Home",
        item: SITE_URL,
      },
      ...(normalizedPath !== "/"
        ? [
            {
              "@type": "ListItem",
              position: 2,
              name: title,
              item: url,
            },
          ]
        : []),
    ],
  };

  const organizationSchema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: "E-Platform Solutions UAB",
    url: OPERATOR_URL,
    brand: {
      "@type": "Brand",
      name: "Hawwel App",
    },
    sameAs: [SITE_URL, OPERATOR_URL],
    logo: `${SITE_URL}/logo.png`,
  };

  const softwareSchema = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: "Hawwel App",
    /* Neutral category: product is a transfer-request interface, not a bank or exchange. */
    applicationCategory: "BusinessApplication",
    operatingSystem: "iOS, Android",
    url: SITE_URL,
    description:
      lang === "ar"
        ? "Hawwel App — واجهة لإنشاء طلبات تحويل رقمية وتتبّعها. لا يحتفظ بالأموال ولا ينفّذ تحويلات الأموال بشكل مستقل."
        : "Hawwel App helps users create, manage, and track digital transfer requests. It does not hold funds or independently execute money transfers.",
    publisher: {
      "@type": "Organization",
      name: "E-Platform Solutions UAB",
      url: OPERATOR_URL,
    },
    inLanguage: lang,
  };

  return (
    <Helmet>
      <html lang={lang} dir={lang === "ar" ? "rtl" : "ltr"} />
      <title>{title}</title>
      <meta name="description" content={description} />
      <link rel="canonical" href={url} />
      <meta property="og:site_name" content="Hawwel App" />
      <meta property="og:type" content={pageType} />
      <meta property="og:url" content={url} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={`${SITE_URL}/logo.png`} />
      <meta property="og:locale" content={lang === "ar" ? "ar_AR" : "en_US"} />
      <meta name="twitter:card" content="summary" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={`${SITE_URL}/logo.png`} />
      <script type="application/ld+json">
        {JSON.stringify(organizationSchema)}
      </script>
      <script type="application/ld+json">
        {JSON.stringify(softwareSchema)}
      </script>
      <script type="application/ld+json">
        {JSON.stringify(breadcrumbSchema)}
      </script>
    </Helmet>
  );
}
