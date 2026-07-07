# Design Plan

This describes how HealthDash is built today, followed by ideas we haven't
implemented yet.

## Goals

- One dashboard where JuliaHealth packages can surface their tools, instead
  of each shipping a standalone app.
- Keep the core small. Almost everything on the dashboard comes from
  **extensions** - self-contained modules that register themselves.
- Adding an extension should never require touching the core app.

## How it works today

### Extensions

An extension is a folder under `src/extensions/` with a same-named `.jl`
file, e.g. `src/extensions/MyProject/MyProject.jl`. That file defines a
module and calls `register_extension(...)` at the bottom. On startup the
loader (`src/extensions/loader.jl`) includes every such folder
automatically, so no core file has to change.

Each registration provides:

- `id` - unique id used in the UI state,
- `name` - shown in the sidebar and on the home cards,
- `description` - shown on the home cards and in `/api/modules`,
- `ui_component` - a function returning the UI to render,
- `source_module` - lets the docs site autodoc the extension.

The two extensions today are `Template` (a starter example) and
`OMOPCommonDataModel` (an explorer over OMOPCommonDataModel.jl).

### Pages

- `/` - home. A hero and a grid of service cards.
- `/dashboard` - a sidebar of services and the selected service's UI.
- `/api/modules` - JSON list of the registered services, for external tooling.

Shared pieces live in `src/components/` (the navbar) and
`src/extensions/helpers.jl` (small UI helpers).

### Interactivity

The dashboard is a Stipple app, so extensions can be static or interactive
using Vue directives bound to the app's reactive state. Switching services
(`selected_dashboard_item`) and picking an OMOP table
(`omop_selected_table`) both happen client-side with `@click`, `v-model`
and `v-show`, so nothing reloads the page.

## Ideas for later

These are not built yet - they're the direction we might grow in.

- **Datasets**: load a built-in example (e.g. via HealthSampleData.jl) or
  connect to a DuckDB/SQLite/Postgres source, then preview and activate it.
- **Cohorts**: detect existing cohort tables, or build ephemeral/temporary
  ones for a session (leaning on FunSQL.jl / DBInterface.jl).
- **Server-side work**: let an extension run computation and return results
  for the UI to visualize, rather than only rendering static or reflected
  data. Heavy processing would stay outside the dashboard; the UI would just
  visualize the results.
