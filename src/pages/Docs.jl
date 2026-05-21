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
			h3("What is HealthDash?"),
			p("HealthDash is a lightweight, extensible dashboard built with the Julia programming language and the Genie/Stipple UI stack. It provides a clean foundation for visualizing data, orchestrating analysis outputs, and integrating functionality from other repositories into a single, interactive interface. At core, HealthDash is a dashboard framework: a UI shell with pages, navigation, and a simple pattern for registering 'services' or modules. These modules can surface results produced by other code repositories (data processors, model runs, APIs) and present them visually - charts, tables and small exploratory tools. The design favors composability so teams can plug in domain-specific components without changing the core dashboard."),
			br(),

			h3("Available services"),
			br(),
			row(class = "q-gutter-md q-mb-lg services-row", service_cards),
		])
	]
end
