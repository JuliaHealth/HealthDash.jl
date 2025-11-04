function dashboard_page()
	return [
		navbar(),
		htmldiv(class="page-container q-pa-md", [
			row([ 
				cell(class="col-3 sidebar", [
					h3("Core components"),
					ul([
						li("SidePanel / Sidebar"),
						li("DatasetUploader / DatasetChooser"),
						li("CohortBuilder / CohortSelector"),
						li("Service Selector"),
						li("Visualizations"),
						li("Preview Tables")
					])
				]),
				cell(class="col dashboard-main", [
					h1("Dashboard UI"),
					p("This area will host the interactive dashboard tools. For now it's a visual scaffold showing the main components."),
					row(@gutter :md [
						card([ cardsection([ h4("Dataset"), p("Uploader / chooser UI goes here") ]) ]),
						card([ cardsection([ h4("Cohort Builder"), p("Filters and cohort creation UI") ]) ])
					])
				])
			])
		])
	]
end
