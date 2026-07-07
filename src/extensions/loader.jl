function load_extensions()
    extensions_dir = @__DIR__

    folders = filter(readdir(extensions_dir)) do entry
        isdir(joinpath(extensions_dir, entry))
    end

    ordered = vcat(
        filter(==("Template"), folders),
        sort(filter(!=("Template"), folders)),
    )

    for entry in ordered
        main_file = joinpath(extensions_dir, entry, entry * ".jl")
        isfile(main_file) && include(main_file)
    end
end
