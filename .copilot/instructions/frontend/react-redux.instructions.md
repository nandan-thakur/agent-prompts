---
name: 'React & Redux Standards'
description: 'React component and Redux state management conventions for TSX/JSX files'
applyTo: '**/*.{tsx,jsx}'
---

# React & Redux Standards

## Component Rules
- One component per file — name the file after the component (`UserCard.tsx`)
- Use named exports: `export const UserCard = ...` (not `export default`)
- Props type must be defined at top of file: `type UserCardProps = { ... }`
- Destructure props in the function signature
- Use early returns for loading/error/empty states before the main render

## Hooks Rules
- Custom hooks must start with `use` and live in a `hooks/` directory
- Always specify dependency arrays — never leave them out
- Use `useMemo` for expensive computations, `useCallback` for handler stability
- Never call hooks conditionally or inside loops

## Redux Rules
- Access state only via selectors — never `state.feature.field` in components
- Use `createSelector` for any derived data to prevent re-renders
- Dispatch in event handlers or `useEffect`, never in render body
- Async logic goes in `createAsyncThunk` or RTK Query — never raw `useEffect` + `fetch`
- Keep Redux for global/shared state — local UI state stays in `useState`

## Patterns to Avoid
```tsx
// ❌ Inline objects cause re-renders
<Child style={{ color: 'red' }} />

// ✅ Move to SCSS module or useMemo
<Child className={styles.highlighted} />
```

```tsx
// ❌ Selecting entire slice re-renders on any change
const user = useSelector(state => state.user)

// ✅ Select specific fields
const userName = useSelector(selectUserName)
```
