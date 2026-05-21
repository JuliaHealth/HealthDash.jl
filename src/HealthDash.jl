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
include(joinpath(@__DIR__, "extensions", "helpers.jl"))
include(joinpath(@__DIR__, "extensions", "Template", "Template.jl"))
include(joinpath(@__DIR__, "data", "services.jl"))
include(joinpath(@__DIR__, "pages", "Docs.jl"))
include(joinpath(@__DIR__, "pages", "Dashboard.jl"))

import Genie.Assets.asset_path
import Genie.Renderer.Json: json
import Genie.Requests: getpayload
import Genie.Router.Route
import Genie.Router: params
import Genie.Server.openbrowser
import Genie.Util: @wait

export openbrowser, @wait

register_extension(ExtensionRegistry(
    "template",
    "Template",
    "Starter module for package authors.",
    TemplateExtension.template_ui,
))

@app MyApp begin
    @in selected_dashboard_item = "template"

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

docs::Route = route("/docs") do
    render_app(docs_page())
end

dashboard::Route = route("/dashboard") do
    render_app(dashboard_page())
end

function request_kwargs()
    payload = getpayload()
    isempty(payload) && return (;)

    pairs = Pair{Symbol, Any}[]
    for (key, value) in payload
        push!(pairs, Symbol(key) => value)
    end
    return (; pairs...)
end

modules_api::Route = route("/api/modules") do
    json(Dict("modules" => list_extension_manifests()))
end

modules_run::Route = route("/api/modules/run/:id") do
    id = string(params(:id))
    ext = get_extension(id)

    ext === nothing && return json(Dict("error" => "Unknown module", "id" => id))
    ext.run === nothing && return json(Dict("error" => "Module has no run handler", "id" => id))

    try
        result = ext.run(; request_kwargs()...)
        json(Dict("id" => id, "result" => result))
    catch err
        json(Dict(
            "id" => id,
            "error" => "Module run failed",
            "details" => sprint(showerror, err),
        ))
    end
end

function __init__()
    add_css(local_material_fonts)
    add_css(navbar_css)
    add_css(docs_css)
    add_css(dashboard_css)
    add_css(extensions_css)

    route(home)
    route(docs)
    route(dashboard)
    route(modules_api)
    route(modules_run)

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
    precompile_get("/")
    precompile_get(asset_path(MyApp))
    precompile_get(asset_path(StippleUI.assets_config, :css, file = "quasar.prod"))
end

end # module
