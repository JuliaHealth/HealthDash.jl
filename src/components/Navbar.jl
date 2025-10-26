using StippleUI
export navbar

function navbar()
    return row(class="hd-navbar row items-center q-pa-sm", [
        cell(class="col-auto", [
            h1("HealthDash", class="hd-logo")
        ]),
        cell(class="col", [
            space()
        ]),
        cell(class="col-auto row items-center no-wrap", [
            btn("Home", flat = "", dense = "", @click("window.location.href='/'"), class = "nav-btn"),
            btn("Dashboard", flat = "", dense = "", @click("window.location.href='/dashboard'"), class = "nav-btn q-ml-sm"),
            btn("About", flat = "", dense = "", @click("window.location.href='/about'"), class = "nav-btn q-ml-sm")
        ])
    ])
end
