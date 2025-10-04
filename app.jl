module HealthDashApp

using GenieFramework
@genietools

@app begin
	@in theme = "dark"
end

function header()
	return column([
		h1("HealthDash.jl", style="margin-bottom: 0.25rem;"),
		p("A minimal interactive dashboard starter for JuliaHealth.", style="margin-top: 0; color: #555")
	], style="margin-bottom: 0.5rem;")
end

function ui()
	column(style = "max-width: 880px; margin: 2rem auto;", [
		cell([ header() ]),
		cell([ hr() ]),
		cell([
			p("Welcome to HealthDash.jl! This is a minimal example of a web app built with Genie + Stipple."),
		]),
	])
end

@page("/", ui)

end
