function about_page()
	return [
		navbar(),
		htmldiv(class="page-container q-pa-md", [
			h1("About HealthDash", class = "text-h3"),
			p("HealthDash is a lightweight, modular dashboard built with the Julia language and Stipple/StippleUI for interactive UIs."),
			p("The project is focused on cohort management and visualization workflows: create or select cohorts, run preprocessing and post-cohort analyses, and visualize results. Right now the app provides a UI scaffold so modules can be plugged in later."),
			separator(),
			row(@gutter :md [
				card([
					cardsection([ h3("Purpose"), p("Make cohort workflows approachable and modular for research and health data teams.") ]),
				]),
				card([
					cardsection([ h3("Built with"), p("Julia, Genie, Stipple, StippleUI") ])
				])
			])
		])
	]
end
