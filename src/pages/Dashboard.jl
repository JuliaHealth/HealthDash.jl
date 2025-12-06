function dashboard_page()
	return [
		navbar(),
		htmldiv(class="dashboard-frame", [
			htmldiv(class="dashboard-rail q-pa-md")
		])
	]
end
