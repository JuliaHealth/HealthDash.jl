# HealthDash.jl

A dashboard for the JuliaHealth ecosystem, built with Genie.jl and
Stipple.jl. It gives JuliaHealth packages a shared place to surface
visualizations, demos, and small tools instead of everyone shipping a
separate standalone app.

## Running it locally

```
julia app.jl
```

## Adding your own project to the dashboard

Adding a project is a single self-contained file - you don't need to
touch any of the core dashboard code. See
[docs/src/adding-a-project.md](docs/src/adding-a-project.md) for the full
walkthrough, or jump straight to `src/extensions/Template/` for a
copy-paste starting point.

## Docs

Full docs (including a generated reference of every extension currently
on the dashboard) live in [docs/](docs/) and build with Documenter.jl /
DocumenterVitepress:

```
julia --project=docs docs/make.jl
```
