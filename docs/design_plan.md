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

## Backend

Goals:

- Support dataset lifecycle (upload, list, preview, choose active).
- Let the frontend discover available microservices and run them on the active dataset.
- Might use DuckDB as the storage runtime

Minimal Plan:

1. GET /api/health (UI uses it to check backend availability.)

2. /api/datasets (dataset lifecycle)

- GET /api/datasets (List datasets and which one is active)
- POST /api/datasets (Upload dataset (CSV/Parquet) or database directly maybe, backend will start working accordingly)
- GET /api/datasets/:id/preview (for previewing)
- POST /api/datasets/:id/activate (Mark a dataset active for the curr session)

3. /api/services (service discovery + run)

- GET /api/services (Return list of available microservices and a short description of what they need)
- POST /api/services/run (Backend runs the service and returns the result directly, with error functionality as well)

and many more.. (didnt further yet)

### How it maps to frontend

- Landing page (microservices) -> GET /api/services
- DatasetUploader/Chooser -> POST /api/datasets (upload), GET /api/datasets (list), POST /api/datasets/:id/activate (select)
- (one for cohort builder and chooser)
- Dashboard visuals → POST /api/services/run returning results

## Data flow

1. Upload:

- User uploads a database or selects a built-in database.

2. Activate:
   User marks a dataset active via POST /api/datasets/:id/activate; backend records active dataset identifier.

3. Run a service:

- Frontend calls POST /api/services/run with chosen service id and others params.
- Backend validates and runs SQL/Julia function to compute the result, and returns result JSON directly.
- Frontend renders result (chart/table).
