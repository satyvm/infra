# Tailwind CSS Integration Guide

This document describes the complete Tailwind CSS setup for our Turborepo monorepo, following the official Turborepo patterns and best practices.

## 🎯 Overview

Our Tailwind CSS integration uses **Tailwind CSS v4** with a shared configuration approach that allows:
- ✅ Centralized theme and styling configuration
- ✅ Shared UI components with consistent styling
- ✅ Framework-agnostic approach (works with Next.js, Vite, Remix)
- ✅ Optimal CSS generation and bundling
- ✅ Development-friendly hot reloading

## 📁 Project Structure

```
packages/
├── tailwind-config/          # Shared Tailwind configuration
│   ├── package.json
│   ├── shared-styles.css      # Main Tailwind imports + custom theme
│   └── postcss.config.js      # PostCSS configuration
│
└── ui/                        # Shared UI components
    ├── package.json
    ├── styles.css             # Component-specific Tailwind imports
    ├── dist/
    │   ├── index.css          # Generated CSS bundle
    │   └── ...                # Component builds
    └── src/
        ├── counter-button/
        └── link/

apps/
├── storefront/                # Next.js app
│   ├── postcss.config.js      # Uses shared PostCSS config
│   └── src/app/styles.css     # Imports shared styles
│
├── admin/                     # Vite app
│   ├── postcss.config.js      # Uses shared PostCSS config
│   └── src/index.css          # Imports shared styles
│
└── blog/                      # Remix app
    ├── postcss.config.js      # Uses shared PostCSS config
    └── app/styles.css         # Imports shared styles
```

## 🔧 How It Works

### 1. Shared Configuration (`@repo/tailwind-config`)

**`packages/tailwind-config/shared-styles.css`**
```css
@import "tailwindcss";

@theme {
  --blue-1000: #2a8af6;
  --purple-1000: #a853ba;
  --red-1000: #e92a67;
  --green-1000: #22c55e;
  --orange-1000: #f97316;
  --gray-1000: #374151;
}
```

**`packages/tailwind-config/postcss.config.js`**
```javascript
export const postcssConfig = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};
```

### 2. UI Package CSS Generation

The UI package builds Tailwind styles and components separately:

```json
{
  "scripts": {
    "build": "pnpm run build:styles && pnpm run build:components",
    "build:styles": "tailwindcss -i ./styles.css -o ./dist/index.css",
    "build:components": "bunchee"
  }
}
```

### 3. App Integration

Each app imports the shared styles and configuration:

```css
@import "@repo/tailwind-config";
@import "@repo/ui/styles.css";
```

## 🚀 Usage

### Adding New Tailwind Classes

You can use any Tailwind class in your components:

```tsx
// Example component
export function MyComponent() {
  return (
    <div className="bg-blue-500 hover:bg-blue-600 p-4 rounded-lg shadow-md transition-colors">
      <h1 className="text-2xl font-bold text-white">Hello World</h1>
      <p className="text-blue-100 mt-2">This uses Tailwind classes!</p>
    </div>
  );
}
```

### Using Custom Theme Colors

Access your custom theme colors with the defined names:

```tsx
<button className="bg-blue-1000 hover:bg-purple-1000 text-white px-4 py-2 rounded">
  Custom Theme Button
</button>
```

### Adding New Components to UI Package

1. Create your component with Tailwind classes:

```tsx
// packages/ui/src/my-button/index.tsx
export function MyButton({ children, variant = "primary" }) {
  const baseClasses = "px-4 py-2 rounded font-medium transition-colors";
  const variantClasses = {
    primary: "bg-blue-1000 hover:bg-blue-800 text-white",
    secondary: "bg-gray-200 hover:bg-gray-300 text-gray-800"
  };

  return (
    <button className={`${baseClasses} ${variantClasses[variant]}`}>
      {children}
    </button>
  );
}
```

2. Add the export to `package.json`:

```json
{
  "exports": {
    "./my-button": {
      "import": {
        "types": "./dist/es/my-button.d.mts",
        "default": "./dist/es/my-button.mjs"
      },
      "require": {
        "types": "./dist/cjs/my-button.d.ts",
        "default": "./dist/cjs/my-button.js"
      }
    }
  }
}
```

3. Build the package:

```bash
pnpm run build --filter=@repo/ui
```

## 🎨 Extending the Theme

### Adding Custom Colors

Edit `packages/tailwind-config/shared-styles.css`:

```css
@theme {
  --blue-1000: #2a8af6;
  --purple-1000: #a853ba;
  --red-1000: #e92a67;
  
  /* Add your custom colors */
  --brand-primary: #your-color;
  --brand-secondary: #your-other-color;
}
```

### Adding Custom Components

Add reusable component styles in the shared config:

```css
@import "tailwindcss";

@theme {
  /* Your theme colors */
}

/* Custom component styles */
@layer components {
  .btn-primary {
    @apply bg-blue-1000 hover:bg-blue-800 text-white font-medium py-2 px-4 rounded transition-colors;
  }
  
  .card {
    @apply bg-white shadow-lg rounded-lg p-6 border border-gray-200;
  }
}
```

## 📦 Development Workflow

### Building Everything

```bash
# Build all packages and apps
pnpm run build

# Build just the UI package
pnpm run build --filter=@repo/ui

# Build a specific app
pnpm run build --filter=storefront
```

### Development Mode

```bash
# Start all apps in development
pnpm run dev

# Start just the UI package in watch mode
pnpm run dev --filter=@repo/ui

# Start a specific app
pnpm run dev --filter=admin
```

### Adding Dependencies

```bash
# Add Tailwind plugins to the shared config
pnpm add -D @tailwindcss/forms --filter=@repo/tailwind-config

# Add UI dependencies
pnpm add some-ui-lib --filter=@repo/ui

# Add app-specific dependencies
pnpm add next-auth --filter=storefront
```

## 🔍 Troubleshooting

### Styles Not Loading

1. **Check CSS imports**: Ensure each app imports the shared styles:
   ```css
   @import "@repo/tailwind-config";
   @import "@repo/ui/styles.css";
   ```

2. **Rebuild UI package**: The CSS must be generated:
   ```bash
   pnpm run build --filter=@repo/ui
   ```

3. **Check PostCSS config**: Each app should have the PostCSS configuration.

### Classes Not Being Purged/Generated

1. **Content paths**: Tailwind v4 automatically scans for classes, but ensure your files are in standard locations.

2. **Development vs Production**: Some classes might only appear in development mode.

### Build Errors

1. **Dependency issues**: Ensure all Tailwind dependencies are installed:
   ```bash
   pnpm install
   ```

2. **Version conflicts**: Check that all apps use compatible versions of Tailwind and PostCSS.

## 📚 Best Practices

### 1. Component Organization
- Keep styling logic in the UI package when possible
- Use semantic class names for complex components
- Leverage Tailwind's utility classes for layout and spacing

### 2. Theme Consistency
- Define all brand colors in the shared theme
- Use consistent naming conventions (e.g., `brand-primary`, `brand-secondary`)
- Document custom theme additions

### 3. Performance
- The UI package builds CSS only for used components
- Each app only imports what it needs
- Tailwind automatically purges unused styles

### 4. Maintainability
- Keep custom CSS minimal - prefer Tailwind utilities
- Document complex component patterns
- Use TypeScript for better component APIs

## 🆕 Adding New Apps

To add Tailwind support to a new app:

1. **Add dependencies**:
   ```json
   {
     "dependencies": {
       "@repo/tailwind-config": "workspace:*",
       "@repo/ui": "workspace:*"
     },
     "devDependencies": {
       "@tailwindcss/postcss": "^4.1.5",
       "tailwindcss": "^4.1.5"
     }
   }
   ```

2. **Create PostCSS config**:
   ```javascript
   import { postcssConfig } from "@repo/tailwind-config/postcss";
   export default postcssConfig;
   ```

3. **Import styles**:
   ```css
   @import "@repo/tailwind-config";
   @import "@repo/ui/styles.css";
   ```

4. **Configure your build tool** (Vite, Next.js, etc.) to process PostCSS.

## 🎯 Next Steps

- **Component Library**: Expand the UI package with more components
- **Design Tokens**: Consider using design tokens for more complex theming
- **Documentation**: Add Storybook for component documentation
- **Testing**: Add visual regression testing for UI components

---

For questions or issues, refer to the [Tailwind CSS v4 documentation](https://tailwindcss.com/docs) or the [Turborepo documentation](https://turbo.build/repo/docs).