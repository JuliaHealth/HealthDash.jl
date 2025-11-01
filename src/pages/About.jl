using StippleUI
export about_page

function about_page()
	return [
		navbar(),
		htmldiv(class="q-pa-md", [
			h1("About"),
			p("About HealthDash — a small demo app built with Stipple and Genie.")
		])
	]
end
