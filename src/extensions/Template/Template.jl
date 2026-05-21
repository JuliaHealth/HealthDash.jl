module TemplateExtension

using Stipple
using StippleUI
using ..ExtensionHelpers

export template_ui

function template_ui()
    notes = [
        ExtensionHelpers.ext_note("Build steps", [
            ExtensionHelpers.ext_list([
                "Copy this module and rename the id/name.",
                "Create a UI using StippleUI helpers like htmldiv(), h4(), p().",
                "Expose a run handler only if you need server-side work.",
                "Return a Dict from run; HealthDash serializes it automatically.",
            ]),
        ]),
    ]

    html = ExtensionHelpers.ext_root(
        "Template",
        "Starter module for package authors. Copy this file and edit the id, name, and UI.",
        notes,
    )

    return Stipple.ParsedHTMLString(string(html))
end

end
