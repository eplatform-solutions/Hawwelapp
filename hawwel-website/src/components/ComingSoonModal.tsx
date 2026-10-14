import { useEffect } from "react";
import { useLanguage } from "../i18n/LanguageContext";
import Button from "./Button";

type Props = {
  open: boolean;
  onClose: () => void;
};

export default function ComingSoonModal({ open, onClose }: Props) {
  const { t } = useLanguage();

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    document.addEventListener("keydown", onKey);
    document.body.style.overflow = "hidden";
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = "";
    };
  }, [open, onClose]);

  if (!open) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4 sm:p-6"
      role="presentation"
    >
      <button
        type="button"
        aria-label={t("store.modal.close")}
        className="absolute inset-0 bg-brand-primary/55 backdrop-blur-sm animate-fadeIn"
        onClick={onClose}
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-labelledby="coming-soon-title"
        aria-describedby="coming-soon-body"
        className="relative w-full max-w-md rounded-3xl border border-brand-line bg-white p-6 sm:p-8 shadow-2xl animate-slideUp"
      >
        <h2
          id="coming-soon-title"
          className="text-xl sm:text-2xl font-extrabold text-brand-primary"
        >
          {t("store.modal.title")}
        </h2>
        <p
          id="coming-soon-body"
          className="mt-3 text-sm sm:text-base text-brand-text/80 leading-relaxed"
        >
          {t("store.modal.body")}
        </p>
        <div className="mt-6 flex flex-col-reverse sm:flex-row sm:items-center gap-3">
          <Button type="button" variant="outline" autoFocus onClick={onClose}>
            {t("store.modal.close")}
          </Button>
          <Button as="link" to="/contact" onClick={onClose}>
            {t("store.modal.supportCta")}
          </Button>
        </div>
      </div>
    </div>
  );
}
