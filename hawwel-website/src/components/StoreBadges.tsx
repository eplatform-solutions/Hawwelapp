import { useState } from "react";
import { useLanguage } from "../i18n/LanguageContext";
import type { ReactNode } from "react";
import ComingSoonModal from "./ComingSoonModal";

type Props = {
  className?: string;
  variant?: "default" | "compact";
};

function AppleIcon({ className = "" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="currentColor"
      className={className}
      aria-hidden="true"
    >
      <path d="M16.365 1.43c0 1.14-.412 2.226-1.236 3.04-.83.81-2.077 1.42-3.108 1.337-.135-1.094.408-2.225 1.18-3.005.86-.86 2.282-1.493 3.164-1.372ZM20.59 17.49c-.564 1.293-.835 1.872-1.563 3.014-1.013 1.6-2.444 3.59-4.214 3.605-1.575.013-1.98-1.027-4.122-1.014-2.142.012-2.589 1.034-4.166 1.022-1.77-.014-3.124-1.81-4.137-3.41-2.834-4.473-3.13-9.72-1.382-12.515 1.241-1.984 3.198-3.143 5.039-3.143 1.872 0 3.05 1.027 4.59 1.027 1.498 0 2.41-1.029 4.578-1.029 1.638 0 3.376.892 4.611 2.435-4.057 2.222-3.398 8.014.766 10.008Z" />
    </svg>
  );
}

function PlayIcon({ className = "" }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true">
      <path
        fill="currentColor"
        d="M3.6 2.5c-.36.31-.6.78-.6 1.36v16.28c0 .58.24 1.05.6 1.36l8.83-9.5L3.6 2.5Z"
      />
      <path
        fill="currentColor"
        opacity=".75"
        d="m12.43 12 2.94-3.16-9.6-5.49c-.6-.34-1.13-.32-1.5-.05L12.43 12Z"
      />
      <path
        fill="currentColor"
        opacity=".55"
        d="m12.43 12-8.16 8.7c.37.27.9.29 1.5-.05l9.6-5.49L12.43 12Z"
      />
      <path
        fill="currentColor"
        opacity=".9"
        d="m20.41 10.93-2.93-1.68-3.05 2.75 3.05 2.75 2.94-1.68c.92-.53.92-1.61-.01-2.14Z"
      />
    </svg>
  );
}

export default function StoreBadges({ className = "", variant = "default" }: Props) {
  const { t } = useLanguage();
  const [modalOpen, setModalOpen] = useState(false);

  const Badge = ({ label, icon }: { label: string; icon: ReactNode }) => (
    <button
      type="button"
      onClick={() => setModalOpen(true)}
      className={`inline-flex min-h-11 items-center gap-3 rounded-2xl border border-brand-primary/15 bg-brand-primary text-white/95 transition-all duration-200 hover:border-brand-gold/40 hover:shadow-card focus-visible:ring-2 focus-visible:ring-brand-gold/50 ${
        variant === "compact" ? "px-4 py-2.5 w-full sm:w-auto" : "px-5 py-3"
      }`}
      aria-haspopup="dialog"
    >
      <span className="text-brand-gold shrink-0">{icon}</span>
      <span className="flex flex-col leading-tight text-start">
        <span className="text-sm font-semibold">
          {label} {"—"} {t("store.comingSoon")}
        </span>
        <span className="text-[11px] text-brand-gold/90 mt-0.5">
          {t("store.noLink")}
        </span>
      </span>
    </button>
  );

  return (
    <>
      <div className={`space-y-4 ${className}`}>
        <div className="flex flex-col sm:flex-row flex-wrap items-stretch sm:items-center gap-3">
          <Badge
            label={t("store.appStore.title")}
            icon={<AppleIcon className="h-7 w-7" />}
          />
          <Badge
            label={t("store.googlePlay.title")}
            icon={<PlayIcon className="h-7 w-7" />}
          />
        </div>
        <p className="max-w-xl text-xs sm:text-sm text-brand-muted leading-relaxed">
          {t("store.comingSoonBanner")}
        </p>
      </div>
      <ComingSoonModal open={modalOpen} onClose={() => setModalOpen(false)} />
    </>
  );
}
