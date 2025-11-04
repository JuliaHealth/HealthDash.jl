function navbar()
	return row(class="hd-navbar", [
		cell(class="hd-navbar-inner row items-center no-wrap", [
			cell(class="col-auto hd-navbar-left", [
				h1("HealthDash", class="hd-logo")
			]),

			cell(class="col navbar-center", [
				row(class="nav-links row items-center justify-center no-wrap", [
					htmldiv(raw"<a href='/' class='nav-link'>Home</a>"),
					htmldiv(raw"<a href='/docs' class='nav-link q-ml-sm'>Docs</a>"),
					htmldiv(raw"<a href='/dashboard' class='nav-link q-ml-sm'>Dashboard</a>")
				])
			]),

			cell(class="col-auto hd-navbar-right row items-center no-wrap", [
				htmldiv(raw"<a href='https://github.com/JuliaHealth/HealthDash.jl' target='_blank' rel='noopener' title='HealthDash on GitHub' class='action-btn q-ml-sm center-github'><img src='/img/github.svg' alt='GitHub' /></a>")
			])
		])
	])
end
