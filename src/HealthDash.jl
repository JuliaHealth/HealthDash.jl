module HealthDash

# Load the Genie environment before the app module initializes.
module GenieEnvLoader
    using Genie, Dates

    t_startup::DateTime = DateTime(0)

    function __init__()
        global t_startup = now()
        cd(@project_path)
        Genie.config.path_build = @project_path "build"
        Genie.Loader.loadenv(; context = @__MODULE__)
    end
end

import .GenieEnvLoader.t_startup

using Dates
using Stipple, Stipple.ReactiveTools
using Stipple.ModelStorage.Sessions.GenieSession
using StippleUI

include(joinpath(@__DIR__, "components", "Navbar.jl"))
include(joinpath(@__DIR__, "extensions", "registry.jl"))
include(joinpath(@__DIR__, "extensions", "loader.jl"))
include(joinpath(@__DIR__, "pages", "Docs.jl"))
include(joinpath(@__DIR__, "pages", "Dashboard.jl"))

import Genie.Assets.asset_path
import Genie.Renderer.Json: json
import Genie.Router.Route
import Genie.Server.openbrowser
import Genie.Util: @wait

export openbrowser, @wait

load_extensions()

@app MyApp begin
    @in selected_dashboard_item = "template"
    @in omop_selected_table = ""

    @onchange isready begin
        global t_startup
        if t_startup != DateTime(0)
            println()
            @info "Serving from $(pwd())"
            @info "Startup time: $(now() - t_startup)"
            t_startup = DateTime(0)
        end
    end
end

local_material_fonts() = (stylesheet("/iconsets/material/font/material.css"),)
navbar_css() = (stylesheet("/css/navbar.css"),)
docs_css() = (stylesheet("/css/docs.css"),)
dashboard_css() = (stylesheet("/css/dashboard.css"),)
extensions_css() = (stylesheet("/css/extensions/extensions.css"),)

function render_app(content)
    global hh = session()
    core_theme = false
    global model = @init(MyApp; core_theme)
    GenieSession.set!(session(), :hh, "hh")
    return page(model, content; core_theme) |> html
end

home::Route = route("/") do
    render_app(docs_page())
end

dashboard::Route = route("/dashboard") do
    render_app(dashboard_page())
end

modules_api::Route = route("/api/modules") do
    json(Dict("modules" => list_extension_manifests()))
end

function __init__()
    add_css(local_material_fonts)
    add_css(navbar_css)
    add_css(docs_css)
    add_css(dashboard_css)
    add_css(extensions_css)

    route(home)
    route(dashboard)
    route(modules_api)

    up()

    "openbrowser" in ARGS && openbrowser()
end

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
    route(dashboard)
    precompile_get("/")
    precompile_get("/dashboard")
    precompile_get(asset_path(MyApp))
    precompile_get(asset_path(StippleUI.assets_config, :css, file = "quasar.prod"))
end

end 
