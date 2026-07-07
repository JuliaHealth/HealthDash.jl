using Documenter
using DocumenterVitepress
using HealthDash

service_dir = joinpath(@__DIR__, "src", "services")
rm(service_dir; force = true, recursive = true)
mkpath(service_dir)

service_pages = Any[]
for ext in HealthDash.list_extensions()
    ext.source_module === nothing && continue
    modname = string(nameof(ext.source_module))
    page = "services/$(modname).md"
    open(joinpath(@__DIR__, "src", page), "w") do io
        println(io, "# ", ext.name, "\n")
        println(io, "```@autodocs")
        println(io, "Modules = [HealthDash.", modname, "]")
        println(io, "```")
    end
    push!(service_pages, ext.name => page)
end

makedocs(;
    modules = [HealthDash],
    sitename = "HealthDash.jl",
    remotes = Dict(
        pkgdir(HealthDash) => (Documenter.Remotes.GitHub("JuliaHealth", "HealthDash.jl"), "main"),
    ),
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/JuliaHealth/HealthDash.jl",
        devbranch = "main",
        devurl = "dev",
    ),
    pages = [
        "Home" => "index.md",
        "Adding Your Project" => "adding-a-project.md",
        "Service Docs" => service_pages,
    ],
)

DocumenterVitepress.deploydocs(;
    repo = "github.com/JuliaHealth/HealthDash.jl",
    devbranch = "main",
)
