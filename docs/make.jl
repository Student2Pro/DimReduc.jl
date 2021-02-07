using DimReduc
using Documenter

makedocs(;
    modules=[DimReduc],
    authors="Alex",
    repo="https://github.com/Student2Pro/DimReduc.jl/blob/{commit}{path}#L{line}",
    sitename="DimReduc.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Student2Pro.github.io/DimReduc.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Student2Pro/DimReduc.jl",
)
