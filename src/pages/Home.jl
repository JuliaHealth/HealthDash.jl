function home_page()
    service_cards = [
        card(class = "service-card", [
            cardsection([
                h4(s.title),
                p(s.desc)
            ])
        ]) for s in SERVICES
    ]

    return [
        navbar(),
        htmldiv(class = "hero", [
            htmldiv(class = "column", [
                h1("HealthDash"),
                p("A modular dashboard for cohort creation, analysis and lightweight visualization. Use the services below to start working with your data.")
            ])
        ]),

        htmldiv(class = "page-container q-pa-md", [
            row(class = "q-gutter-md q-mb-lg justify-center services-row", service_cards)
        ])
    ]
end


