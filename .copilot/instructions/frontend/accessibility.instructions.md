---
name: 'Accessibility Standards'
description: 'WCAG 2.1 accessibility rules for React UI components'
applyTo: '**/*.{tsx,jsx}'
---

# Accessibility Standards

## Semantic HTML
- Use `<button>` for actions, `<a>` for navigation — never `<div onClick>`
- Single `<h1>` per page, headings in sequential order (`h1 > h2 > h3`)
- Use landmarks: `<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`

## Interactive Elements
- All clickable non-button elements need `role`, `tabIndex={0}`, and `onKeyDown`
- All icon-only buttons need `aria-label`
- Dropdowns: `aria-expanded`, `aria-haspopup`
- Modals: focus trap on open, restore focus on close
- Toast/alert regions: `aria-live="polite"` or `"assertive"`

## Forms
- Every `<input>` must have an associated `<label>` (not just placeholder text)
- Required fields: `aria-required="true"` or `required` attribute
- Error messages linked via `aria-describedby`
- Group related fields with `<fieldset>` + `<legend>`

## Images & Icons
- `<img>`: meaningful → descriptive `alt`, decorative → `alt=""`
- SVG icons: `aria-hidden="true"` when decorative, `aria-label` when meaningful

## Motion
- All animations must respect `@media (prefers-reduced-motion: reduce)`
- Never auto-play video or audio without user control

## Focus
- Never use `outline: none` without a visible replacement
- Custom focus styles must have 3:1 contrast ratio
- Tab order must follow visual reading order
