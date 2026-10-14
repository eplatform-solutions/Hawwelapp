import { useState, type FormEvent } from "react";
import { useLanguage } from "../i18n/LanguageContext";
import Seo from "../components/Seo";
import Card from "../components/Card";
import Button from "../components/Button";

const contactRows: { labelKey: string; email: string }[] = [
  { labelKey: "contact.supportLabel", email: "support@hawwelapp.com" },
  { labelKey: "contact.privacyLabel", email: "privacy@hawwelapp.com" },
  { labelKey: "contact.legalLabel", email: "legal@hawwelapp.com" },
];

export default function Contact() {
  const { t } = useLanguage();
  const [showNote, setShowNote] = useState(false);

  function onSubmit(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setShowNote(true);
  }

  return (
    <>
      <Seo
        title={t("seo.contact.title")}
        description={t("seo.contact.description")}
        path="/contact"
      />
      <div className="container-app py-12 sm:py-16">
        <div className="max-w-prose space-y-4">
          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-brand-primary leading-tight">
            {t("contact.title")}
          </h1>
          <p className="text-base sm:text-lg text-brand-accent font-semibold">
            {t("contact.brandLead")}
          </p>
          <p className="text-base sm:text-lg text-brand-text/80 leading-relaxed">
            {t("contact.intro")}
          </p>
          <p className="text-sm sm:text-base text-brand-text/85 leading-relaxed rounded-2xl border border-brand-accent/35 bg-brand-accent/10 px-4 py-3">
            {t("contact.complianceNotice")}
          </p>
        </div>

        <div className="mt-10 grid gap-8 lg:grid-cols-12">
          <div className="lg:col-span-5 space-y-5">
            <Card>
              <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-4">
                {t("support.contactCard.title")}
              </h2>
              <dl className="space-y-4">
                {contactRows.map((row) => (
                  <div key={row.email}>
                    <dt className="text-xs uppercase tracking-wider text-brand-muted">
                      {t(row.labelKey as never)}
                    </dt>
                    <dd className="mt-1">
                      <a
                        href={`mailto:${row.email}`}
                        className="text-brand-primary font-semibold hover:text-brand-accent transition-colors break-all"
                      >
                        {row.email}
                      </a>
                    </dd>
                  </div>
                ))}
              </dl>
            </Card>

            <Card>
              <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-4">
                {t("contact.operatorLabel")}
              </h2>
              <p className="text-base font-semibold text-brand-primary">
                E-Platform Solutions UAB
              </p>
              <p className="mt-2 text-sm text-brand-text/75 break-all">
                <a
                  href="https://eplatform-solutions.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-brand-accent hover:underline"
                >
                  https://eplatform-solutions.com
                </a>
              </p>
            </Card>
          </div>

          <div className="lg:col-span-7">
            <Card>
              <h2 className="text-lg sm:text-xl font-bold text-brand-primary !mt-0 !mb-4">
                {t("contact.form.title")}
              </h2>

              <form className="space-y-4" onSubmit={onSubmit}>
                <Field
                  id="name"
                  label={t("contact.form.name")}
                  placeholder={t("contact.form.namePh")}
                  required
                />
                <Field
                  id="email"
                  label={t("contact.form.email")}
                  type="email"
                  placeholder={t("contact.form.emailPh")}
                  required
                />
                <Field
                  id="subject"
                  label={t("contact.form.subject")}
                  placeholder={t("contact.form.subjectPh")}
                />
                <div>
                  <label
                    htmlFor="message"
                    className="block text-sm font-semibold text-brand-primary mb-1.5"
                  >
                    {t("contact.form.message")}
                  </label>
                  <textarea
                    id="message"
                    name="message"
                    rows={5}
                    required
                    placeholder={t("contact.form.messagePh")}
                    className="w-full rounded-xl border border-brand-line bg-white px-4 py-3 text-sm sm:text-base text-brand-text placeholder:text-brand-muted focus:border-brand-primary focus:outline-none"
                  />
                </div>

                <div className="flex flex-col sm:flex-row sm:items-center gap-3 sm:justify-between pt-2">
                  <Button type="submit">
                    {t("contact.form.button")}
                  </Button>
                </div>

                <div
                  role="status"
                  aria-live="polite"
                  className={`text-xs sm:text-sm rounded-xl border p-3 leading-relaxed ${
                    showNote
                      ? "border-brand-accent/40 bg-brand-accent/8 text-brand-primary"
                      : "border-brand-gold/40 bg-brand-gold/15 text-brand-primary"
                  }`}
                >
                  {t("contact.form.note")}
                </div>
              </form>
            </Card>
          </div>
        </div>
      </div>
    </>
  );
}

function Field({
  id,
  label,
  placeholder,
  type = "text",
  required = false,
}: {
  id: string;
  label: string;
  placeholder?: string;
  type?: string;
  required?: boolean;
}) {
  return (
    <div>
      <label
        htmlFor={id}
        className="block text-sm font-semibold text-brand-primary mb-1.5"
      >
        {label}
      </label>
      <input
        id={id}
        name={id}
        type={type}
        placeholder={placeholder}
        required={required}
        className="w-full rounded-xl border border-brand-line bg-white px-4 py-3 text-sm sm:text-base text-brand-text placeholder:text-brand-muted focus:border-brand-primary focus:outline-none"
      />
    </div>
  );
}
