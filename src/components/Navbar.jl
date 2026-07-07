function navbar()
	return htmldiv(class="hd-navbar", [
		htmldiv(class="hd-navbar-inner", [
			htmldiv(class="hd-navbar-left", [
				htmldiv(raw"<a href='/' class='hd-logo'>HealthDash</a>")
			]),

			htmldiv(class="hd-navbar-links", [
				htmldiv(raw"<a href='/' class='nav-link'>Home</a>"),
				htmldiv(raw"<a href='/dashboard' class='nav-link'>Dashboard</a>"),
				htmldiv(raw"<a href='https://juliahealth.github.io/HealthDash.jl' target='_blank' rel='noopener' class='nav-link'>Docs</a>"),
				htmldiv(raw"<a href='https://github.com/JuliaHealth/HealthDash.jl' target='_blank' rel='noopener' title='HealthDash on GitHub' class='action-btn'><img src='/img/github.svg' alt='GitHub' class='icon-github' /></a>")
			])
		])
	])
end
