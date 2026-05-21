# Extension registry and contract

struct ExtensionRegistry
    id::String
    name::String
    description::String
    ui_component::Function
    run::Union{Function, Nothing}
    inputs::Vector{String}
end

function ExtensionRegistry(
    id::String,
    name::String,
    description::String,
    ui_component::Function;
    run::Union{Function, Nothing} = nothing,
    inputs::Vector{String} = String[],
)
    return ExtensionRegistry(id, name, description, ui_component, run, inputs)
end

const EXTENSIONS_REGISTRY = Dict{String, ExtensionRegistry}()
const EXTENSIONS_ORDER = String[]

function register_extension(spec::ExtensionRegistry)
    EXTENSIONS_REGISTRY[spec.id] = spec
    if !(spec.id in EXTENSIONS_ORDER)
        push!(EXTENSIONS_ORDER, spec.id)
    end
end

function list_extensions()
    return [EXTENSIONS_REGISTRY[id] for id in EXTENSIONS_ORDER if haskey(EXTENSIONS_REGISTRY, id)]
end

function get_extension(id::String)
    return get(EXTENSIONS_REGISTRY, id, nothing)
end

function extension_manifest(spec::ExtensionRegistry)
    return Dict(
        "id" => spec.id,
        "name" => spec.name,
        "description" => spec.description,
        "inputs" => spec.inputs,
        "has_ui" => spec.ui_component !== nothing,
        "has_run" => spec.run !== nothing,
    )
end

function list_extension_manifests()
    return [extension_manifest(ext) for ext in list_extensions()]
end
