# Design Plan

## High-level goals

- Single dashboard app that can load one active dataset (choose a built-in example or upload), then let users run any available services on it (pre-cohort, post-cohort, visualizations).
- Keep the UI modular (reusable Stipple components) and the backend extensible
- Default developer-friendly path: local Julia packages (plugins) that register capabilities

## Frontend

Design principle: a small set of reusable components that compose pages.

Pages

- Microservices Landing `/` - shows all the current available microservices
- Dashboard `/dashboard` - dashboard with functionality
- About `/about` - about the page, juliahealth and links

Core components

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

### Data sources 

Support 2 simple ingestion modes (for now).

1. Built‑in datasets
   - Ship a small set of example datasets (e.g. Eunomia)
   - Appear in the DatasetChooser as "built‑in" items and can be activated immediately

2. Database uploader / connector
   - Allow users to upload a database / connect maybe ?!
     - Supported examples: DuckDB, SQLite (and optionally Postgres or other SQL sources).
   - Modes:
     - Upload mode: directly upload the db
     - Query mode: for connect based (not sure how to navigate for this yet)
   Big Con here: is that dbs are usually large, and upload might not work out here.

### Cohort table detection and handling

- Detect whether the registered dataset or DB already contains a cohort table (by naming convention or schema).
  - If a cohort table exists:
    - Offer to "Use existing cohorts" (select `cohort_definition_id`) and run microservices keyed to that id.
  - If no cohort table exists, provide two lightweight options:
    - Ephemeral cohorts: CohortBuilder produces an inline filter and sends it to the microservice run call. (maybe add a button "save cohort" to save)
    - Temporary cohorts: create a temporary cohort table in app DuckDB for repeated use in the session (could drop on unload or replacement).

## Backend

Goals:
- Support dataset lifecycle (upload, list, preview, activate, delete).  
- Let the frontend discover and run available microservices on the active dataset.  
- Manage cohorts (detect, create ephemeral or temporary ones).  
- Could use DuckDB as the default runtime for dataset handling and lightweight storage.  
- Keep it modular: new microservices can register plugin-style ?!  

Minimal Plan:

1. /api/datasets (dataset lifecycle)  
   - `GET /api/datasets` — List all datasets and show which one is active.  
   - `POST /api/datasets` — Upload or connect to a dataset (CSV, Parquet, DuckDB, SQLite).  
   - `GET /api/datasets/:id/preview` — Preview sample rows and schema.  
   - `POST /api/datasets/:id/activate` — Mark a dataset as active for the current session.  
   - `DELETE /api/datasets/:id` — (Optional) Remove uploaded dataset from storage.  

2. /api/cohorts (cohort lifecycle)  
   - `GET /api/cohorts/detect` — Check if the active dataset contains any cohort tables.  
   - `POST /api/cohorts/ephemeral` — Create a quick in-memory (inline filter) cohort.  
   - `POST /api/cohorts/create_temp` — Generate a temporary cohort table for reuse in the session.  
   - `POST /api/cohorts/use` — Select an existing cohort definition from the dataset.  

3. /api/services (microservice discovery + execution)  
   - `GET /api/services` — Return list of available microservices with brief descriptions and required inputs.  
   - `POST /api/services/run` — Run a chosen microservice on the active dataset (and cohort, if any). Returns results or job info.  

and many more.. (didnt think further yet)

### How it maps to frontend

- Landing Page (Microservices): -> `GET /api/services`  
- DatasetUploader / Chooser: -> `POST /api/datasets` (upload), `GET /api/datasets` (list), `POST /api/datasets/:id/activate` (select)  
- Cohort Builder / Selector: -> `GET /api/cohorts/detect`, `POST /api/cohorts/*` (create/use cohorts)  
- Dashboard Visuals: -> `POST /api/services/run` (receive result JSON and render charts/tables)



