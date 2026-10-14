import { useLanguage } from "../i18n/LanguageContext";
import Button from "./Button";

type Props = {
  className?: string;
};

function DownloadIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-5 w-5" aria-hidden="true">
      <path
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M12 3v12m0 0-4.5-4.5M12 15l4.5-4.5M4 20h16"
      />
    </svg>
  );
}

// Direct-to-device APK download, distinct from the official-store badges
// (which stay in their "coming soon" state until the app is actually
// published on Google Play / the App Store) so this never gets mistaken
// for an official store install.
export default function AndroidDirectDownload({ className = "" }: Props) {
  const { t } = useLanguage();

  return (
    <div className={`space-y-2 ${className}`}>
      <Button
        as="a"
        href="https://api.7awalaty.com/downloads/hawwel-1.1.1.apk"
        variant="secondary"
        size="lg"
      >
        <DownloadIcon />
        {t("store.androidDirect.title")}
      </Button>
      <p className="max-w-xl text-xs sm:text-sm text-brand-muted leading-relaxed">
        {t("store.androidDirect.note")}
      </p>
    </div>
  );
}
