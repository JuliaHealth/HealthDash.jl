function dashboard_page()
	return [
		navbar(),
		htmldiv(class="page-container q-pa-md", [

			h1("Dashboard", class = "text-h3"),
			row([ 
				cell(class="col-3 sidebar q-pa-md panel-border", [
					h4("Select service"),
					select(:selected_service,
						options = [ opts(value = s.id, label = s.title) for s in SERVICES ],
						optionlabel = :label,
						optionvalue = :value,
						label = "Choose a service",
						filled = "",
						useinput = false,
						clearable = false,
						dropdownicon = "arrow_drop_down",
						style = "width:100%",
						class = "q-mb-md"
					),

			  h4("Service options"),
			  p("Additional parameters (AP) will appear here."),
			  htmldiv(class="q-mb-lg"),

			 
			  row([ cell(class = "col-6", btn("Run", color = "primary", style = "width:100%")),
				  cell(class = "col-6", btn("Reset", flat = "", style = "width:100%"))
			  ]),
			]),

			cell(class="col dashboard-main q-pa-md panel-border dashboard-right", [
				])
			])
		])
	]
end
