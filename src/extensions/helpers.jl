module ExtensionHelpers

using Stipple
using StippleUI

export ext_root, ext_note, ext_list

function ext_root(title::String, subtitle::String, sections::Vector)
    return htmldiv(class = "ext-root q-pa-md", [
        h4(title, class = "ext-heading"),
        p(subtitle, class = "ext-subtitle"),
        sections...,
    ])
end

function ext_note(title::String, body::Vector)
    return htmldiv(class = "ext-note", [
        h5(title),
        body...,
    ])
end

function ext_list(items::Vector{String})
    list_html = "<ul>" * join(["<li>$(item)</li>" for item in items], "") * "</ul>"
    return Stipple.ParsedHTMLString(list_html)
end

end
