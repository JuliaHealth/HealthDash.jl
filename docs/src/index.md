```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: HealthDash.jl
  text: A shared dashboard for JuliaHealth
  tagline: Plug your package's visualizations and tools into one interactive dashboard, instead of shipping a standalone app.
  actions:
    - theme: brand
      text: Adding Your Project
      link: /adding-a-project
    - theme: alt
      text: View on GitHub
      link: https://github.com/JuliaHealth/HealthDash.jl

features:
  - title: Drop-in extensions
    details: Add a folder under src/extensions and it shows up on the dashboard automatically - no edits to the core app.
  - title: Server-rendered and simple
    details: Built on Genie and Stipple. Extensions can be static views or interactive, using Vue directives bound to the app's reactive state.
  - title: Docs that stay in sync
    details: Each extension's docstring is pulled straight into this site, so the reference never drifts from the code.
---
```

## What is HealthDash?

HealthDash is a lightweight, extensible dashboard for the JuliaHealth
ecosystem. The core stays small: almost everything you see on the
dashboard comes from **extensions** - small self-contained modules that
each own one folder and one UI function.

- New here? Start with [Adding Your Project](adding-a-project.md).
- Looking for what each service does? Open **Service Docs** in the sidebar -
  every service's page is generated from the docstring in its source.
