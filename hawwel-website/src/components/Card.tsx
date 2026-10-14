import type { ReactNode } from "react";

type Props = {
  children: ReactNode;
  className?: string;
  as?: "article" | "div" | "section" | "li";
  interactive?: boolean;
};

export default function Card({
  children,
  className = "",
  as = "article",
  interactive = false,
}: Props) {
  const Tag = as as keyof JSX.IntrinsicElements;
  const interactiveClasses = interactive
    ? "transition-shadow duration-200 hover:shadow-cardHover"
    : "";
  return (
    <Tag
      className={`rounded-2xl bg-white border border-brand-line/70 p-6 sm:p-7 shadow-card ${interactiveClasses} ${className}`}
    >
      {children}
    </Tag>
  );
}
