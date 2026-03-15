---
name: 'Testing Standards'
description: 'Unit and integration test conventions for React components'
applyTo: '**/*.{test,spec}.{ts,tsx}'
---

# Testing Standards

## Test Structure
- One test file per component/hook: `ComponentName.test.tsx`
- Co-locate test files with source files
- Use `describe` blocks for grouping, `it` for individual tests
- Test names start with "should" — describe expected behavior, not implementation

## React Testing Library
- **Prefer accessible queries** in this order:
  1. `getByRole` — best for interactive elements
  2. `getByLabelText` — best for form fields
  3. `getByText` — for static content
  4. `getByTestId` — last resort only
- Use `userEvent` over `fireEvent` for user interactions
- Use `renderHook` from `@testing-library/react` for custom hooks
- Wrap async operations with `waitFor` — never use manual timeouts

## What to Test
- **Always test**: user interactions, conditional rendering, error states, loading states
- **Always test**: form validation, accessibility (use `toBeVisible`, `toHaveAccessibleName`)
- **Skip testing**: styling, third-party library internals, implementation details

## Redux Testing
- Test reducers in isolation with `slice.reducer(initialState, action)`
- Test selectors with mock state objects
- Test async thunks: verify dispatched actions for `pending`, `fulfilled`, `rejected`
- Integration tests: render component with real `<Provider store={...}>`

## Patterns
```tsx
// ✅ Testing user behavior
it('should show error when submitting empty form', async () => {
  render(<LoginForm />);
  await userEvent.click(screen.getByRole('button', { name: /submit/i }));
  expect(screen.getByRole('alert')).toHaveTextContent('Email is required');
});
```

```tsx
// ❌ Testing implementation details
it('should call setState', () => { /* bad */ });
```
