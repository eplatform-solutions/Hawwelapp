import { useLanguage } from "../i18n/LanguageContext";

export default function AppMockup() {
  const { lang } = useLanguage();

  const fontClass = lang === "ar" ? "font-arabic" : "";
  const labels =
    lang === "ar"
      ? {
          sendTo: "الإرسال إلى",
          region: "المنطقة المدعومة",
          area: "المنطقة المختارة",
          method: "طريقة التحويل",
          conversion: "طرق التحويل",
          receiverGets: "يستلم",
          youSend: "أنت ترسل",
        }
      : {
          sendTo: "Send to",
          region: "Supported region",
          area: "Selected area",
          method: "Transfer method",
          conversion: "Conversion methods",
          receiverGets: "Receiver gets",
          youSend: "You send",
        };

  return (
    <div className="relative">
      <div
        aria-hidden="true"
        className="absolute -inset-6 rounded-[3rem] bg-gradient-to-tr from-brand-gold/30 via-transparent to-brand-accent/20 blur-2xl"
      />

      <div className="relative mx-auto w-[290px] sm:w-[320px] rounded-[2.5rem] bg-brand-primary p-3 shadow-2xl ring-1 ring-white/10">
        <div className="overflow-hidden rounded-[2rem] bg-[#f2f4f6]">
          <div className="flex items-center justify-between px-5 pt-3 pb-2 text-[10px] text-brand-text/60">
            <span>9:41</span>
            <span className="inline-flex items-center gap-1">
              <span className="inline-block h-1.5 w-1.5 rounded-full bg-brand-text/60" />
              <span className="inline-block h-1.5 w-1.5 rounded-full bg-brand-text/60" />
              <span className="inline-block h-1.5 w-3 rounded-sm border border-brand-text/40" />
            </span>
          </div>

          <div className="px-4 pb-4 pt-1.5">
            <div className="mb-3 flex items-center gap-2 rounded-xl bg-white/95 px-3 py-2 shadow-sm">
              <img
                src="/logo.png"
                alt={lang === "ar" ? "شعار Hawwel App" : "Hawwel App logo"}
                className="h-8 w-8 rounded-lg object-cover"
                loading="eager"
              />
              <div className="leading-tight">
                <p className="text-sm font-bold text-brand-primary">Hawwel App</p>
                <p className={`text-[10px] text-brand-text/60 ${fontClass}`}>حوِّل</p>
              </div>
            </div>

            <h3 className={`mb-2 text-base font-bold text-brand-primary ${fontClass}`}>
              {labels.sendTo}
            </h3>
            <div className="rounded-2xl bg-white p-3 shadow-sm">
              <MockupRow
                icon="◎"
                title={labels.region}
                value={lang === "ar" ? "منطقة استلام" : "Local payout area"}
              />
              <MockupRow
                icon="▦"
                title={labels.area}
                value={lang === "ar" ? "منطقة محلية" : "Local area"}
              />
              <MockupRow
                icon="◉"
                title={labels.method}
                value={lang === "ar" ? "تحويل رقمي" : "Digital transfer"}
                withDivider={false}
              />
            </div>

            <h3 className={`mb-2 mt-4 text-base font-bold text-brand-primary ${fontClass}`}>
              {labels.conversion}
            </h3>
            <div className="rounded-2xl border border-brand-line/70 bg-white p-3 shadow-sm">
              <div dir="ltr" className="grid grid-cols-[1fr_auto_1fr] items-stretch gap-2.5">
                <div
                  className={`flex min-h-[90px] flex-col justify-between rounded-2xl border border-brand-gold/60 bg-brand-gold/10 p-3 ${
                    lang === "ar" ? "text-right" : "text-left"
                  }`}
                >
                  <p className={`text-[10px] font-medium text-brand-text/70 ${fontClass}`}>
                    {labels.receiverGets}
                  </p>
                  <div className="mt-1">
                    <p className="text-[1.7rem] font-extrabold leading-none tracking-tight text-brand-primary tabular-nums">
                      14000
                    </p>
                    <span className="mt-1 inline-flex rounded-full bg-brand-accent px-2 py-0.5 text-[10px] font-semibold text-white">
                      SYP
                    </span>
                  </div>
                </div>

                <span className="inline-flex h-full items-center">
                  <span className="inline-flex h-9 w-9 items-center justify-center rounded-full bg-brand-accent text-white shadow-md ring-2 ring-brand-accent/20">
                    <svg viewBox="0 0 24 24" className="h-4 w-4" aria-hidden="true">
                      <path
                        d="M6 8h12M14.5 5.5 18 8l-3.5 2.5M18 16H6M9.5 13.5 6 16l3.5 2.5"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />
                    </svg>
                  </span>
                </span>

                <div
                  className={`flex min-h-[90px] flex-col justify-between rounded-2xl border border-brand-line bg-white p-3 ${
                    lang === "ar" ? "text-right" : "text-left"
                  }`}
                >
                  <p className={`text-[10px] font-medium text-brand-text/70 ${fontClass}`}>
                    {labels.youSend}
                  </p>
                  <div className="mt-1">
                    <p className="text-[1.7rem] font-extrabold leading-none tracking-tight text-brand-primary tabular-nums">
                      1.00
                    </p>
                    <span className="mt-1 inline-flex text-xs font-semibold text-brand-text/60">
                      USDT
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-4 rounded-2xl bg-gradient-to-r from-brand-primary to-brand-accent p-2">
              <div className="grid grid-cols-4 gap-2 text-center text-white/80">
                {["⌂", "👥", "☑", "▣"].map((item, idx) => (
                  <span
                    key={item}
                    className={`rounded-xl py-2 text-sm ${idx === 0 ? "bg-white/15 text-brand-gold" : ""}`}
                  >
                    {item}
                  </span>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function MockupRow({
  icon,
  title,
  value,
  withDivider = true,
}: {
  icon: string;
  title: string;
  value: string;
  withDivider?: boolean;
}) {
  return (
    <div className={`flex items-center gap-3 py-2.5 ${withDivider ? "border-b border-brand-line/70" : ""}`}>
      <span className="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-bg text-sm text-brand-primary">
        {icon}
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-[10px] text-brand-text/60">{title}</p>
        <p className="truncate text-sm font-semibold text-brand-primary">{value}</p>
      </div>
      <span className="text-brand-text/45">›</span>
    </div>
  );
}
