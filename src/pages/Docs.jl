function docs_page()
	service_cards = [
		card(class = "service-card", [
			cardsection([
				h4(s.title),
				p(s.desc)
			])
		]) for s in SERVICES
	]

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

					h3("Available services"),
					row(class = "q-gutter-md q-mb-lg services-row", service_cards),

					h3("Service docs (auto-generated)"),
					p("Service documentation will be generated here from each registered service’s metadata and docstrings."),

					h3("How to add a service"),
					ul([
						li("Create a service module/package that exposes metadata (name/description) and UI hooks."),
						li("Register the service with HealthDash so it appears as a tab and in the available services list."),
						li("Provide a docstring/metadata so docs can be auto-populated here.")
					]),
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
