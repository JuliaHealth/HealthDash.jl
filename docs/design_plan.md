# Design Plan

## High-level goals

- Single dashboard app that can load one active dataset (choose a built-in example or upload), then let users run any available services on it (pre-cohort, post-cohort, visualizations).
- Keep the UI modular (reusable Stipple components) and the backend extensible
- Default developer-friendly path: local Julia packages (plugins) that register capabilities

## Frontend

Design principle: a small set of reusable components that compose pages.

<ins>Pages</ins>

- Microservices Landing `/` - shows all the current available microservices
- Dashboard `/dashboard` - dashboard with functionality
- About `/about` - about the page, juliahealth and links

<ins>Core components<ins>

- NavBar
- SidePanel / Sidebar
- DatasetUploader / DatasetChooser (based on user choice)
- CohortBuilder / CohortSelector
- Microservice Selector
- Visualizations
- Microservice functionality
- Preview Tables...etc

### UI Design (raw intuition)

![WhatsApp Image 2025-10-07 at 10 51 58_6eea6266](https://github.com/user-attachments/assets/bb707ae2-1d6b-439a-862c-140034a824c7)
![WhatsApp Image 2025-10-07 at 10 52 17_f06b448f](https://github.com/user-attachments/assets/64fecbba-7c8d-4fc4-8a8a-8e7940f14d1d)
![WhatsApp Image 2025-10-07 at 10 52 37_7ee9fd2e](https://github.com/user-attachments/assets/3ad45d35-74dd-44e0-b27c-7a8ca3932fb3)





