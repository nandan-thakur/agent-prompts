# Project Copilot Instructions

## Tech Stack
- **Framework**: React 18+ with TypeScript (strict mode)
- **State Management**: Redux Toolkit (RTK) with RTK Query for data fetching
- **Styling**: SCSS with CSS Modules — BEM naming convention
- **Build**: Vite (or CRA/Next.js — adjust to your project)
- **Package Manager**: npm / pnpm
- **Testing**: Jest + React Testing Library

## Coding Conventions

### Components
- Functional components with hooks only — no class components
- Named exports over default exports
- One component per file, co-located with its `.module.scss` and `.test.tsx`
- Props defined as `type` (not `interface`) unless extending another type
- All exported functions/hooks must have JSDoc with `@param` and `@returns`

### TypeScript
- Strict mode enabled — no `any` types without documented justification
- Prefer `type` over `interface` for object shapes
- Use discriminated unions for state machines (`type Status = 'idle' | 'loading' | 'error'`)
- All API response types must be explicitly defined — no implicit `any`

### State Management
- Redux slices organized by feature domain: `features/<name>/slice.ts`
- Selectors co-located with slices in `features/<name>/selectors.ts`
- Use `createSelector` (reselect) for derived state — avoid computing in components
- Async operations use `createAsyncThunk` or RTK Query
- Never mutate state outside of RTK's Immer-powered reducers

### Styling
- SCSS variables for colors, spacing, breakpoints, typography
- CSS Modules for component scoping (`.module.scss`)
- BEM naming: `block__element--modifier`
- Max 3 levels of SCSS nesting
- Use `@use` and `@forward` — never `@import` (deprecated)
- Responsive: mobile-first with SCSS breakpoint mixins
- Dark mode via CSS custom properties, toggled at `:root`

### Error Handling
- `try/catch` blocks for all async operations
- Error boundaries around feature-level route components
- Always log errors with contextual information
- User-facing errors must have actionable messages

## File Organization
```
src/
├── features/           # Feature-based modules
│   └── <feature>/
│       ├── components/ # Feature components
│       ├── hooks/      # Feature hooks
│       ├── slice.ts    # Redux slice
│       ├── selectors.ts
│       ├── api.ts      # RTK Query or API calls
│       └── types.ts
├── shared/
│   ├── components/     # Reusable UI components
│   ├── hooks/          # Shared hooks
│   ├── utils/          # Utility functions
│   └── styles/         # Global SCSS (variables, mixins, reset)
├── app/
│   ├── store.ts        # Redux store config
│   ├── rootReducer.ts
│   └── routes.tsx
└── types/              # Global TypeScript types
```

## Review Standards
- 🔥 Security issues block merge unconditionally
- ♿ Accessibility issues must be addressed before merging to main
- 🏗️ Architecture issues flagged for discussion — may not block merge
- All PRs require passing CI before merge
