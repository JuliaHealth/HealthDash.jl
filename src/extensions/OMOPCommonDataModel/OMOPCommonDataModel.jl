"""
    OMOPCommonDataModelExtension

An explorer for the OMOP Common Data Model, backed by
[OMOPCommonDataModel.jl](https://github.com/JuliaHealth/OMOPCommonDataModel.jl).

Every CDM table is a struct in that package, so we reflect over them and let
you pick a table from a dropdown to see its struct name, CDM table name, and
every field with its type. Selecting a table updates the view instantly - the
whole schema is rendered up front and shown/hidden with Vue, so there's no
page reload and no network call.
"""
module OMOPCommonDataModelExtension

using Stipple
using OMOPCommonDataModel

export omop_ui

"""
    cdm_tables() -> Vector{DataType}

Return every OMOP CDM table type defined by `OMOPCommonDataModel`, sorted by
table name.

Each CDM table (`person`, `drug_exposure`, ...) is a `struct` that subtypes
`OMOPCommonDataModel.CDMType`. This walks every binding in that package and
keeps the concrete structs that subtype `CDMType` - nothing about the schema
is hard-coded here, so it always matches the installed package version.

# Example
```julia
using OMOPCommonDataModel

tables = cdm_tables()
length(tables)          # => number of CDM tables (e.g. 39)
first(tables)           # => OMOPCommonDataModel.AttributeDefinition
```
"""
function cdm_tables()
    tables = DataType[]
    for sym in names(OMOPCommonDataModel; all = true)
        isdefined(OMOPCommonDataModel, sym) || continue
        value = getfield(OMOPCommonDataModel, sym)
        value isa DataType && value !== CDMType && value <: CDMType || continue
        push!(tables, value)
    end
    return sort(tables; by = table_name)
end

"""
    table_name(T::DataType) -> String

Convert a CDM struct type to its OMOP table name, e.g. `ConceptAncestor` ->
`"concept_ancestor"`. Handles the camelCase boundaries, including runs of
capitals (`CDMSource` -> `"cdm_source"`).

# Example
```julia
table_name(OMOPCommonDataModel.DrugExposure)   # => "drug_exposure"
```
"""
function table_name(T::DataType)
    name = string(nameof(T))
    name = replace(name, r"([a-z0-9])([A-Z])" => s"\1_\2")
    name = replace(name, r"([A-Z]+)([A-Z][a-z])" => s"\1_\2")
    return lowercase(name)
end

"""
    field_items(T::DataType) -> String

Build the HTML `<li>` list of a table's columns. Each field of the struct is a
CDM column, and its Julia type is the column type. A `Union{..., Missing}`
field is a nullable column, so it is unwrapped with `nonmissingtype` and
tagged as optional.
"""
function field_items(T::DataType)
    io = IOBuffer()
    for field in fieldnames(T)
        ftype = fieldtype(T, field)
        optional = Missing <: ftype
        base = optional ? nonmissingtype(ftype) : ftype
        print(io, "<li><code>", field, "::", base, "</code>")
        optional && print(io, " <span class=\"ext-optional\">optional</span>")
        print(io, "</li>")
    end
    return String(take!(io))
end

"""
    table_details(T::DataType) -> String

Render the detail panel for one CDM table: its qualified struct name, the CDM
table name from [`table_name`](@ref), the `struct ... <: CDMType` line, and the
column list from [`field_items`](@ref).
"""
function table_details(T::DataType)
    sname = string(nameof(T))
    return """
      <div class="ext-detail-title">OMOPCommonDataModel.$sname</div>
      <dl class="ext-meta">
        <div><dt>CDM table name</dt><dd>$(uppercase(table_name(T)))</dd></div>
        <div><dt>Julia struct name</dt><dd>$sname</dd></div>
      </dl>
      <pre class="ext-code">struct $sname &lt;: CDMType</pre>
      <ul class="ext-fields">$(field_items(T))</ul>
    """
end

"""
    omop_ui() -> Stipple.ParsedHTMLString

Build the OMOP CDM Explorer shown on the dashboard: a dropdown of every table
from [`cdm_tables`](@ref) plus one hidden detail panel per table. Picking a
table reveals its panel client-side with Vue (`v-model` + `v-show`), so there
is no page reload.
"""
function omop_ui()
    tables = cdm_tables()

    options = IOBuffer()
    print(options, "<option value=\"\">Select a table…</option>")
    for T in tables
        print(options, "<option value=\"", nameof(T), "\">", table_name(T), "</option>")
    end

    details = IOBuffer()
    for T in tables
        print(details,
            "<div class=\"ext-detail\" v-show=\"omop_selected_table === '", nameof(T), "'\">",
            table_details(T), "</div>")
    end

    html = """
    <div class="ext-root">
      <h4 class="ext-heading">OMOP CDM Explorer</h4>
      <p class="ext-subtitle">
        Pick any of the $(length(tables)) OMOP CDM tables to see its Julia
        struct and fields, straight from OMOPCommonDataModel.jl.
      </p>

      <div class="ext-field">
        <label class="ext-label">CDM table</label>
        <select class="ext-select" v-model="omop_selected_table">$(String(take!(options)))</select>
      </div>

      <p class="ext-prompt" v-show="omop_selected_table === ''">
        Choose a table above to see its struct and fields.
      </p>
      $(String(take!(details)))
    </div>
    """

    return Stipple.ParsedHTMLString(html)
end

end

register_extension(ExtensionRegistry(
    "omop-cdm",
    "OMOPCommonDataModel",
    "Explore the OMOP Common Data Model tables defined by OMOPCommonDataModel.jl.",
    OMOPCommonDataModelExtension.omop_ui;
    source_module = OMOPCommonDataModelExtension,
))
