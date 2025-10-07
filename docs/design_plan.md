# HealthDash — Design Plan

## High-level goals

- Single dashboard app that can load one active dataset (choose a built-in example or upload), then let users run any available services on it (pre-cohort, post-cohort, visualizations).
- Keep the UI modular (reusable Stipple components) and the backend extensible
- Default developer-friendly path: local Julia packages (plugins) that register capabilities

## Frontend

Design principle: a small set of reusable components that compose pages.

Pages

- Microservices Landing `/` - shows all the current available microservices
- Dashboard `/dashboard` — dashboard with functionality
- About `/about` — about the page, juliahealth and links

Core components (Stipple)

- NavBar
- SidePanel / Sidebar
- DatasetUploader / DatasetChooser (based on user choice)
- CohortBuilder / CohortSelector
- Microservice Selector

Right side panel

- Visualizations
- Microservice functionality
- Preview Tables...etc
