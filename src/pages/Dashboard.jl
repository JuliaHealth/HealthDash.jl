using StippleUI
export dashboard_page

function dashboard_page()
	return [
		navbar(),
		htmldiv(class="q-pa-md", [
			h1("Dashboard"),
			p("This is the dashboard page.")
		])
	]
end
