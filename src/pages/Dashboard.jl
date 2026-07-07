function dashboard_page()
    extensions = list_extensions()

    rail_items = [
        htmldiv(
            ext.name,
            class = "rail-item",
            @click("selected_dashboard_item = '$(ext.id)'"),
            var"v-bind:class" = "selected_dashboard_item === '$(ext.id)' ? 'rail-item active' : 'rail-item'",
        )
        for ext in extensions
    ]

    panes = [
        htmldiv(var"v-show" = "selected_dashboard_item === '$(ext.id)'", [ext.ui_component()])
        for ext in extensions
    ]

    return [
        navbar(),
        htmldiv(class = "dashboard-shell", [
            htmldiv(class = "dashboard-frame", [
                htmldiv(class = "dashboard-rail", [
                    p("Services", class = "rail-title"),
                    htmldiv(class = "rail-list", rail_items),
                ]),
                htmldiv(class = "dashboard-content", panes),
            ]),
        ]),
    ]
end
