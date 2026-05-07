import type { AnchorHTMLAttributes, ReactNode } from "react";

interface LinkProps extends AnchorHTMLAttributes<HTMLAnchorElement> {
  children: ReactNode;
  newTab?: boolean;
  href: string;
}

export function Link({ children, href, newTab, ...other }: LinkProps) {
  return (
    <a
      href={href}
      rel={newTab ? "noreferrer" : undefined}
      target={newTab ? "_blank" : undefined}
      className="text-blue-1000 hover:text-blue-800 underline hover:no-underline transition-colors"
      {...other}
    >
      {children}
    </a>
  );
}
