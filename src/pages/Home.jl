using StippleUI
export home_page

function home_page()
    return [
        navbar(),
        htmldiv(class="q-pa-md", [
            h2("Home"),
            p("Welcome to HealthDash.")
        ])
    ]
end
