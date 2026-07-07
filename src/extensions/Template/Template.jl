"""
    TemplateExtension

Starter extension for package authors. Copy this whole folder, rename it to
match your project, and swap in your own UI. See
docs/src/adding-a-project.md for the full walkthrough.
"""
module TemplateExtension

using Stipple

export template_ui

const EXAMPLE = raw"""
module MyProject

using Stipple
export my_project_ui

function my_project_ui()
    return htmldiv(class = "ext-root", [
        h4("My Project", class = "ext-heading"),
        p("Whatever you want to show here."),
    ])
end

end

register_extension(ExtensionRegistry(
    "my-project",              # unique id
    "My Project",              # name in the sidebar and home card
    "One-line description.",   # shown on the home page
    MyProject.my_project_ui;
    source_module = MyProject,
))
"""

# The short "how to add your own service" guide shown on the dashboard.
function template_ui()
    html = """
    <div class="ext-root">
      <h4 class="ext-heading">Add your own service</h4>
      <p class="ext-subtitle">
        Every service here is one small, self-contained file. Adding yours
        takes three steps and never touches the core app.
      </p>

      <ol class="tpl-steps">
        <li><strong>Copy this folder.</strong> Duplicate
            <code>src/extensions/Template/</code> to
            <code>src/extensions/MyProject/</code> and rename the file to
            <code>MyProject.jl</code> - the folder and file names must match.</li>
        <li><strong>Write your UI.</strong> Return StippleUI elements like
            <code>htmldiv()</code>, <code>h4()</code>, <code>p()</code>, or a raw HTML string.</li>
        <li><strong>Register it.</strong> Call <code>register_extension</code> at the
            bottom of the file, then restart - it appears automatically.</li>
      </ol>

      <p class="ext-label">Minimal example</p>
      <pre class="ext-code tpl-code">$(EXAMPLE)</pre>

      <p class="tpl-foot">Full walkthrough: <code>docs/src/adding-a-project.md</code></p>
    </div>
    """

    return Stipple.ParsedHTMLString(html)
end

end

register_extension(ExtensionRegistry(
    "template",
    "Template",
    "A starter example - copy it to add your own service to the dashboard.",
    TemplateExtension.template_ui;
    source_module = TemplateExtension,
))
