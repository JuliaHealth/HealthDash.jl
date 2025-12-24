function dashboard_page()
	extensions = list_extensions()
	
	service_items = [
		htmldiv(class="rail-section", [
			htmldiv(
				ext.name,
				class="rail-item",
				@click("selected_dashboard_item = '$(ext.id)'"),
				var"v-bind:class" = "selected_dashboard_item === '$(ext.id)' ? 'rail-item active' : 'rail-item'"
			),
			htmldiv(class="rail-divider")
		])
		for ext in extensions
	]
	
	right_content_blocks = [
		htmldiv(var"v-if" = "selected_dashboard_item === '$(ext.id)'", [ext.ui_component()])
		for ext in extensions
	]
	
	right_content = htmldiv([
		right_content_blocks...,
		htmldiv(var"v-if" = "selected_dashboard_item === ''", class="q-pa-lg", [
			h5("Select an item to view details")
		])
	])
	
	return [
		navbar(),
		htmldiv(class="dashboard-frame", [
			htmldiv(class="dashboard-rail q-pa-md", service_items),
			htmldiv(class="dashboard-content", [right_content])
		])
	]
end
