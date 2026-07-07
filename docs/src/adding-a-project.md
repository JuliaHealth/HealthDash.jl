# Adding Your Project

Adding a project to HealthDash means writing one small "extension" file.
You do not need to touch `HealthDash.jl` or any other core file - the
dashboard finds your extension on its own as long as it lives in the
right place.

## 1. Copy the template

Copy `src/extensions/Template/` to a new folder named after your project,
and rename the file inside to match:

```
src/extensions/MyProject/MyProject.jl
```

The folder name and the file name must match. That's how the dashboard
finds it.

## 2. Write your module

Open the new file and rename `TemplateExtension` to something for your
project, e.g. `MyProjectExtension`. Keep the docstring on the module -
that's what shows up on your service's **Service Docs** page, so write it
like you're explaining the extension to someone seeing it for the first
time.

```julia
"""
    MyProjectExtension

One or two sentences on what this extension shows and why it's useful.
"""
module MyProjectExtension

using Stipple
using StippleUI

export my_project_ui

function my_project_ui()
    return htmldiv(class = "ext-root q-pa-md", [
        h4("My Project"),
        p("Whatever you want to show here."),
    ])
end

end
```

## 3. Register it

At the bottom of the same file, outside the `module ... end` block, call
`register_extension`:

```julia
register_extension(ExtensionRegistry(
    "my-project",                       # unique id, used in URLs/routes
    "My Project",                       # name shown in the sidebar
    "Short one-line description.",      # shown on the home page
    MyProjectExtension.my_project_ui;
    source_module = MyProjectExtension, # lets docs autodoc your module
))
```

That's the entire contract. Once this file is in place, restarting the
app picks it up automatically - it'll appear as a card on the home page
and as an entry in the dashboard sidebar.

## Making it interactive

The dashboard is a Stipple app, so your UI can use Vue directives that
bind to the app's reactive state - `v-model`, `v-show`, `v-if`, `@click`.
The OMOPCommonDataModel extension is a good example: a `v-model` dropdown that
reveals the selected table's fields with `v-show`, all client-side and
with no page reload.
