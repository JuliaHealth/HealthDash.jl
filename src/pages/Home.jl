using StippleUI
export home

function home()
    return [
        navbar(),
        row([ cell(h1("HealthDash")) ]),
        row([ cell(p("Welcome to HealthDash — available modules:")) ]),
        row([ cell(ul([ li("Module A"), li("Module B") ])) ])
    ]
end
