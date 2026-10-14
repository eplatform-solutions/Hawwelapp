import type { AnchorHTMLAttributes, ButtonHTMLAttributes, ReactNode } from "react";
import { Link } from "react-router-dom";

type Variant = "primary" | "secondary" | "ghost" | "outline";
type Size = "md" | "lg";

const baseClasses =
  "inline-flex items-center justify-center gap-2 rounded-full font-semibold transition-all duration-200 focus-visible:outline-none disabled:opacity-50 disabled:cursor-not-allowed whitespace-nowrap";

const variantClasses: Record<Variant, string> = {
  primary:
    "bg-brand-primary text-white hover:bg-brand-primary/90 active:bg-brand-primary shadow-card hover:shadow-cardHover",
  secondary:
    "bg-brand-gold text-brand-primary hover:bg-brand-gold/90 shadow-card hover:shadow-cardHover",
  ghost:
    "bg-transparent text-brand-primary hover:bg-brand-primary/5",
  outline:
    "bg-white text-brand-primary border border-brand-line hover:border-brand-primary/40 hover:bg-brand-primary/5",
};

const sizeClasses: Record<Size, string> = {
  md: "px-5 py-2.5 text-sm",
  lg: "px-7 py-3.5 text-base",
};

type CommonProps = {
  variant?: Variant;
  size?: Size;
  children: ReactNode;
  className?: string;
};

type ButtonProps = CommonProps &
  Omit<ButtonHTMLAttributes<HTMLButtonElement>, "className" | "children"> & {
    as?: "button";
  };

type LinkProps = CommonProps &
  Omit<AnchorHTMLAttributes<HTMLAnchorElement>, "className" | "children" | "href"> & {
    as: "link";
    to: string;
  };

type ExternalAnchorProps = CommonProps &
  Omit<AnchorHTMLAttributes<HTMLAnchorElement>, "className" | "children"> & {
    as: "a";
    href: string;
  };

type Props = ButtonProps | LinkProps | ExternalAnchorProps;

export default function Button(props: Props) {
  const {
    variant = "primary",
    size = "md",
    children,
    className = "",
    ...rest
  } = props as CommonProps & Record<string, unknown>;

  const classes = `${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${className}`;

  if (props.as === "link") {
    const { to, ...anchorRest } = rest as { to: string } & Record<string, unknown>;
    return (
      <Link to={to} className={classes} {...(anchorRest as Record<string, unknown>)}>
        {children}
      </Link>
    );
  }

  if (props.as === "a") {
    return (
      <a className={classes} {...(rest as AnchorHTMLAttributes<HTMLAnchorElement>)}>
        {children}
      </a>
    );
  }

  return (
    <button className={classes} {...(rest as ButtonHTMLAttributes<HTMLButtonElement>)}>
      {children}
    </button>
  );
}
