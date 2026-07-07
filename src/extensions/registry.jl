# Registry of dashboard extensions.

struct ExtensionRegistry
    id::String
    name::String
    description::String
    ui_component::Function
    source_module::Union{Module, Nothing}
end

function ExtensionRegistry(
    id::String,
    name::String,
    description::String,
    ui_component::Function;
    source_module::Union{Module, Nothing} = nothing,
)
    return ExtensionRegistry(id, name, description, ui_component, source_module)
end

const EXTENSIONS_REGISTRY = Dict{String, ExtensionRegistry}()
const EXTENSIONS_ORDER = String[]

function register_extension(spec::ExtensionRegistry)
    EXTENSIONS_REGISTRY[spec.id] = spec
    spec.id in EXTENSIONS_ORDER || push!(EXTENSIONS_ORDER, spec.id)
    return spec
end

list_extensions() = [EXTENSIONS_REGISTRY[id] for id in EXTENSIONS_ORDER]

function extension_manifest(spec::ExtensionRegistry)
    return Dict(
        "id" => spec.id,
        "name" => spec.name,
        "description" => spec.description,
    )
end

list_extension_manifests() = [extension_manifest(ext) for ext in list_extensions()]

extension_modules() = [ext.source_module for ext in list_extensions() if ext.source_module !== nothing]
