# Design Plan

## High-level goals

- Single dashboard app that can load one active dataset (choose a built-in example or upload), then let users run any available modules on it (pre-cohort, post-cohort, visualizations).

- Keep the UI modular (reusable Stipple components) and the backend extensible.

- Default developer-friendly path: local Julia packages (plugins) that can register new modules or capabilities.

- Each functional part (like dataset management, cohort handling, or visualizations) is treated as a module, making it easy to add, update, or reuse features.

The design assumes a single-dashboard app for now, with the backend and UI in one codebase, but it’s modular enough to expand into external APIs later if needed.

## Frontend

Design principle: a small set of reusable components that compose pages.

Pages

- Landing `/` - shows all the current available modules
- Dashboard `/dashboard` - dashboard with functionality
- Docs `/docs` - documentation, about the page, juliahealth and links
  Pages themselves could be made reusable so contributors can add additional pages if needed.

Core components

- NavBar
- SidePanel / Sidebar
- DatasetUploader / DatasetChooser (based on user choice)
- CohortBuilder / CohortSelector
- Microservice Selector
- Visualizations
- Microservice functionality
- Preview Tables...etc

Components like Visualizations or CohortSelector can work directly with standardized data formats (such as HealthTable) to make modules interoperable.

### Data sources

Support 2 simple ingestion modes (for now).

1. Built‑in datasets

   - Ship a small set of example datasets (e.g. Eunomia)
   - Appear in the DatasetChooser as "built‑in" items and can be activated immediately
   - Note: HealthSampleData.jl will also be registered soon, which helps with preloaded datasets.

2. Database uploader / connector
   - Allow users to upload a database / connect maybe ?!
     - Supported examples: DuckDB, SQLite (and optionally Postgres or other SQL sources).
   - Modes:
     - Upload mode: directly upload the db
     - Query mode: for connect based (not sure how to navigate for this yet)
     Note: databases can be large, so efficient handling is important.
   - Considerations:
     - Databases can be large, so uploading may not always work; connection mode may be needed.
     - For complex queries or analytics, it may be better to preprocess statistics externally and just visualize them in the dashboard.
     - We can leverage DBInterface.jl since much of the tooling is built around FunSQL.jl, which helps with connecting/querying databases efficiently.

### Cohort table detection and handling

- Detect whether the registered dataset or DB already contains a cohort table (by naming convention or schema).
  - If a cohort table exists:
    - Offer to "Use existing cohorts" (select `cohort_definition_id`) and run modules keyed to that id.
  - If no cohort table exists, provide two lightweight options:
    - Ephemeral cohorts: CohortBuilder produces an inline filter and sends it to the microservice run call. (maybe add a button "save cohort" to save)
    - Temporary cohorts: create a temporary cohort table in app DuckDB for repeated use in the session (could drop on unload or replacement).

The dashboard itself coordinates these tasks, but processing logic remains modular. Statistics can be precomputed externally, and visualization modules can simply consume results, avoiding locking processing methods into the UI.

## Backend

Goals:

- Support dataset lifecycle (upload, list, preview, activate, delete).
- Let the frontend discover and run available modules on the active dataset.
- Manage cohorts (detect, create ephemeral or temporary ones).
- Use DuckDB as the default runtime for dataset handling and lightweight storage.
- Keep the backend modular: new modules can register themselves dynamically.

The backend will run as part of the dashboard itself. Internal routes like /api/modules/run are designed to organize workflow and keep the app self-contained, while remaining future-ready if APIs are exposed later.

### Minimal Plan

#### /api/datasets (Dataset Lifecycle)

- `GET /api/datasets` - List all datasets and show which one is active.
- `POST /api/datasets` - Upload or connect to a dataset (CSV, Parquet, DuckDB, SQLite).
- `GET /api/datasets/:id/preview` - Preview sample rows and schema.
- `POST /api/datasets/:id/activate` - Mark a dataset as active for the current session.
- `DELETE /api/datasets/:id` - (Optional) Remove uploaded dataset from storage.

#### /api/cohorts (Cohort Lifecycle)

- `GET /api/cohorts/detect` - Check if the active dataset contains any cohort tables.
- `POST /api/cohorts/ephemeral` - Create a quick in-memory (inline filter) cohort.
- `POST /api/cohorts/create_temp` - Generate a temporary cohort table for reuse in the session.
- `POST /api/cohorts/use` - Select an existing cohort definition from the dataset.

#### /api/modules (Module Discovery + Execution)

- `GET /api/modules` - Return list of available modules with brief descriptions and required inputs.
- `POST /api/modules/run` - Run a chosen module on the active dataset (and cohort, if any). Returns results or job info.

Internal APIs allow modular handling of datasets, cohorts and modules, keeping the dashboard flexible and organized.

### How it maps to frontend

- Landing Page (modules): -> `GET /api/modules`
- DatasetUploader / Chooser: -> `POST /api/datasets` (upload), `GET /api/datasets` (list), `POST /api/datasets/:id/activate` (select)
- Cohort Builder / Selector: -> `GET /api/cohorts/detect`, `POST /api/cohorts/*` (create/use cohorts)
- Dashboard Visuals: -> `POST /api/modules/run` (receive result JSON and render charts/tables)
