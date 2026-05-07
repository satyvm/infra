import type { ButtonHTMLAttributes, ReactNode } from "react";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  variant?: "primary" | "secondary" | "outline" | "ghost" | "danger";
  size?: "sm" | "md" | "lg";
  fullWidth?: boolean;
  loading?: boolean;
}

export function Button({
  children,
  variant = "primary",
  size = "md",
  fullWidth = false,
  loading = false,
  disabled,
  className = "",
  ...props
}: ButtonProps) {
  const baseClasses = [
    "inline-flex items-center justify-center font-medium rounded-lg transition-colors",
    "focus:outline-none focus:ring-2 focus:ring-offset-2",
    "disabled:opacity-50 disabled:cursor-not-allowed"
  ];

  const variantClasses = {
    primary: [
      "bg-blue-1000 hover:bg-blue-800 focus:ring-blue-500",
      "text-white shadow-sm"
    ],
    secondary: [
      "bg-gray-100 hover:bg-gray-200 focus:ring-gray-500",
      "text-gray-900 border border-gray-300"
    ],
    outline: [
      "bg-transparent hover:bg-blue-50 focus:ring-blue-500",
      "text-blue-1000 border border-blue-1000 hover:border-blue-800"
    ],
    ghost: [
      "bg-transparent hover:bg-gray-100 focus:ring-gray-500",
      "text-gray-700"
    ],
    danger: [
      "bg-red-1000 hover:bg-red-800 focus:ring-red-500",
      "text-white shadow-sm"
    ]
  };

  const sizeClasses = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base"
  };

  const widthClasses = fullWidth ? "w-full" : "";

  const allClasses = [
    ...baseClasses,
    ...variantClasses[variant],
    sizeClasses[size],
    widthClasses,
    className
  ].filter(Boolean).join(" ");

  return (
    <button
      className={allClasses}
      disabled={disabled || loading}
      {...props}
    >
      {loading && (
        <svg
          className="animate-spin -ml-1 mr-2 h-4 w-4"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle
            className="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            strokeWidth="4"
          />
          <path
            className="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          />
        </svg>
      )}
      {children}
    </button>
  );
}