function docs_page()
	return [
		navbar(),

		htmldiv(class="page-container docs-page q-pa-md", [
			h1("Documentation", class = "text-h3"),

			p("HealthDash is a lightweight, extensible dashboard built with the Julia programming language and the Genie/Stipple UI stack. It provides a clean foundation for visualizing data, orchestrating analysis outputs, and integrating functionality from other repositories into a single, interactive interface."),

			htmldiv(class="about-grid q-gutter-md", [
				htmldiv(class="about-col", [
					h3("What is HealthDash?"),
					p("At core, HealthDash is a dashboard framework: a UI shell with pages, navigation, and a simple pattern for registering 'services' or modules. These modules can surface results produced by other code repositories (data processors, model runs, APIs) and present them visually - charts, tables and small exploratory tools. The design favors composability so teams can plug in domain-specific components without changing the core dashboard."),

					h3("Key capabilities"),
						ul([
							li("Modular pages and components that can be extended or replaced."),
							li("Data-driven service cards that can enumerate available connectors or analyses."),
							li("A minimal, responsive UI that focuses on data presentation and integration."),
							li("Extensible connectors: HealthDash can load outputs from other repos or call APIs and expose their outputs visually.")
						]),
					h3("Links and resources"),
					ul([
						li(raw"<a href='https://github.com/JuliaHealth/HealthDash.jl' target='_blank' rel='noopener'>HealthDash repository (this project)</a>"),
						li(raw"<a href='https://github.com/JuliaHealth' target='_blank' rel='noopener'>JuliaHealth GitHub organization (community projects)</a>"),
						li(raw"<a href='https://julialang.org' target='_blank' rel='noopener'>The Julia language</a>"),
						li(raw"<a href='https://github.com/GenieFramework/Genie.jl' target='_blank' rel='noopener'>Genie.jl (web framework)</a>"),
						li(raw"<a href='https://github.com/GenieFramework/Stipple.jl' target='_blank' rel='noopener'>Stipple (reactive UI library)</a>"),
						li(raw"<a href='https://github.com/JuliaHealth/HealthDash.jl/issues' target='_blank' rel='noopener'>Issues & support (open an issue on the repo)</a>")
					])
				]),

				htmldiv(class="about-col", [
					h3("About JuliaHealth"),
					raw"<p>JuliaHealth is an open community and organization that develops and curates Julia tools for biomedical and healthcare research. The organization hosts multiple projects that work together to accelerate reproducible analyses and interactive data exploration.</p>",
					raw"<p>Organization on GitHub: <a href='https://github.com/JuliaHealth' target='_blank' rel='noopener'>github.com/JuliaHealth</a></p>",

					h3("About Julia"),
					raw"<p>Julia is a high-performance, dynamic language for technical computing. It combines the ease of a scripting language with performance close to statically compiled languages. Key features include multiple dispatch, a rich package ecosystem, and suitability for numerical and data-heavy workloads.</p>",
					raw"<p>Learn more: <a href='https://julialang.org' target='_blank' rel='noopener'>julialang.org</a></p>",
				])
			]),
		])
	]
end
