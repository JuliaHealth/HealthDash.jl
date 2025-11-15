function dashboard_page()
	return [
		navbar(),
		htmldiv(class="page-container dashboard-container q-pa-md", [
			h1("Dashboard", class = "text-h3"),
			row([ 
				cell(class="col-3 sidebar q-pa-md panel-border", [
					# h4("Select service"),
					# select(:selected_service,
					# 	options = [ opts(value = s.id, label = s.title) for s in SERVICES ],
					# 	optionlabel = :label,
					# 	optionvalue = :value,
					# 	label = "Choose a service",
					# 	filled = "",
					# 	useinput = false,
					# 	clearable = false,
					# 	dropdownicon = "arrow_drop_down",
					# 	style = "width:100%",
					# 	class = "q-mb-md"
					# ),

					h4("Dataset path (paste absolute path)"),
					textfield("", :selected_db, placeholder = raw"C:\\path\\to\\data.duckdb", style = "width:100%", class = "q-mb-sm"),
					htmldiv(itemlabel("{{ selected_db }}"), class = "q-mt-sm text-caption q-mb-md"),
			 
			  row([ cell(class = "col-6", btn("Run", color = "primary", style = "width:100%", @click("run_action = run_action + 1"))),
				  cell(class = "col-6", btn("Reset", flat = "", style = "width:100%", @click("selected_db=''; db_tables=[]")))
			  ]),
	]),

			cell(class="col dashboard-main q-pa-md panel-border dashboard-right", [
				htmldiv(class = "q-pa-sm", [
				])
				])

			])
			])
		]
end
