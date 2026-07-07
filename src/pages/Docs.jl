function docs_page()
	cards = join([
		"""<a class="service-card" href="/dashboard">
			<div class="sc-title">$(ext.name)</div>
			<div class="sc-desc">$(ext.description)</div>
		</a>"""
		for ext in list_extensions()
	], "")

	return [
		navbar(),

		htmldiv(class="home", [
			htmldiv(class="hero", [
				htmldiv(raw"<span class='hero-eyebrow'>JuliaHealth</span>"),
				h1("HealthDash", class="hero-title"),
				p("One dashboard for the JuliaHealth ecosystem. Explore tools and data models from across the community, all in one place.", class="hero-tagline"),
				htmldiv(class="hero-actions", [
					htmldiv(raw"<a href='/dashboard' class='btn btn-primary'>Open the dashboard</a>"),
					htmldiv(raw"<a href='https://juliahealth.github.io/HealthDash.jl' target='_blank' rel='noopener' class='btn btn-ghost'>Read the docs</a>"),
				]),
			]),

			Stipple.ParsedHTMLString("""<div class="services-row">$cards</div>"""),
		]),
	]
end
