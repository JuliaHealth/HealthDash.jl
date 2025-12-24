# Extension registry and contract

struct ExtensionRegistry
    id::String
    name::String
    description::String
    ui_component::Function
end

const EXTENSIONS_REGISTRY = Dict{String, ExtensionRegistry}()

function register_extension(spec::ExtensionRegistry)
    EXTENSIONS_REGISTRY[spec.id] = spec
end

function list_extensions()
    return collect(values(EXTENSIONS_REGISTRY))
end

function get_extension(id::String)
    return get(EXTENSIONS_REGISTRY, id, nothing)
end
