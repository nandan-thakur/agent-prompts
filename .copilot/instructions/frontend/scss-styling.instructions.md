---
name: 'SCSS & Styling Standards'
description: 'SCSS architecture, CSS Modules, and design token conventions'
applyTo: '**/*.{scss,css,module.scss,module.css}'
---

# SCSS & Styling Standards

## SCSS Architecture
- Use `@use` and `@forward` — never `@import` (deprecated in Dart Sass)
- Variables in `shared/styles/_variables.scss` — always prefix: `$color-`, `$spacing-`, `$bp-`
- Mixins in `shared/styles/_mixins.scss` — use for breakpoints, typography, flex helpers
- Global reset/base in `shared/styles/_base.scss`

## CSS Modules
- All component styles use `.module.scss` extension
- Class names in `camelCase` — matches JS destructuring: `styles.cardTitle`
- Use `composes` for shared styles within modules
- Never use `:global()` unless styling third-party library overrides

## Naming (BEM)
```scss
// ✅ BEM naming
.card {
  &__header { ... }
  &__body { ... }
  &--highlighted { ... }
}
```

## Nesting Rules
- Maximum **3 levels** of nesting — deeper = refactor
- Prefer flat selectors over deep nesting for specificity control

## Responsive Design
```scss
// ✅ Use breakpoint mixin — mobile-first
@include breakpoint(md) {
  .container { max-width: 960px; }
}

// ❌ Hardcoded media query
@media (min-width: 768px) { ... }
```

## Theming & Dark Mode
- Colors via CSS custom properties: `var(--color-primary)`
- Theme switching toggles properties on `:root` or `[data-theme="dark"]`
- Never hardcode `#fff`, `#000`, or any raw color in component SCSS

## Avoid
- `!important` — fix specificity instead
- Inline `style={{}}` for static values — use SCSS classes
- Animating `width`, `height`, `top`, `left` — use `transform` and `opacity`
- Fixed `px` widths on containers — use `%`, `max-width`, or `clamp()`
