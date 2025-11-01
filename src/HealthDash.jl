module HealthDash

# load the Genie environment first so that all other modules can be properly initialized
module GenieEnvLoader
    using Genie, Dates
    t_startup::DateTime = DateTime(0)
        
    function __init__()
        global t_startup = now()
        cd(@project_path)
        Genie.config.path_build = @project_path "build"
        Genie.Loader.loadenv(; context = @__MODULE__)
        up()
    end
end

import .GenieEnvLoader.t_startup

using Stipple.ModelStorage.Sessions.GenieSession
using Stipple, Stipple.ReactiveTools
using StippleUI
include(joinpath(@__DIR__, "components", "Navbar.jl"))
include(joinpath(@__DIR__, "pages", "Home.jl"))
include(joinpath(@__DIR__, "pages", "About.jl"))
using Dates
HTTP::Module = Genie.HTTPUtils.HTTP

import Stipple: opts, hget
import Genie.Router.Route
import Genie.Generator.Logging
import Genie.Assets.asset_path
import Genie.Server.openbrowser
import Genie.Util: @wait

export openbrowser, @wait

@app MyApp begin
    @in x = 1.0
    @in search = ""
    @in storage = 0.26

    @onchange isready begin
        global t_startup
        if t_startup != DateTime(0)
            println()
            @info "Serving from $(pwd())"
            @info "Startup time: $(now() - t_startup)"
            t_startup = DateTime(0)
        end
    end

    @onchange x begin
        global hh
        println(x)
        y = parse(Int, "0" * GenieSession.get(hh, :hh)[4:end]) + 1
        GenieSession.persist(GenieSession.set!(hh, :hh, "hh_$y"))
    end
end

UI::Vector{Genie.Renderer.Html.ParsedHTMLString} = [
    home_page()
]

Stipple.client_data(::MyApp) = client_data(
    leftDrawerOpen = false,
    links1 = [
        opts(icon = "photo", text = "Photos"),
        opts(icon = "photo_album", text = "Albums"),
        opts(icon = "assistant", text = "Assistant"),
        opts(icon = "people", text = "Sharing"),
        opts(icon = "book", text = "Photo books")
    ],
    links2 = [
        opts(icon = "archive", text = "Archive"),
        opts(icon = "delete", text = "Trash")
    ],
    links3 = [
        opts(icon = "settings", text = "Settings"),
        opts(icon = "help", text = "Help"),
        opts(icon = "get_app", text = "App Downloads")
    ],
    createMenu = [
        opts(icon = "photo_album", text = "Album"),
        opts(icon = "people", text = "Shared"),
        opts(icon = "movie", text = "Movie"),
        opts(icon = "library_books", text = "Animation"),
        opts(icon = "dashboard", text = "Collage"),
        opts(icon = "book", text = "Photo books")
    ]
)

local_material_fonts() = (stylesheet("/iconsets/material/font/material.css"),)
navbar_css() = (stylesheet("/css/navbar.css"),)
pages_css() = (stylesheet("/css/pages.css"),)

# adcss(googlefonts_css)
add_css(local_material_fonts)
ui() = UI

home::Route = route("/") do
    global hh = session()
    core_theme = false
    global model = @init(MyApp; core_theme)
    GenieSession.set!(session(), :hh, "hh")
    page(model, ui; core_theme) |> html
end

gpl_css() = [style("""
.GPL__toolbar {
  height: 64px;
}

.GPL__toolbar-input {
  width: 35%;
}

.GPL__drawer-item {
  line-height: 24px;
  border-radius: 0 24px 24px 0;
  margin-right: 12px;
}

.GPL__drawer-item .q-item__section--avatar {
  padding-left: 12px;
}

.GPL__drawer-item .q-item__section--avatar .q-icon {
  color: #5f6368;
}

.GPL__drawer-item .q-item__label:not(.q-item__label--caption) {
  color: #3c4043;
  letter-spacing: .01785714em;
  font-size: .875rem;
  font-weight: 500;
  line-height: 1.25rem;
}

.GPL__drawer-item--storage {
  border-radius: 0;
  margin-right: 0;
  padding-top: 24px;
  padding-bottom: 24px;
}

.GPL__side-btn__label {
  font-size: 12px;
  line-height: 24px;
  letter-spacing: .01785714em;
  font-weight: 500;
}

@media (min-width: 1024px) {
  .GPL__page-container {
    padding-left: 94px;
  }
}""")
]

# -----------  app init -------------

function __init__()
    add_css(gpl_css)
    add_css(local_material_fonts)
    add_css(navbar_css)
    add_css(pages_css)

    route(home)

    "openbrowser" ∈ ARGS && openbrowser()
    @wait # seemed to interfere with GenieSession, but couldn't be reproduced with the latest version
end

# -----------  precompilation -------------

import Stipple: Genie.Assets.asset_path

@stipple_precompile begin
    println("Precompiling app...")
    context = @__MODULE__
    Genie.config.path_build = @project_path "build"
    let showbanner = parse(Bool, get!(ENV, "GENIE_BANNER", "true"))
        ENV["GENIE_BANNER"] = false
        Genie.Loader.loadenv(; context)
        ENV["GENIE_BANNER"] = showbanner
    end

    @init(MyApp; core_theme = false)
    route(home)
    # this has to be called in order to initialize the assets
    precompile_get("/")
    # now we can call the assetfile
    precompile_get(asset_path(MyApp))
    precompile_get(asset_path(StippleUI.assets_config, :css, file = "quasar.prod"))
end

end # module