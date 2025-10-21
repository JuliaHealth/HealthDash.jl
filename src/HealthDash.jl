module HealthDash

using Stipple, Stipple.ReactiveTools
using Dates
HTTP::Module = Genie.HTTPUtils.HTTP

import Stipple: hget
import Genie.Router.Route
import Genie.Generator.Logging
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

home::Route = route("/") do
    return "Welcome to HealthDash.jl"
end

# -----------  app init -------------

function __init__()
    global t_startup = now()
    cd(@project_path)
    Genie.config.path_build = @project_path "build"
    Genie.Loader.loadenv(; context = @__MODULE__)
    up()

    println("Welcome to HealthDash.jl")
    route(home)
    "openbrowser" ∈ ARGS && openbrowser()
    # @wait, interferes with GenieSession, needs to be placed outside __init__
end

end # module
