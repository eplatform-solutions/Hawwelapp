import type { ReactNode } from "react";
import Seo from "./Seo";

type Props = {
  seoTitle: string;
  seoDescription: string;
  path: string;
  title: string;
  intro?: ReactNode;
  lastUpdated?: { label: string; value: string };
  children: ReactNode;
};

export default function LegalPage({
  seoTitle,
  seoDescription,
  path,
  title,
  intro,
  lastUpdated,
  children,
}: Props) {
  return (
    <>
      <Seo title={seoTitle} description={seoDescription} path={path} />
      <div className="container-app py-12 sm:py-16">
        <div className="mx-auto max-w-prose">
          <h1 className="text-3xl sm:text-4xl font-extrabold text-brand-primary leading-tight">
            {title}
          </h1>
          {intro && (
            <p className="mt-5 text-base sm:text-lg text-brand-text/80 leading-relaxed">
              {intro}
            </p>
          )}
          {lastUpdated && (
            <p className="mt-4 inline-flex items-center gap-2 rounded-full bg-brand-gold/25 px-3 py-1 text-xs text-brand-primary font-semibold">
              <span>{lastUpdated.label}</span>
              <span>{lastUpdated.value}</span>
            </p>
          )}
          <div className="legal-section mt-8">{children}</div>
        </div>
      </div>
    </>
  );
}
