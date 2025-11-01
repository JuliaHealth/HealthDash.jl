function navbar()
	return row(class="hd-navbar", [
		cell(class="hd-navbar-inner row items-center no-wrap", [
			# Left — Logo
			cell(class="col-auto hd-navbar-left", [
				h1("HealthDash", class="hd-logo")
			]),

			# Center — Navigation links (text)
			cell(class="col navbar-center", [
				row(class="nav-links row items-center justify-center no-wrap", [
					btn("Home", flat=true, dense=true, @click("window.location.href='/'"), class="nav-link"),
					btn("About", flat=true, dense=true, @click("window.location.href='/about'"), class="nav-link q-ml-sm"),
					btn("Dashboard", flat=true, dense=true, @click("window.location.href='/dashboard'"), class="nav-link q-ml-sm")
				])
			]),

			# Right — GitHub icon (external link)
			cell(class="col-auto hd-navbar-right row items-center no-wrap", [
				btn(flat=true, dense=true, round=true,
					@click("window.open('https://github.com/JuliaHealth/HealthDash.jl', '_blank')"),
					title="HealthDash on GitHub", class="action-btn q-ml-sm center-github", [
						htmldiv(raw"<img src='/img/github.svg' alt='GitHub'/>")
					])
			])
		])
	])
end
