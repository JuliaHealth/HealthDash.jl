module HealthDash

using Stipple, Stipple.ReactiveTools
using StippleUI

include(joinpath(@__DIR__, "components", "Navbar.jl"))
include(joinpath(@__DIR__, "pages", "Home.jl"))
using Dates
HTTP::Module = Genie.HTTPUtils.HTTP

import Stipple: opts, hget
import Genie.Router.Route
import Genie.Generator.Logging
import Genie.Assets.asset_path
import Genie.Server.openbrowser
import Genie.Util: @wait

export openbrowser, @wait

function get_channel(s::String)
    match(r"\(\) => window.create[^']+'([^']+)'", s).captures[1]
end

function get_channel(::Nothing)
    @warn "No channel found in the HTML, using default channel '/'"
    "____"
end

global websocket::Union{Nothing, HTTP.WebSockets.WebSocket} = nothing

function ws_send(messages = String[], payloads::Array{<:AbstractDict} = fill(Dict());
    verbose::Bool = true,
    host::String = "localhost",
    port::Int = Genie.config.server_port,
    channel = get_channel(hget("/"))
)
    pushfirst!(messages, "subscribe")
    push!(messages, "unsubscribe")
    if payloads isa Vector
        pushfirst!(payloads, Dict())
        push!(payloads, Dict())
    end
    HTTP.WebSockets.open("ws://$host:$port") do ws
        messages = Dict.("channel" => channel, "message" .=> messages, "payload" .=> payloads)
        for msg in messages
            HTTP.WebSockets.send(ws, json(msg))
        end

        for msg in ws
            verbose && println("Received: $msg")
            if msg == "Unsubscription: OK" || contains(msg, "ERROR")
                sleep(0.1)
                close(ws)
                break
            end
        end
    end
    nothing
end

t_startup::DateTime = DateTime(0)

@app MyApp begin
    @in x = 1.0
    @in search = ""
    @in storage = 0.26

    @onchange isready begin
        global t_startup
        if t_startup != DateTime(0)
            @info "Startup time: $(now() - t_startup)"
            t_startup = DateTime(0)
        end
    end
end

local_material_fonts() = (stylesheet("/iconsets/material/font/material.css"),)

ui() = UI

home_route::Route = route("/") do
    core_theme = false
    global model = @init(MyApp; core_theme)

    page(model, home; core_theme) |> html
end
# -----------  app init -------------

function __init__()
    global t_startup = now()
    cd(@project_path)
    Genie.config.path_build = @project_path "build"
    Genie.Loader.loadenv(; context = @__MODULE__)
    up()

    add_css(local_material_fonts)

    route(home_route)
    "openbrowser" ∈ ARGS && openbrowser()
    # @wait, interferes with GenieSession, needs to be placed outside __init__
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
    route(home_route)
    channel = get_channel(precompile_get("/").body |> String)
    precompile_get(asset_path(MyApp))
    precompile_get(asset_path(StippleUI.assets_config, :css, file = "quasar.prod"))
    println("""
        Precompiling WebSocket connection...
        Please ignore a potential timeout warning!
    """)
    ws_send(; port, channel)
end

end # module